//
//  ImageFullViewFeature.swift
//  Moment
//
//  Created by phang on 4/4/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - Image Full View Reducer
@Reducer
struct ImageFullViewFeature {
    
    @ObservableState
    struct State: Equatable {
        let image: UIImage
        var scale = 1.0
        var lastScale = 1.0
        let minScale = 1.0
        let maxScale = 5.0
    }
    
    enum Action {
        case adjustScale(MagnificationGesture.Value)
        case dismiss
        case initialLastScale(Double)
        case validateScaleLimits
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            //
            case let .adjustScale(newValue):
                let delta = newValue / state.lastScale
                state.scale *= delta
                state.lastScale = newValue
                return .none
            // 뒤로가기
            case .dismiss:
                return .run { send in
                    await self.dismiss()
                }
            //
            case let .initialLastScale(newValue):
                state.lastScale = newValue
                return .none
            //
            case .validateScaleLimits:
                withAnimation {
                    state.scale = max(state.scale, state.minScale)
                    state.scale = min(state.scale, state.maxScale)
                }
                return .run { send in
                    await send(.initialLastScale(1.0))
                }
            }
        }
    }
}
