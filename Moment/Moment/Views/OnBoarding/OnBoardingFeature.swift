//
//  OnBoardingFeature.swift
//  Moment
//
//  Created by Minjae Kim on 3/28/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct OnBoardingFeature {
	@ObservableState
	struct State: Equatable {
		let onboardings = [
			OnboardingData(title: "모멘트와 함께\n기억 속에 남겨두고 싶은\n책의 내용을 기록해보세요.", image: "onboarding01"),
			OnboardingData(title: "모멘트와 함께\n어디서 읽었는지\n기억하고 싶지 않으신가요?", image: "onboarding02"),
			OnboardingData(title: "모멘트와 함께\n기록하여 여러분만의\n책장을 완성시켜 보아요!", image: "onboarding03")
		]
		var isOnboardingCompleted: Bool = true
	}
	
	enum Action {
		case setupAppearance
		case completeOnboarding
		case fetchOnboardingCompleted
	}
	
	@Dependency(\.onboarding) var onboarding
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .setupAppearance:
				UIPageControl.appearance().currentPageIndicatorTintColor = .mainBrown
				UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
				
				return .send(.fetchOnboardingCompleted)
				
			case .completeOnboarding:
				onboarding.completeOnboarding()
				
				return .send(.fetchOnboardingCompleted)
				
			case .fetchOnboardingCompleted:
				state.isOnboardingCompleted = onboarding.isCompleteOnboarding()
				return .none
			}
		}
	}
}
