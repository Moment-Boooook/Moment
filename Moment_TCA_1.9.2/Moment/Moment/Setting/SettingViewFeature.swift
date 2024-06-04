//
//  SettingViewFeature.swift
//  Moment
//
//  Created by phang on 5/16/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - Setting View Reducer
@Reducer
struct SettingViewFeature {
    
    @ObservableState
    struct State: Equatable {
        @ObservationStateIgnored
        @Shared var userName: String
        
        @Presents var destination: Destination.State?
        
        // share sheet
        var isActivityViewPresented: Bool = false
        var activityItem: ActivityItem?
        
        // document picker
        var isDocumentPickerViewPresented: Bool = false
        var selectedFileURL: URL?
        
        // backup & restore
        var isCompressing: Bool = false
        var isDecompressing: Bool = false
        
        // 앱 버전
        var version: String? {
            guard let dictionary = Bundle.main.infoDictionary,
                  let version = dictionary[AppLocalized.versionKey] as? String else { return nil }
            return version  // ex) 1.0
        }
        // 앱 빌드 카운트
        var build: String? {
            guard let dictionary = Bundle.main.infoDictionary,
                  let build = dictionary[AppLocalized.buildKey] as? String else { return nil }
            return build    // ex) 1
        }
    }
    
    enum Action {
        case alertCompressFail
        case alertDecompressFail
        case backupButtonTapped
        case closeActivityView
        case closeDocumentPickerView
        case dismiss
        case destination(PresentationAction<Destination.Action>)
        case initialNavigationStack
        case openActivityView
        case openUpdateNameSheet
        case refetchBooksAndRecords
        case restoreButtonTapped
        case setActivityItem(URL)
        case setSelectedFileURL(URL?)
        case toggleIsCompressing
        case toggleIsDecompressing
        
        enum Alert: Equatable {
            case compressFail
            case decompressFail
            case dataRestoreConfirm
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.fileManagerService) var fileManagerService

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // alert CompressFail
            case .alertCompressFail:
                state.destination = .alert(.compressFail())
                return .none
            // alert DecompressFail
            case .alertDecompressFail:
                state.destination = .alert(.decompressFail())
                return .none
            // 백업 버튼 탭
            case .backupButtonTapped:
                return .concatenate(
                    .run { send in
                        await send(.toggleIsCompressing)
                        try await Task.sleep(for: .seconds(0.5))
                    },
                    .run { send in
                        let stream = self.fileManagerService.compressData()
                        do {
                            for try await item in stream {
                                await send(.setActivityItem(item))
                            }
                        } catch {
                            await send(.toggleIsCompressing)
                            await send(.alertCompressFail)
                        }
                    }
                )
            // ActivityView 닫기
            case .closeActivityView:
                state.isActivityViewPresented = false
                return .none
            // DocumentPickerView 닫기
            case .closeDocumentPickerView:
                state.isDocumentPickerViewPresented = false
                return .none
            // 뒤로가기
            case .dismiss:
                return .run { send in
                    await self.dismiss()
                }
            // alert - 압축 실패
            case .destination(.presented(.alert(.compressFail))):
                return .none
            // alert - 복원 전에 백업해주세요
            case .destination(.presented(.alert(.dataRestoreConfirm))):
                state.isDocumentPickerViewPresented = true
                return .none
            // 첫 화면으로 돌아가기
            case .initialNavigationStack:
                return .none
            // ActivityView 열기
            case .openActivityView:
                state.isActivityViewPresented = true
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
            // 복원 이후, 최초 홈화면에서 refetch 받기 위함
            case .refetchBooksAndRecords:
                return .none
            // 복원 버튼 탭
            case .restoreButtonTapped:
                state.destination = .alert(.dataRestoreConfirm())
                return .none
            // 'activityItem' 값 채우기 ( 압축 파일 )
            case let .setActivityItem(result):
                let item = ActivityItemSource(url: result)
                state.activityItem = ActivityItem(items: [item])
                return .concatenate(
                    .run { send in
                        await send(.toggleIsCompressing)
                    },
                    .run { send in
                        await send(.openActivityView)
                    }
                )
            // 'isCompressing' 토글
            case .toggleIsCompressing:
                state.isCompressing.toggle()
                return .none
            // 'isDecompressing' 토글
            case .toggleIsDecompressing:
                state.isDecompressing.toggle()
                return .none
            // 'selectedFileURL' 값 채우기 ( '파일' 에서 압축파일 가져오기 )
            case let .setSelectedFileURL(url):
                state.selectedFileURL = url
                return .concatenate(
                    .run { send in
                        await send(.toggleIsDecompressing)
                        try await Task.sleep(for: .seconds(0.5))
                    },
                    .run { [url = state.selectedFileURL] send in
                        guard let url = url else { return }
                        do {
                            try self.fileManagerService.restoreData(url)
                        } catch {
                            await send(.toggleIsDecompressing)
                            await send(.alertDecompressFail)
                        }
                    },
                    .run { @MainActor send in
                        send(.refetchBooksAndRecords)
                        send(.toggleIsDecompressing)
                    },
                    .run { send in
                        await send(.initialNavigationStack)
                    }
                )
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
            TextState(AppLocalized.dataRestoreAlertText)
        } actions: {
            ButtonState(role: .none, action: .dataRestoreConfirm) {
                TextState(AppLocalized.okButton)
            }
        }
    }
    
    // 압축 실패 알림
    static func compressFail() -> Self {
        Self {
            TextState(AppLocalized.compressFailAlertText)
        } actions: {
            ButtonState(role: .none, action: .compressFail) {
                TextState(AppLocalized.okButton)
            }
        }
    }
    
    // 압축 해제 실패 알림
    static func decompressFail() -> Self {
        Self {
            TextState(AppLocalized.decompressFailAlertText)
        } actions: {
            ButtonState(role: .none, action: .decompressFail) {
                TextState(AppLocalized.okButton)
            }
        }
    }
}
