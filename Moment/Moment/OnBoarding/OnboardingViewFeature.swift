//
//  OnboardingViewFeature.swift
//  Moment
//
//  Created by phang on 3/27/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - Onboarding View Reducer
@Reducer
struct OnboardingViewFeature {

    @ObservableState
    struct State: Equatable {
        //
    }
    
    enum Action {
        case setPageIndicator(Color)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // onboarding 페이지 스타일 탭뷰 인디케이터 색상 변경
            case let .setPageIndicator(color):
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(color)
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
                return .none
            }
        }
    }
}
