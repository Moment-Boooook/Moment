//
//  SplashFeature.swift
//  Moment
//
//  Created by Minjae Kim on 3/27/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SplashFeature {
	@ObservableState
	struct State {
		var isActive = true
		var degreeChange = false
	}
	
	enum Action {
		case degreeChange
		case animationFinish
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .degreeChange:
				state.degreeChange = true
				return .none
				
			case .animationFinish:
				state.isActive = false
				return .none
			}
		}
	}
}
