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
                            Text("변경")
                                .font(.regular16)
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(.gray1)
                    }
                }
                //
                CustomListDivider()
                    .padding(.vertical, 10)
                //
                VStack(alignment: .leading, spacing: 4) {
                    Text("데이터")
                        .font(.medium18)
                        .foregroundStyle(.darkBrown)
                    Text("""
                    Moment 의 기억을 파일로 백업하여
                    새로운 기기로 옮길 수 있어요
                    """)
                    .font(.light14)
                    .foregroundStyle(.mainBrown)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Button {
                        // 백업
                    } label: {
                        HStack {
                            Text("데이터 백업하기")
                                .font(.regular16)
                                .foregroundStyle(.darkBrown)
                        }
                        .modifier(SettingListCell(width: geoWidth - 40))
                    }
                    Button {
                        store.send(.restoreButtonTapped)
                    } label: {
                        HStack {
                            Text("데이터 복원하기")
                                .font(.regular16)
                                .foregroundStyle(.darkBrown)
                        }
                        .modifier(SettingListCell(width: geoWidth - 40))
                    }
                }
                //
                CustomListDivider()
                    .padding(.vertical, 10)
                //
                Text("앱 정보")
                    .font(.medium18)
                    .foregroundStyle(.darkBrown)
                //
                HStack {
                    //
                    Text("Moment 버전")
                        .font(.regular16)
                        .foregroundStyle(.darkBrown)
                    //
                    Spacer()
                    //
                    Text("버전 정보 \(store.version ?? "1.0").\(store.build ?? "1")")
                        .font(.regular14)
                        .foregroundStyle(.gray1)
                }
                .modifier(SettingListCell(width: geoWidth - 40))
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
            }
            .presentationDragIndicator(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        store.send(.dismiss)
                    } label: {
                        Image(systemName: "chevron.left")
                            .aspectRatio(contentMode: .fit)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("설정")
                        .font(.semibold18)
                        .foregroundStyle(.darkBrown)
                }
            }
        }
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
