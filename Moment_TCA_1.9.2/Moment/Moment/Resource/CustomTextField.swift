//
//  CustomTextField.swift
//  Moment
//
//  Created by 정인선 on 12/11/23.
//

import SwiftUI

// MARK: - 텍스트필드 커스텀
struct BorderedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.lightBrown)
                .foregroundStyle(.clear)
            // TextField
            configuration
                .font(.regular14)
                .padding(10)
        }
    }
}

// MARK: - 예시
struct CustomTextField: View {
    var body: some View {
        VStack {
            TextField("TextField Placeholder", text: .constant("example"))
                .textFieldStyle(BorderedTextFieldStyle())
        }
        .frame(height: 10)
        .padding()
    }
}

#Preview {
    CustomTextField()
}
