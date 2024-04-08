//
//  AppStartTests.swift
//  MomentTests
//
//  Created by phang on 4/8/24.
//

import XCTest

import ComposableArchitecture

@testable import Moment

// MARK: - Splash / Onboarding 화면 테스트
@MainActor
final class AppStartTests: XCTestCase {
    
    // splash 화면 테스트
    func appLogoTest() async {
        var isOnboardingCompleted: Bool = false
        let commons = Commons(isCompleteOnboarding: { isOnboardingCompleted },
                              completeOnboarding: { isOnboardingCompleted = true })
        
        let store = TestStore(initialState: AppStartFeature.State()) {
            AppStartFeature()
        } withDependencies: {
            $0.commons = commons
        }
        
        await store.send(.appStart)
        await store.receive(\.degreeChange) {
            $0.appLogoDegreeChange = true
        }
        await store.receive(\.fetchOnboardingCompleted) {
            $0.isOnboardingCompleted = false
        }
        await store.receive(\.quitSplash) {
            $0.isAppStarting = false
        }
    }
    
    // 온보딩 완료 버튼 테스트
    func testOnboardingStartButton() async {
        var isOnboardingCompleted: Bool = false
        let commons = Commons(isCompleteOnboarding: { isOnboardingCompleted },
                              completeOnboarding: { isOnboardingCompleted = true })
        
        let store = TestStore(initialState: AppStartFeature.State()) {
            AppStartFeature()
        } withDependencies: {
            $0.commons = commons
        }
        
        await store.send(.startButtonTapped)
        await store.receive(\.completeOnboarding)
        await store.receive(\.refetchCompleteOnboarding) {
            $0.isOnboardingCompleted = true
        }
    }
    
}
