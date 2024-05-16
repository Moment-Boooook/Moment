//
//  SettingViewFeature.swift
//  Moment
//
//  Created by phang on 5/16/24.
//

import Foundation

import ComposableArchitecture

// MARK: - Setting View Reducer
@Reducer
struct SettingViewFeature {
    
    @ObservableState
    struct State: Equatable {
        @ObservationStateIgnored
        @Shared var userName: String
        
        @Presents var destination: Destination.State?
        
        var version: String? {
            guard let dictionary = Bundle.main.infoDictionary,
                  let version = dictionary["CFBundleShortVersionString"] as? String else { return nil }
            return version  // ex) 1.0
        }
        
        var build: String? {
            guard let dictionary = Bundle.main.infoDictionary,
                  let build = dictionary["CFBundleVersion"] as? String else { return nil }
            return build    // ex) 1
        }
    }
    
    enum Action {
        case dismiss
        case destination(PresentationAction<Destination.Action>)
        case openUpdateNameSheet
        case restoreButtonTapped
        
        enum Alert: Equatable {
            case dataRestoreConfirm
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // 뒤로가기
            case .dismiss:
                return .run { send in
                    await self.dismiss()
                }
            // alert - 복원 전에 백업해주세요
            case .destination(.presented(.alert(.dataRestoreConfirm))):
                // 복원
                return .none
            //
            case .destination:
                return .none
            // 유저 이름 변경 시트 오픈
            case .openUpdateNameSheet:
                state.destination = .updateUserName(
                    UpdateUserNameFeature.State(
                        userName: state.$userName))
                return .none
            // 복원 버튼 탭
            case .restoreButtonTapped:
                state.destination = .alert(.dataRestoreConfirm())
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: - Destination
extension SettingViewFeature {
    @Reducer(state: .equatable)
    enum Destination {
        case updateUserName(UpdateUserNameFeature)
        case alert(AlertState<SettingViewFeature.Action.Alert>)
    }
}

// MARK: - Alert in SettingViewFeature
extension AlertState where Action == SettingViewFeature.Action.Alert {
    
    // 복원 전, 백업 알림
    static func dataRestoreConfirm() -> Self {
        Self {
            TextState("""
                    복원 시엔 기존 데이터가 사라지니
                    백업을 먼저 추천드려요!
                    """)
        } actions: {
            ButtonState(role: .none, action: .dataRestoreConfirm) {
                TextState("확인")
            }
        }
    }
}
