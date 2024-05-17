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
        let books: [MomentBook]                     // 책 목록
        var searchText: String = .empty             // 서치바 - 텍스트
        var searchedBooks: [Book] = []              // 검색 된 책 목록
        var focusedField: Bool = false              // 서치바 - focusstate
        var isSearching: Bool = false               // 검색 중 ...
        var completedSearch: Bool = false           // 책 검색이 완료 되었을때, true
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case clearFocusState
        case clearSearchedBooks
        case dismiss
        case endSearch
        case fetchSearchedBooks([Book])
        case removeSearchText
        case searchButtonTapped
        case setSearchText(String)
        case startSearch
        case toggledIsSearching
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.naverBookService) var naverBookAPI
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            //
            case .binding:
                return .none
            // focusedField 해제
            case .clearFocusState:
                state.focusedField = false
                return .none
            // 검색된 책 목록 초기화
            case .clearSearchedBooks:
                state.searchedBooks = []
                return .none
            // 뒤로가기
            case .dismiss:
                return .run { send in
                    await self.dismiss()
                }
            // 검색 종료
            case .endSearch:
                state.completedSearch = false
                return .run { send in
                    await send(.clearSearchedBooks)
                }
            // 검색 된 책 목록 할당
            case let .fetchSearchedBooks(books):
                state.searchedBooks = books
                return .none
            // 서치바 - 텍스트 지우기
            case .removeSearchText:
                state.searchText = .empty
                return .run { send in
                    await send(.endSearch)
                }
            // 검색 버튼 탭
            case .searchButtonTapped:
                return .concatenate(
                    .run { send in
                        await send(.toggledIsSearching)
                    },
                    .run { send in
                        await send(.startSearch)
                    },
                    .run { [searchText = state.searchText] send in
                        do {
                            try await send(.fetchSearchedBooks(self.naverBookAPI.fetch(searchText)))
                        } catch {
                            print("error :: AddBookView - searchButtonTapped()", error.localizedDescription)
                        }
                    },
                    .run { send in
                        await send(.toggledIsSearching)
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
            // 'isSearhing' 값 변경
            case .toggledIsSearching:
                state.isSearching.toggle()
                return .none
            }
        }
    }
}
