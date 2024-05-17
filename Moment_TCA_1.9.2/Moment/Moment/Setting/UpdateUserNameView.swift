//
//  UpdateUserNameView.swift
//  Moment
//
//  Created by phang on 5/16/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - UpdateUserNameView in SettingView
struct UpdateUserNameView: View {
    @Bindable var store: StoreOf<UpdateUserNameFeature>
    @FocusState var focusedField: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            //
            Text(AppLocalized.updateNameTitle)
                .font(.medium18)
                .foregroundStyle(.darkBrown)
                .frame(maxWidth: .infinity, alignment: .leading)
            // 유저 닉네임 수정 텍스트 필드
            HStack {
                TextField(
                    AppLocalized.nameTitle,
                    text: $store.changedName.sending(\.setName),
                    prompt: Text(store.userName)
                        .font(.medium16)
                        .foregroundStyle(.gray1))
                .font(.medium16)
                .foregroundStyle(.darkBrown)
                .focused($focusedField)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .bind($store.focusedField, to: $focusedField)
                //
                Spacer()
                // 텍스트 한번에 지우는 xmark 버튼
                if !store.changedName.isEmpty {
                    Button {
                        focusedField = true
                        store.send(.clearName)
                    } label: {
                        Image(systemName: AppLocalized.xImage)
                    }
                }
            }
            .foregroundStyle(.darkBrown)
            .padding(.vertical, 15)
            .padding(.horizontal, 10)
            .background(.gray5)
            .clipShape(.rect(cornerRadius: 10))
            // spacer 대용 (키보드 숨기기 onTapGesture 영역)
            Rectangle()
                .fill(.background)
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .top)
            //
            CustomListDivider()
            //
            Button {
                Task {
                    focusedField = false
                    store.send(.updateUserName(store.changedName))
                }
            } label: {
                Text(AppLocalized.changeButton)
                    .font(.medium18)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
            }
            .disabled(!store.isCompleted)
            .foregroundColor(store.isCompleted ? .white : .gray1)
            .buttonStyle(.borderedProminent)
            .tint(.mainBrown)
        }
        .padding(20)
        .padding(.top, 20)
        .onTapGesture {
            // 포커스 필드 해제
            store.send(.clearFocusState)
        }
    }
}
