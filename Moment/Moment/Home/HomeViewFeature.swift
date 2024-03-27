//
//  HomeViewFeature.swift
//  Moment
//
//  Created by phang on 3/27/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - Home View Reducer
@Reducer
struct HomeViewFeature {
    
    @ObservableState
    struct State: Equatable {
        var splash = SplashViewFeature.State()
        var onboarding = OnboardingViewFeature.State()
    }
    
    enum Action {
        case splash(SplashViewFeature.Action)
        case onboarding(OnboardingViewFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.splash, action: \.splash) {
            SplashViewFeature()
        }
        Scope(state: \.onboarding, action: \.onboarding) {
            OnboardingViewFeature()
        }
        Reduce { state, action in
            return .none
        }
    }
}
