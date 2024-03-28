//
//  SplashFeature.swift
//  Moment
//
//  Created by Minjae Kim on 3/27/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SplashFeature {
	@ObservableState
	struct State: Equatable {
		var isActive = true
		var degreeChange = false
	}
	
	enum Action {
		case appStart
		case degreeChange
		case animationFinish
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .appStart:
				return .concatenate(
					.run { send in
						await send(.degreeChange, animation: .easeOut(duration: 2))
					},
					
					.run { _ in
						try await Task.sleep(nanoseconds: 1_750_000_000)
					},
					
					.run { send in
						await send(.animationFinish, animation: .default)
					}
				)
				
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
