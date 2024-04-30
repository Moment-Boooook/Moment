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
    // 책 목록 / 기록 목록 받아오기
    func testAppSplash() async {
        let clock = TestClock()
        
        var isOnboardingCompleted: Bool = false
        let commons = Commons(isCompleteOnboarding: { isOnboardingCompleted },
                              completeOnboarding: { isOnboardingCompleted = true })
        
        let store = TestStore(
            initialState: AppStartFeature.State(
                books: Shared([]),
                records: Shared([]))) {
                    AppStartFeature()
                } withDependencies: {
                    $0.commons = commons
                    $0.continuousClock = clock
                    $0.swiftDataService = .init(
                        bookListFetch: { [TestData.testBook01, TestData.testBook02] },
                        recordListFetch: { [TestData.testRecord01, TestData.testRecord02] },
                        addBook: { _ in },
                        addRecord: { _ in },
                        deleteBook: { _ in },
                        deleteRecord: { _ in }
                    )
                }
        
        await store.send(.appStart)
        await store.receive(\.degreeChange) {
            $0.appLogoDegreeChange = true
        }
        await store.receive(\.fetchAllData)
        await store.receive(\.fetchOnboardingCompleted)
        await store.receive(\.fetchBooks)
        await store.receive(\.fetchRecords)
        await clock.advance(by: .seconds(1.75))
        await store.receive(\.quitSplash) {
            $0.isAppStarting = false
        }
    }
    
    // 온보딩 완료 버튼 테스트
    func testOnboardingStartButton() async {
        var isOnboardingCompleted: Bool = false
        let commons = Commons(isCompleteOnboarding: { isOnboardingCompleted },
                              completeOnboarding: { isOnboardingCompleted = true })
        
        let store = TestStore(
            initialState: AppStartFeature.State(
                books: Shared([]),
                records: Shared([]))) {
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
