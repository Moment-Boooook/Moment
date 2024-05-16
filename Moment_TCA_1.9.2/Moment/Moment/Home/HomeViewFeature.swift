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
        @ObservationStateIgnored
        @Shared var books: [MomentBook]                         // 유저의 전체 책 목록
        @ObservationStateIgnored
        @Shared var records: [MomentRecord]                     // 유저의 전체 기록 목록
        
        var path = StackState<Path.State>()                     // 네비게이션 스택 Path
        var selectedOption: HomeSegment = .bookShelf            // 세그먼트 옵션
        var searchText: String = ""                             // 서치바 - 검색어
        var focusedField: Bool = false                          // 서치바 - focus state
        var recordDictionary = [LocalName: [MomentRecord]]()    // 지역 별 기록 딕셔너리
        var searchedBooks: [MomentBook] = []                    // 검색 된 책 목록
        var searchedRecords: [MomentRecord] = []                // 검색 된 기록 목록
        var isSearching = false                                 // 검색 중
        let options = HomeSegment.allCases                      // 세그먼트 - 옵션 목록
        let localNames = LocalName.allCases                     // 지역 명 리스트
        
        mutating func fetchBooks() {
            @Dependency(\.swiftDataService) var swiftData
            do {
                self.books = try swiftData.fetchBookList()
            } catch {
                print("error :: fetchBooks", error.localizedDescription)
            }
        }
        
        mutating func fetchRecords() {
            @Dependency(\.swiftDataService) var swiftData
            do {
                self.records = try swiftData.fetchRecordList()
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
        case fetchBooks
        case fetchRecords
        case fetchRecordDictionary
        case removeSearchText
        case path(StackAction<Path.State, Path.Action>)
        case searchButtonTapped
        case searchBooksAndRecords(String)
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
            //
            case .binding:
                return .none
            // selectedOption 값 변경
            case let .changeSelectedOption(newOption):
                withAnimation {
                    state.selectedOption = newOption
                }
                return .none
            // focusedField 해제
            case .clearFocusState:
                state.focusedField = false
                return .none
            // 검색어 입력 종료
            case .endSearch:
                state.isSearching = false
                return .none
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
            // Navigation Path
            case let .path(action):
                switch action {
                case .element(id: _, action: .addRecord(.initialNavigationStack)):
                    state.path.removeAll()
                    return .none
                case .element(id: _, action: .addRecord(.refetchBooksAndRecords)):
                    return .run { @MainActor send in
                        send(.fetchBooks)
                        send(.fetchRecords)
                    }
                case .element(id: _, action: .recordDetail(.initialNavigationStack)):
                    state.path.removeAll()
                    return .none
                case .element(id: _, action: .recordDetail(.refetchBooksAndRecords)):
                    return .run { @MainActor send in
                        send(.fetchBooks)
                        send(.fetchRecords)
                    }
                default:
                    return .none
                }
            // 서치바 - 검색
            case .searchButtonTapped:
                return .run { [searchText = state.searchText] send in
                    await send(.startSearch)
                    await send(.searchBooksAndRecords(searchText))
                }
            // 검색 된 책 + 기록
            case let .searchBooksAndRecords(searchText):
                state.searchedBooks = state.books.filter { $0.title.localizedStandardContains(searchText) }
                return .run { [searchedBooks = state.searchedBooks] send in
                    await send(.searchRecords(searchedBooks))
                }
            // 검색 된 기록
            case let .searchRecords(searchedBooks):
                state.searchedRecords = searchedBooks
                    .reduce(into: [MomentRecord](), { records, book in
                        records += state.records.filter { $0.bookISBN == book.bookISBN }
                    })
                return .run { send in
                    await send(.fetchRecordDictionary)
                }
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
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}

// MARK: - Path
extension HomeViewFeature {
    @Reducer
    struct Path {
        
        @ObservableState
        enum State: Equatable {
            case addBook(AddBookViewFeature.State)
            case addRecord(AddRecordViewFeature.State)
            case recordList(RecordListViewFeature.State)
            case recordDetail(RecordDetailViewFeature.State)
            case imageFull(ImageFullViewFeature.State)
        }
        
        enum Action {
            case addBook(AddBookViewFeature.Action)
            case addRecord(AddRecordViewFeature.Action)
            case recordList(RecordListViewFeature.Action)
            case recordDetail(RecordDetailViewFeature.Action)
            case imageFull(ImageFullViewFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            // Add Book
            Scope(state: \.addBook, action: \.addBook) {
                AddBookViewFeature()
            }
            // Add Record
            Scope(state: \.addRecord, action: \.addRecord) {
                AddRecordViewFeature()
            }
            // Record List
            Scope(state: \.recordList, action: \.recordList) {
                RecordListViewFeature()
            }
            // Record Detail
            Scope(state: \.recordDetail, action: \.recordDetail) {
                RecordDetailViewFeature()
            }
            // Image Full
            Scope(state: \.imageFull, action: \.imageFull) {
                ImageFullViewFeature()
            }
        }
    }
}
