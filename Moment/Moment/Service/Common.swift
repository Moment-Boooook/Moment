//
//  Common.swift
//  Moment
//
//  Created by phang on 3/28/24.
//

import SwiftUI
import SwiftData

import ComposableArchitecture

// MARK: - Common
struct Commons {
    @AppStorage("isOnboarding")
    static var isOnboardingCompleted: Bool = false
    //
    var isCompleteOnboarding: () -> Bool            // 완료 했는지?
    var completeOnboarding: () -> Void              // 완료로 상태 변경
}

extension Commons: DependencyKey {
    public static let liveValue = Self(
        isCompleteOnboarding: {
            return isOnboardingCompleted
        },
        completeOnboarding: {
            isOnboardingCompleted = true
        }
    )
}
