//
//  CustomTextField.swift
//  Moment
//
//  Created by 정인선 on 12/11/23.
//

import SwiftUI

// MARK: - 텍스트필드 커스텀
struct BorderedTextFieldStyle: TextFieldStyle {
    var color: Color = .lightBrown
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(color)
                .foregroundStyle(.clear)
            // TextField
            configuration
                .font(.regular16)
                .padding(10)
        }
    }
}

// MARK: - 예시
struct CustomTextField: View {
    var body: some View {
        VStack {
            TextField("TextField Placeholder", text: .constant("example"))
                .textFieldStyle(.bordered())
        }
        .frame(height: 10)
        .padding()
    }
}

#Preview {
    CustomTextField()
}
