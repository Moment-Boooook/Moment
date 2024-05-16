//
//  TextFieldStyle +.swift
//  Moment
//
//  Created by phang on 5/3/24.
//

import SwiftUI

// MARK: - ButtonStyle 커스텀 추가
extension TextFieldStyle where Self == BorderedTextFieldStyle {
    static func bordered(color: Color = .lightBrown) -> Self {
        return BorderedTextFieldStyle(color: color)
    }
}
