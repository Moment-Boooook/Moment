//
//  AddBookViewFeature.swift
//  Moment
//
//  Created by phang on 3/29/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - Add Book View Feature
@Reducer
struct AddBookViewFeature {
    
    @ObservableState
    struct State: Equatable {
        var books: [MomentBook] = []                // 책 목록
        var searchText: String = ""                 // 서치바 - 텍스트
        var searchedBooks: [Book] = []              // 검색 된 책 목록
        var focusedField: Bool = false              // 서치바 - focusstate
        var completedSearch: Bool = false           // 책 검색이 완료 되었을때, true
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case dismiss
        case endSearch
        case fetchSearchedBooks([Book])
        case removeSearchText
        case searchButtonTapped
        case setSearchText(String)
        case startSearch
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.naverBookService) var naverBookAPI
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            // focusedField 연결
            case .binding(\.focusedField):
                return .none
            //
            case .binding:
                return .none
            // 뒤로가기
            case .dismiss:
                return .run { send in
                    await self.dismiss()
                }
            // 검색 종료
            case .endSearch:
                state.completedSearch = false
                return .none
            // 검색 된 책 목록 할당
            case let .fetchSearchedBooks(books):
                state.searchedBooks = books
                return .none
            // 서치바 - 텍스트 지우기
            case .removeSearchText:
                state.searchText = ""
                return .run { send in
                    await send(.endSearch)
                }
            // 검색 버튼 탭
            case .searchButtonTapped:
                return .concatenate(
                    .run { send in
                        await send(.startSearch)
                    },
                    .run { [searchText = state.searchText] send in
                        do {
                            try await send(.fetchSearchedBooks(self.naverBookAPI.fetch(searchText)))
                        } catch {
                            print("error :: AddBookView - searchButtonTapped()", error.localizedDescription)
                        }
                    }
                )
            // 서치바 - 텍스트 입력
            case let .setSearchText(searchText):
                state.searchText = searchText
                return .none
            // 검색 시작
            case .startSearch:
                state.completedSearch = true
                return .none
            }
        }
    }
}
