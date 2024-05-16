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
    @AppStorage("isOnboardingAndSetName")
    static var isOnboardingCompletedAndSetName: Bool = false
    
    //
    var isCompleteOnboardingAndSetName: () -> Bool            // 완료 했는지?
    var completeOnboardingAndSetName: () -> Void              // 완료로 상태 변경
}

extension Commons: DependencyKey {
    public static let liveValue = Self(
        isCompleteOnboardingAndSetName: {
            return isOnboardingCompletedAndSetName
        },
        completeOnboardingAndSetName: {
            isOnboardingCompletedAndSetName = true
        }
    )
}

// MARK: - TCA : DependencyValues +
extension DependencyValues {
    // Commons
    var commons: Commons {
        get { self[Commons.self] }
        set { self[Commons.self] = newValue }
    }
}
