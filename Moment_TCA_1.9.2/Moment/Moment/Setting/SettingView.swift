//
//  SettingView.swift
//  Moment
//
//  Created by phang on 5/16/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - SettingView
struct SettingView: View {
    @Bindable var store: StoreOf<SettingViewFeature>
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let geoWidth = geo.size.width
                VStack(alignment: .leading, spacing: 10) {
                    // 이름 변경
                    HStack(alignment: .center) {
                        // 이름
                        Text(store.userName)
                            .font(.bold20)
                            .foregroundStyle(.darkBrown)
                        //
                        Spacer()
                        // 변경 버튼
                        Button {
                            // 변경 시트 오픈
                            store.send(.openUpdateNameSheet)
                        } label: {
                            HStack(alignment: .center, spacing: 4) {
                                Text(AppLocalized.change)
                                    .font(.regular16)
                                Image(systemName: AppLocalized.rightImage)
                            }
                            .foregroundStyle(.gray1)
                        }
                    }
                    //
                    CustomListDivider()
                        .padding(.vertical, 10)
                    //
                    VStack(alignment: .leading, spacing: 4) {
                        Text(AppLocalized.dataTitle)
                            .font(.medium18)
                            .foregroundStyle(.darkBrown)
                        Text(AppLocalized.dataSubTitle)
                            .font(.light14)
                            .foregroundStyle(.mainBrown)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        // 백업
                        Button {
                            store.send(.backupButtonTapped)
                        } label: {
                            HStack {
                                Text(AppLocalized.dataBackUpButton)
                                    .font(.regular16)
                                    .foregroundStyle(.darkBrown)
                            }
                            .modifier(SettingListCell(width: geoWidth - 40))
                        }
                        .background(
                            ActivityView(store: store)
                        )
                        // 복원
                        Button {
                            store.send(.restoreButtonTapped)
                        } label: {
                            HStack {
                                Text(AppLocalized.dataRestoreButton)
                                    .font(.regular16)
                                    .foregroundStyle(.darkBrown)
                            }
                            .modifier(SettingListCell(width: geoWidth - 40))
                        }
                        .background(
                            DocumentPickerView(store: store)
                        )
                    }
                    //
                    CustomListDivider()
                        .padding(.vertical, 10)
                    //
                    Text(AppLocalized.appInfoTitle)
                        .font(.medium18)
                        .foregroundStyle(.darkBrown)
                    //
                    VStack(alignment: .leading, spacing: 6) {
                        // 앱 정보
                        HStack {
                            //
                            Text(AppLocalized.appVersionTitle)
                                .font(.regular16)
                                .foregroundStyle(.darkBrown)
                            //
                            Spacer()
                            //
                            Text("\(AppLocalized.appVersionSubTitle) \(store.version ?? .empty).\(store.build ?? .empty)")
                                .font(.regular14)
                                .foregroundStyle(.gray1)
                        }
                        .modifier(SettingListCell(width: geoWidth - 40))
                        // What's Moment?
                        Button {
                            // TODO: - 모멘트 정보 뷰 이동
                        } label: {
                            HStack {
                                Text(AppLocalized.aboutMomentButton)
                                    .font(.regular16)
                                    .foregroundStyle(.darkBrown)
                            }
                            .modifier(SettingListCell(width: geoWidth - 40))
                        }
                        // 오픈라이선스
                        Button {
                            // TODO: - 오픈라이선스 뷰 이동
                        } label: {
                            HStack {
                                Text(AppLocalized.openSourceButton)
                                    .font(.regular16)
                                    .foregroundStyle(.darkBrown)
                            }
                            .modifier(SettingListCell(width: geoWidth - 40))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                // 복원 전, 백업 알림
                .alert($store.scope(
                    state: \.destination?.alert,
                    action: \.destination.alert))
                // UserName Update Sheet
                .sheet(item: $store.scope(state: \.destination?.updateUserName,
                                          action: \.destination.updateUserName)) { store in
                    UpdateUserNameView(store: store)
                        .presentationDragIndicator(.visible)
                }.navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            store.send(.dismiss)
                        } label: {
                            Image(systemName: AppLocalized.beforeImage)
                                .aspectRatio(contentMode: .fit)
                        }
                        .disabled(store.isCompressing)
                    }
                    ToolbarItem(placement: .principal) {
                        Text(AppLocalized.settingTitle)
                            .font(.semibold18)
                            .foregroundStyle(.darkBrown)
                    }
                }
            }
            // 백업 / 복원 시, 로딩 로티 뷰
            if store.isCompressing || store.isDecompressing {
                LottieLoadingView()
                    .zIndex(1)
            }
        }
    }
    
    // MARK: - 로티 사용 로딩 뷰
    private func LottieLoadingView() -> some View {
        VStack {
            LottieView(jsonName: AppLocalized.loadingLottie)
        }
        .background(.black.opacity(0.15))
    }
}

// MARK: - Setting 리스트 셀 디자인
private struct SettingListCell: ViewModifier {
    let width: Double
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 10)
            .frame(width: width,
                   height: 40,
                   alignment: .leading)
            .background(.gray6)
            .clipShape(.rect(cornerRadius: 10))
    }
}
