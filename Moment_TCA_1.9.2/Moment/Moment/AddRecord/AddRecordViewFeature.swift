//
//  AddRecordViewFeature.swift
//  Moment
//
//  Created by phang on 3/29/24.
//

import SwiftUI
import MapKit

import ComposableArchitecture

// MARK: - Add Record View Reducer
@Reducer
struct AddRecordViewFeature {
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?  // alert
        let book: SelectedBook                          // 이전 화면에서 선택된 책
        let myBooks: [MomentBook]                       // 현재 내가 읽은 책 목록
        var latitude: Double = 0                        // 위치 정보 - 위도
        var longitude: Double = 0                       // 위치 정보 - 경도
        var place: String = ""                          // 위치 정보 - 지역
        var localName: String = ""                      // 위치 정보 - 국가
        var myLocationAlias: String = ""                // 내가 장소를 기억할 이름
        var paragraph: String = ""                      // 기록할 문장
        var page: String = ""                           // 기록할 페이지
        var content: String = ""                        // 기록할 내용
        var selectedImages: [UIImage] = []              // 라이브러리에서 선택된 사진
        var focusedField: Field? = nil                  // focusstate
        var isSaveable: Bool {                          // 기록 저장이 가능한지
            [myLocationAlias, paragraph, content].contains("") ||
            page.isEmpty ||
            selectedImages.isEmpty
        }
        var isPickerMapSheet: Bool = false              // 위치 선택 지도 시트 열기
        var showPhotoConfimationDialog: Bool = false    // 카메라 / 라이브러리 선택 다이얼로그
        var isCameraSnapSheet: Bool = false             // 카메라 사진 찍기 시트 열기
        var isPhotoPickerSheet: Bool = false            // 라이브러리 사진 선택하기 시트 열기
        let maxSelectImageCount = 3                     // 최대 사진 선택 개순
        
        // Equatable
        static func == (lhs: AddRecordViewFeature.State, rhs: AddRecordViewFeature.State) -> Bool {
            return lhs.book.bookISBN == rhs.book.bookISBN
        }
        
