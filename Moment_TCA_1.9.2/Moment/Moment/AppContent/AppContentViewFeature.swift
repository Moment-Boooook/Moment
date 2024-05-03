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
        @ObservationStateIgnored
        @Shared var books: [MomentBook]
        @ObservationStateIgnored
        @Shared var records: [MomentRecord]
        
        var appStart: AppStartFeature.State
        var home: HomeViewFeature.State
        
        init(books: Shared<[MomentBook]> = Shared([]),
             records: Shared<[MomentRecord]> = Shared([])) {
            self._books = books
            self._records = records
            self.appStart = AppStartFeature.State(books: books,
                                                  records: records)
            self.home = HomeViewFeature.State(books: books,
                                              records: records)
        }
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
    }
}
