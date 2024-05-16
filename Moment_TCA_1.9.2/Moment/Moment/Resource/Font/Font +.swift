//
//  Font +.swift
//  Moment
//
//  Created by phang on 12/11/23.
//

import SwiftUI

// MARK: - Font 커스텀 [ pretendard ]
extension Font {
    // Bold
    static let bold20: Font = .custom(FontType.Bold.name, size: 20)
    static let bold18: Font = .custom(FontType.Bold.name, size: 18)
    // SemiBold
    static let semibold20: Font = .custom(FontType.SemiBold.name, size: 20)
    static let semibold18: Font = .custom(FontType.SemiBold.name, size: 18)
    static let semibold16: Font = .custom(FontType.SemiBold.name, size: 16)
    // Medium
    static let medium36: Font = .custom(FontType.Medium.name, size: 36)
    static let medium30: Font = .custom(FontType.Medium.name, size: 30)
    static let medium24: Font = .custom(FontType.Medium.name, size: 24)
    static let medium20: Font = .custom(FontType.Medium.name, size: 20)
    static let medium18: Font = .custom(FontType.Medium.name, size: 18)
    static let medium16: Font = .custom(FontType.Medium.name, size: 16)
    static let medium14: Font = .custom(FontType.Medium.name, size: 14)
    // Regular
    static let regular20: Font = .custom(FontType.Regular.name, size: 20)
    static let regular18: Font = .custom(FontType.Regular.name, size: 18)
    static let regular16: Font = .custom(FontType.Regular.name, size: 16)
    static let regular14: Font = .custom(FontType.Regular.name, size: 14)
    // Light
    static let light20: Font = .custom(FontType.Light.name, size: 20)
    static let light16: Font = .custom(FontType.Light.name, size: 16)
    static let light14: Font = .custom(FontType.Light.name, size: 14)
}

enum FontType {
    case Bold
    case SemiBold
    case Medium
    case Regular
    case Light
    
    var name: String {
        switch self {
        case .Bold: 
            return "Pretendard-Bold"
        case .SemiBold: 
            return "Pretendard-SemiBold"
        case .Medium: 
            return "Pretendard-Medium"
        case .Regular: 
            return "Pretendard-Regular"
        case .Light: 
            return "Pretendard-Light"
        }
    }
}
