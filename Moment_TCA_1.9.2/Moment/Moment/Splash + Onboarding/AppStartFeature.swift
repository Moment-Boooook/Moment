//
//  AppStartFeature.swift
//  Moment
//
//  Created by phang on 3/28/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - Splash + Onboarding View Reducer
@Reducer
struct AppStartFeature {
    
    @ObservableState
    struct State: Equatable {
        // splash
        var isAppStarting: Bool = true
        var appLogoDegreeChange: Bool = false
        // splash / onboarding
        var isOnboardingCompleted: Bool = false
    }
    
    enum Action {
        // splash
        case appStart
        case degreeChange
        case fetchOnboardingCompleted
        case quitSplash
        // onboarding
        case completeOnboarding
        case refetchCompleteOnboarding
        case setPageIndicator(Color)
        case startButtonTapped
    }
    
    // Cancellable 에서 사용할 enum
    enum CancelID { case timer }
    
    @Dependency(\.commons) var commons
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // MARK: - Splah
            // App 시작 시,
            case .appStart:
                return .merge(
                    .run { send in
                        await send(.degreeChange)
                    },
                    .run { send in
                        // TODO: - 추후에 API 데이터 받아서 로컬 데이터(책 정보) 업데이트 해주는 작업 진행
                        await send(.fetchOnboardingCompleted)
                    }
                )
            // 애니메이션 각도 변경
            case .degreeChange:
                withAnimation(.easeOut(duration: 1.75)) {
                    state.appLogoDegreeChange = true
                }
                return .none
            // 온보딩 완료 여부 fetch - appstorage
            case .fetchOnboardingCompleted:
                state.isOnboardingCompleted = commons.isCompleteOnboarding()
                return .run { send in
                    for await _ in self.clock.timer(interval: .seconds(1.75)) {
                        await send(.quitSplash)
                    }
                }
                .cancellable(id: CancelID.timer)
            // 스플래쉬 뷰 닫기
            case .quitSplash:
                state.isAppStarting = false
                return .cancel(id: CancelID.timer)
            // MARK: - Onboarding
            // onboarding 완료
            case .completeOnboarding:
                commons.completeOnboarding()
                return .none
            // 온보딩 완료 여부 refetch - appstorage
            case .refetchCompleteOnboarding:
                state.isOnboardingCompleted = commons.isCompleteOnboarding()
                return .none
            // onboarding 페이지 스타일 탭뷰 인디케이터 색상 변경
            case let .setPageIndicator(color):
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(color)
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
                return .none
            // 시작하기 버튼 탭
            case .startButtonTapped:
                return .concatenate(
                    .run { send in
                        await send(.completeOnboarding)
                    },
                    .run { send in
                        await send(.refetchCompleteOnboarding)
                    }
                )
            }
        }
    }
}
