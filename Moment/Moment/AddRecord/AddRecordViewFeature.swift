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
        var address: String = ""                        // 주소
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
            [myLocationAlias, paragraph, content].contains("") || page.isEmpty || selectedImages.isEmpty
        }
        var showPhotoConfimationDialog: Bool = false    // 카메라 / 라이브러리 선택 다이얼로그
        var isCameraSnapSheet: Bool = false             // 카메라 사진 찍기 시트 열기
        var isPhotoPickerSheet: Bool = false            // 라이브러리 사진 선택하기 시트 열기
        var filmedPhoto = UIImage()                     // 카메라로 촬영 된 사진 한장
        let maxSelectImageCount = 3                     // 최대 사진 선택 개순
        // focus state 필드 enum
        enum Field {
            case myLocationAlias
            case paragraph
            case page
            case content
        }
    }
    
    enum Action: BindableAction {
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        case changeFocusedField
        case clearFocusedField
        case dismiss
        case fetchLocation
        case removePhoto(Int)
        case setContent(String)
        case setMyLocationAlias(String)
        case setPage(String)
        case setParagraph(String)
        case setLocationInfo((Double, Double, String, String))
        case togglePhotoConfimationDialog
        // alert
        enum Alert: Equatable {
            
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.locationManagerService) var locationManager
    
    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
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
            // 선택된 사진 배열에서 해당 인덱스의 이미지 삭제
            case let .removePhoto(index):
                state.selectedImages.remove(at: index)
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
