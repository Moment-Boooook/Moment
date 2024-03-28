//
//  AppContentViewFeature.swift
//  Moment
//
//  Created by phang on 3/27/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - App Content View Reducer
@Reducer
struct AppContentViewFeature {
    
    @ObservableState
    struct State: Equatable {
        var appStart = AppStartFeature.State()
        var home = HomeViewFeature.State()
    }
    
    enum Action {
        case appStart(AppStartFeature.Action)
        case home(HomeViewFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.appStart, action: \.appStart) {
            AppStartFeature()
        }
        Scope(state: \.home, action: \.home) {
            HomeViewFeature()
        }
        Reduce { state, action in
            return .none
        }
    }
}
