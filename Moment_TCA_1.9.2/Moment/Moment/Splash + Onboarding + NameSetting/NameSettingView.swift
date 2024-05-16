//
//  NameSettingView.swift
//  Moment
//
//  Created by phang on 5/3/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - Name Setting View
struct NameSettingView: View {
    @Bindable var store: StoreOf<AppStartFeature>
    @FocusState var focusedField: Bool

    var body: some View {
        VStack(alignment: .center) {
            // Lottie 애니메이션 뷰
            LottieView(jsonName: "book")
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 140)
            // 이름 등록 안내 텍스트
            VStack(alignment: .center, spacing: 6) {
                Text("사용할 이름을 등록해주세요!")
                    .font(.medium24)
                // TODO: - 프로필 및 설정 페이지 만든 뒤..
//                Text("이름은 언제든 변경할 수 있어요")
//                    .font(.regular16)
            }
            .padding(.vertical, 20)
            // 이름 textfield
            TextField(
                "이름 설정",
                text: $store.userName.sending(\.setName),
                prompt: Text("\(store.maxLength)자 이내")
                    .font(.regular16)
                    .foregroundStyle(.gray2)
            )
            .focused($focusedField)
            .multilineTextAlignment(.center)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .onChange(of: store.userName) { oldValue, newValue in
                if newValue.count > store.maxLength {
                    store.send(.setName(oldValue))
                }
            }
            .textFieldStyle(
                .bordered(color: store.userName.isEmpty ? .gray2 : .lightBrown)
            )
            .foregroundStyle(.black)
            .frame(height: 20)
            .padding(.vertical, 10)
            .padding(.bottom, 20)
            // 저장 버튼
            Button {
                store.send(.saveName)
            } label: {
                Text("저장")
                    .font(.medium16)
                    .foregroundStyle(.white)
            }
            .disabled(store.userName.isEmpty)
            .buttonStyle(.capsuled(color: store.userName.isEmpty ? .gray3 : .mainBrown,
                                   width: 100))
        }
        .bind($store.focusedField, to: $focusedField)
        .padding(.horizontal, 20)
    }
}

#Preview {
    NameSettingView(
        store: Store(
            initialState: AppStartFeature.State(userName: Shared(""),
                                                books: Shared([]),
                                                records: Shared([]),
                                                currentOnboardingPage: .first)
        ) {
            AppStartFeature()
        }
    )
}
