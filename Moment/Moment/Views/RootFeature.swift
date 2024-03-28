//
//  MainFeature.swift
//  Moment
//
//  Created by Minjae Kim on 3/28/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RootFeature {
	struct State: Equatable {
		var onboarding = OnBoardingFeature.State()
	}
	
	enum Action {
		case onboarding(OnBoardingFeature.Action)
	}
	
	var body: some ReducerOf<Self> {
		Scope(state: \.onboarding, action: \.onboarding) {
			OnBoardingFeature()
		}
		
		Reduce { state, action in
			return .none
		}
	}
}
