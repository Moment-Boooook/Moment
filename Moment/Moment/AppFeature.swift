//
//  AppFeature.swift
//  Moment
//
//  Created by Minjae Kim on 3/28/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature {
	@ObservableState
	struct State: Equatable {
		var splash = SplashFeature.State()
		var root = RootFeature.State()
	}
	
	enum Action {
		case splash(SplashFeature.Action)
		case root(RootFeature.Action)
	}
	
	var body: some ReducerOf<Self> {
		Scope(state: \.splash, action: \.splash) {
			SplashFeature()
		}
		Scope(state: \.root, action: \.root) {
			RootFeature()
		}
		
		Reduce { state, action in
			return .none
		}
	}
}
