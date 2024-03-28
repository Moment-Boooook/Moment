//
//  OnboardingClient.swift
//  Moment
//
//  Created by Minjae Kim on 3/28/24.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingClient {
	@AppStorage("isOnboarding") 
	static var isOnboardingCompleted = true
	
	var isCompleteOnboarding: () -> Bool
	var completeOnboarding: () -> Void
}

extension OnboardingClient: DependencyKey {
	public static let liveValue = Self(
		isCompleteOnboarding: {
			return isOnboardingCompleted
		},
		completeOnboarding: {
			isOnboardingCompleted = false
		}
	)
}

extension DependencyValues {
	var onboarding: OnboardingClient {
		get { self[OnboardingClient.self] }
		set { self[OnboardingClient.self] = newValue }
	}
}
