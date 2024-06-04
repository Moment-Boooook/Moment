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
        @Shared var userName: String
        @ObservationStateIgnored
        @Shared var books: [MomentBook]
        @ObservationStateIgnored
        @Shared var records: [MomentRecord]
        @ObservationStateIgnored
        @Shared var recordDictionary: [LocalName: [MomentRecord]]
        @ObservationStateIgnored
        @Shared var searchedBooks: [MomentBook]
        @ObservationStateIgnored
        @Shared var searchedRecords: [MomentRecord]
        
        var appStart: AppStartFeature.State
        var home: HomeViewFeature.State
        
        init(
            userName: Shared<String> = Shared(.empty),
            books: Shared<[MomentBook]> = Shared([]),
            records: Shared<[MomentRecord]> = Shared([]),
            recordDictionary: Shared<[LocalName: [MomentRecord]]> = Shared([:]),
            searchedBooks: Shared<[MomentBook]> = Shared([]),
            searchedRecords: Shared<[MomentRecord]> = Shared([])
        ) {
            self._userName = userName
            self._books = books
            self._records = records
            self._recordDictionary = recordDictionary
            self._searchedBooks = searchedBooks
            self._searchedRecords = searchedRecords
            self.appStart = AppStartFeature.State(userName: userName,
                                                  books: books,
                                                  records: records)
            self.home = HomeViewFeature.State(userName: userName,
                                              books: books,
                                              records: records, 
                                              recordDictionary: recordDictionary,
                                              searchedBooks: searchedBooks,
                                              searchedRecords: searchedRecords)
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