        // focus state 필드 enum
        enum Field {
            case myLocationAlias
            case paragraph
            case page
            case content
        }
    }
    
    enum Action: BindableAction {
        case addBook
        case addRecord(Int, String, String, [Data])
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        case changeFocusedField
        case clearFocusedField
        case dismiss
        case fetchLocation
        case initialNavigationStack
        case openCamera
        case openPickerMap
        case openPhotoLibrary
        case refetchBooksAndRecords
        case removePhoto(Int)
        case saveRecord
        case setContent(String)
        case setMyLocationAlias(String)
        case setPage(String)
        case setParagraph(String)
        case setLocationInfo((Double, Double, String, String))
        case togglePhotoConfimationDialog
        // alert
        enum Alert: Equatable {
            case saveRecordConfirm
            case nothing
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.locationManagerService) var locationManager
    @Dependency(\.swiftDataService) var swiftData

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            // swiftData 에 데이터 추가 - 책
            case .addBook:
                do {
                    try swiftData.addBook(
                        MomentBook(bookISBN: state.book.bookISBN,
                                   theCoverOfBook: state.book.theCoverOfBook,
                                   title: state.book.title,
                                   author: state.book.author,
                                   publisher: state.book.publisher,
                                   plot: state.book.plot))
                } catch {
                    print("error :: AddRecordView - addBook", error.localizedDescription)
                }
                return .none
            // swiftData 에 데이터 추가 - 기록
            case let .addRecord(year, monthAndDay, time, photos):
                do {
                    try swiftData.addRecord(
                        MomentRecord(latitude: state.latitude, longitude: state.longitude,
                                     localName: state.localName, myLocation: state.myLocationAlias,
                                     year: year, monthAndDay: monthAndDay,
                                     time: time, paragraph: state.paragraph,
                                     page: state.page, commentary: state.content,
                                     photos: photos, bookISBN: state.book.bookISBN))
                } catch {
                    print("error :: AddRecordView - addRecord", error.localizedDescription)
                }
                return .none
            // 저장 시, alert
            case .alert(.presented(.saveRecordConfirm)):
                // 이미지 / 날짜 변환
                let imageDataList = Formatter.uiImageToData(images: state.selectedImages)
                let (year, monthAndDay, time) = Formatter.formattedDateToString(date: Date())
                // 해당 책이 이미 내 책장에 있을 때,
                if state.myBooks.contains(where: { $0.bookISBN == state.book.bookISBN }) {
                    return .concatenate(
                        .run { @MainActor send in
                            send(.addRecord(year, monthAndDay, time, imageDataList))
                            send(.refetchBooksAndRecords)
                        },
                        .run { send in
                            await send(.initialNavigationStack)
                        }
                    )
                // 해당 책에 대해 첫 기록을 작성할 때,
                } else {
                    return .concatenate (
                        .run { @MainActor send in
                            send(.addBook)
                            send(.addRecord(year, monthAndDay, time, imageDataList))
                            send(.refetchBooksAndRecords)
                        },
                        .run { send in
                            await send(.initialNavigationStack)
                        }
                    )
                }
            // 저장 시, alert : 아무 동작 X
            case .alert(.presented(.nothing)):
                return .none
            //
            case .alert:
                return .none
            //
            case .binding:
                return .none
            // focusstate 이동(변경)
            case .changeFocusedField:
                switch state.focusedField {
                case .myLocationAlias:
                    state.focusedField = .paragraph
                case .paragraph:
                    state.focusedField = .page
                case .page:
                    state.focusedField = .content
                default: // content 포함
                    state.focusedField = nil
                }
                return .none
            // focusstate 해제
            case .clearFocusedField:
                state.focusedField = nil
                return .none
            // 뒤로가기
            case .dismiss:
                return .run { send in
                    await self.dismiss()
                }
            // 현재 위치 정보 가져오기
            case .fetchLocation:
                return .run { send in
                    do {
                        try await send(.setLocationInfo(self.locationManager.fetch()))
                    } catch {
                        print("error :: AddRecordView - fetchLocation", error.localizedDescription)
                    }
                }
            // 첫 화면으로 돌아가기
            case .initialNavigationStack:
                return .none
            // 카메라 시트 열기
            case .openCamera:
                state.isCameraSnapSheet = true
                return .none
            // 'isPickerMapSheet' 값 토글 변경
            case .openPickerMap:
                state.isPickerMapSheet.toggle()
                return .none
            // 사진 앨범 선택 시트 열기
            case .openPhotoLibrary:
                state.isPhotoPickerSheet = true
                return .none
            // 기록 등록 이후, 최초 홈화면에서 refetch 받기 위함
            case .refetchBooksAndRecords:
                return .none
            // 선택된 사진 배열에서 해당 인덱스의 이미지 삭제
            case let .removePhoto(index):
                state.selectedImages.remove(at: index)
                return .none
            // 기록 저장
            case .saveRecord:
                state.alert = .saveConfirm()
                return .none
            // 기록할 내용 입력
            case let .setContent(content):
                state.content = content
                return .none
            // '내가 장소를 기억할 이름' 입력
            case let .setMyLocationAlias(locationName):
                state.myLocationAlias = locationName
                return .none
            // 기록할 페이지 입력
            case let .setPage(page):
                state.page = page
                return .none
            // 기록할 문장 입력
            case let .setParagraph(paragraph):
                state.paragraph = paragraph
                return .none
            // 위치 정보 할당
            case let .setLocationInfo(locationInfo):
                state.latitude = locationInfo.0
                state.longitude = locationInfo.1
                state.place = locationInfo.2
                state.localName = locationInfo.3
                return .none
            // 'showPhotoConfimationDialog' 값 토글 변경
            case .togglePhotoConfimationDialog:
                state.showPhotoConfimationDialog.toggle()
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - Alert in AddRecordViewFeature
extension AlertState where Action == AddRecordViewFeature.Action.Alert {
    
    // 저장 알림
    static func saveConfirm() -> Self {
        Self {
            TextState("저장된 기억은 수정할 수 없어요...🥲")
        } actions: {
            ButtonState(role: .cancel, action: .nothing) {
                TextState("돌아가기")
            }
            ButtonState(role: .none, action: .saveRecordConfirm) {
                TextState("저장하기")
                    .foregroundColor(.mainBrown)
            }
        }
    }
}
