//
//  HomeViewFeature.swift
//  Moment
//
//  Created by phang on 3/27/24.
//

import SwiftUI
import MapKit

import ComposableArchitecture

// MARK: - Home View Reducer
@Reducer
struct HomeViewFeature {
    
    @ObservableState
    struct State: Equatable {
        var selectedOption: HomeSegment = .bookShelf            // 세그먼트 옵션
        var searchText: String = ""                             // 서치바 - 검색어
        var tappedSearchButton = false                          // 서치바 - 검색 버튼
        var focusedField: Bool = false                          // 서치바 - focus state
        var books: [MomentBook] = []                            // 유저의 전체 책 목록
        var records: [MomentRecord] = []                        // 유저의 전체 기록 목록
        var recordDictionary = [LocalName: [MomentRecord]]()    // 지역 별 기록 딕셔너리
        var searchedBooks: [MomentBook] = []                    // 검색 된 책 목록
        var searchedRecords: [MomentRecord] = []                // 검색 된 기록 목록
        var isSearching = false                                 // 검색 중
        let options = HomeSegment.allCases                      // 세그먼트 - 옵션 목록
        let localNames = LocalName.allCases                     // 지역 명 리스트
        
        mutating func fetchBooks() {
            @Dependency(\.swiftDataService) var swiftData
            do {
                self.books = try swiftData.bookListFetch()
            } catch {
                print("error :: fetchBooks", error.localizedDescription)
            }
        }
        
        mutating func fetchRecords() {
            @Dependency(\.swiftDataService) var swiftData
            do {
                self.records = try swiftData.recordListFetch()
            } catch {
                print("error :: fetchRecords", error.localizedDescription)
            }
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case changeSelectedOption(HomeSegment)
        case clearFocusState
        case endSearch
        case onAppear
        case fetchBooks
        case fetchRecords
        case fetchRecordDictionary
        case removeSearchText
        case searchButtonTapped
        case searchBooks(String)
        case searchRecords([MomentBook])
        case setSearchText(String)
        case startSearch
        case toggleSelectedOption(HomeSegment)
    }
        
    @Dependency(\.swiftDataService) var swiftData
    
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
            // selectedOption 값 변경
            case let .changeSelectedOption(newOption):
                state.selectedOption = newOption
                return .none
            // focusedField 해제
            case .clearFocusState:
                state.focusedField = false
                return .none
            // 검색어 입력 종료
            case .endSearch:
                state.isSearching = false
                return .none
            // onAppear
            case .onAppear:
                return .merge(
                    .run { send in
                        await send(.fetchBooks)
                    },
                    .run { send in
                        await send(.fetchRecords)
                    }
                )
            // 유저의 책 fetch
            case .fetchBooks:
                state.fetchBooks()
                return .none
            // 유저의 기록 fetch
            case .fetchRecords:
                state.fetchRecords()
                return .none
            // 지역 별 기록 리스트
            case .fetchRecordDictionary:
                let records = state.isSearching ? state.searchedRecords : state.records
                state.recordDictionary = Dictionary(grouping: records) { record in
                    if let localName = state.localNames.first(where: { $0.rawValue == record.localName }) {
                        return localName
                    } else {
                        return LocalName.defaultCase
                    }
                }
                .compactMapValues { records in
                    records.reduce(into: []) { result, record in
                        result.append(record)
                    }
                }
                return .none
            // 서치바 - 텍스트 삭제
            case .removeSearchText:
                state.searchText = ""
                return .none
            // 서치바 - 검색
            case .searchButtonTapped:
                return .concatenate(
                    .run { @MainActor [searchText = state.searchText] send in
                        send(.searchBooks(searchText))
                    },
                    .run { @MainActor [searchedBooks = state.searchedBooks] send in
                        send(.searchRecords(searchedBooks))
                    }
                )
            // 검색 된 책
            case let .searchBooks(searchText):
                state.searchedBooks = state.books.filter { $0.title.localizedStandardContains(searchText) }
                return .none
            // 검색 된 기록
            case let .searchRecords(searchedBooks):
                state.searchedRecords = searchedBooks
                    .reduce(into: [MomentRecord](), { records, book in
                        records += state.records.filter { $0.bookISBN == book.bookISBN }
                    })
                return .none
            // 서치바 - 검색 텍스트 입력
            case let .setSearchText(searchText):
                state.searchText = searchText
                return .none
            // 검색어 입력 중
            case .startSearch:
                state.isSearching = true
                return .none
            // 세그먼트 - 값 토글
            case let .toggleSelectedOption(newOption):
                return .send(.changeSelectedOption(newOption), animation: .interactiveSpring)
            }
        }
    }
}
