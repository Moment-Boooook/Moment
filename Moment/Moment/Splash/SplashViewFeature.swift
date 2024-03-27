//
//  SplashViewFeature.swift
//  Moment
//
//  Created by phang on 3/27/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - Splash View Reducer
@Reducer
struct SplashViewFeature {
    
    @ObservableState
    struct State: Equatable {
        var isAppStarting: Bool = true
        var appLogoDegreeChange: Bool = false
    }
    
    enum Action {
        case appStart
        case quitSplash
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // App 시작 시,
            case .appStart:
                withAnimation(.easeOut(duration: 2)) {
                    state.appLogoDegreeChange = true
                }
                return .run { send in
                    try await Task.sleep(nanoseconds: 1_750_000_000)
                    await send(.quitSplash)
                }
                // TODO: - 추후에, API 데이터 받아서 로컬 데이터(책 정보) 업데이트 해주는 작업 진행 
//                return .concatenate(
//                    .run { send in
//                    },
//                    .run { send in
//                        await send(.quitSplash)
//                    }
//                )
            //
            case .quitSplash:
                state.isAppStarting = false
                return .none
            }
        }
    }
}
