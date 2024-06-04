//
//  RecordDetailViewFeature.swift
//  Moment
//
//  Created by phang on 4/4/24.
//

import SwiftUI
import MapKit

import ComposableArchitecture

// MARK: - Record Detail View Reducer
@Reducer
struct RecordDetailViewFeature {
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?      // alert
        let record: MomentRecord                            // 선택된 해당 기록
        let isRecordIsLast: Bool                            // 해당 기록이 책에 관련된 마지막 기록인지
        let book: MomentBook                                // 선택 된 기록의 책 데이터
        var region: MapCameraPosition                       // 미니맵에 띄울 지역 - 카메라 포지션
    }
    
    enum Action {
        case alert(PresentationAction<Alert>)
        case deleteBook
        case deleteRecord
        case deleteRecordButtonTapped
        case dismiss
        case initialNavigationStack
        case initialRegion(CLLocationCoordinate2D)
        case refetchBooksAndRecords
        case setRegion(MapCameraPosition)
        // alert
        enum Alert: Equatable {
            case deleteRecordConfirm
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.swiftDataService) var swiftData
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // 해당 기록 삭제 시, alert
            case .alert(.presented(.deleteRecordConfirm)):
                return .run { @MainActor [isRecordIsLast = state.isRecordIsLast] send in
                    // 해당 기록이 책의 마지막 기록일 때,
                    if isRecordIsLast {
                        send(.deleteBook)
                        send(.deleteRecord)
                        send(.initialNavigationStack)
                    // 책에 다른 기록이 더 남아 있을 때,
                    } else {
                        send(.deleteRecord)
                        send(.dismiss)
                    }
                }
            //
            case .alert:
                return .none
            // swiftData - 책 삭제
            case .deleteBook:
                return .run { @MainActor [book = state.book] send in
                    do {
                        try swiftData.deleteBook(book)
                    } catch {
                        print("error :: RecordDetailView - deleteBook", error.localizedDescription)
                    }
                }
            // swiftData - 기록 삭제
            case .deleteRecord:
                return .run { @MainActor [record = state.record] send in
                    do {
                        try swiftData.deleteRecord(record)
                        send(.refetchBooksAndRecords)
                    } catch {
                        print("error :: RecordDetailView - deleteRecord", error.localizedDescription)
                    }
                }
            // 기록 삭제
            case .deleteRecordButtonTapped:
                state.alert = .deleteConfirm()
                return .none
            // 뒤로가기
            case .dismiss:
                return .run { send in
                    await self.dismiss()
                }
            // 첫 화면으로 돌아가기
            case .initialNavigationStack:
                return .none
            // 'region' 초기화
            case let .initialRegion(originalValue):
                state.region = MapCameraPosition.region(
                    MKCoordinateRegion(center: originalValue,
                                       span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                              longitudeDelta: 0.01)))
                return .none
            // 기록 삭제 이후, 최초 홈화면에서 refetch 받기 위함
            case .refetchBooksAndRecords:
                return .none
            // 'region' 값 변경
            case let .setRegion(newPosition):
                state.region = newPosition
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - Alert in RecordDetailViewFeature
extension AlertState where Action == RecordDetailViewFeature.Action.Alert {
    
    // 삭제 알림
    static func deleteConfirm() -> Self {
        Self {
            TextState(AppLocalized.deleteRecordAlertText)
        } actions: {
            ButtonState(role: .destructive, action: .deleteRecordConfirm) {
                TextState(AppLocalized.deleteButton)
            }
        }
    }
}
