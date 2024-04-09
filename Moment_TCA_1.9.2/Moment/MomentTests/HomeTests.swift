//
//  HomeTests.swift
//  MomentTests
//
//  Created by phang on 4/8/24.
//

import XCTest

import ComposableArchitecture

@testable import Moment

// MARK: - 메인 홈 ( 책장 / 지도 ) 화면 테스트
@MainActor
final class HomeTests: XCTestCase {
    
    // 책 목록 / 기록 목록 받아오기
    func testFetchBooksAndRecords() async {
        let store = TestStore(initialState: HomeViewFeature.State()) {
            HomeViewFeature()
        } withDependencies: {
            $0.swiftDataService = .init(
                bookListFetch: { [TestData.testBook01, TestData.testBook02] },
                recordListFetch: { [TestData.testRecord01, TestData.testRecord02] },
                addBook: { _ in },
                addRecord: { _ in },
                deleteBook: { _ in },
                deleteRecord: { _ in }
            )
        }
        
        await store.send(.fetchBooks) {
            $0.fetchBooks()
            $0.books = [TestData.testBook01, TestData.testBook02]
        }
        await store.send(.fetchRecords) {
            $0.fetchRecords()
            $0.records = [TestData.testRecord01, TestData.testRecord02]
        }
    }
    
    // 세그먼트 전환 테스트
    // + 지도 화면 onAppear 시, 지역에 따른 기록 (딕셔너리) 생성
    func testHomeSegmentButton() async {
        let store = TestStore(
            initialState: HomeViewFeature.State(
                records: [TestData.testRecord01, TestData.testRecord02])) {
            HomeViewFeature()
        }
        
        let newValue = HomeSegment.map
        await store.send(.toggleSelectedOption(newValue))
        await store.receive(\.changeSelectedOption) {
            $0.selectedOption = newValue
        }
        
        // Fetch Record Dictionary
        await store.send(.fetchRecordDictionary) {
            $0.recordDictionary = [.seoul: [TestData.testRecord01],
                                   .busan: [TestData.testRecord02]]
        }
    }
    
    // 검색 테스트 - 검색어 쓰고 지우기
    func testSearchMyBook() async {
        let store = TestStore(initialState: HomeViewFeature.State()) {
            HomeViewFeature()
        }
        
        let text = "검색중"
        await store.send(.setSearchText(text)) {
            $0.searchText = text
        }
        
        await store.send(.removeSearchText) {
            $0.searchText = ""
        }
    }

    // 검색 테스트 - 결과 O
    func testSearchMyBookSuccess() async {
        let store = TestStore(
            initialState: HomeViewFeature.State(
                searchText: TestData.testBook01.title,
                books: [TestData.testBook01, TestData.testBook02],
                records: [TestData.testRecord01, TestData.testRecord02],
                recordDictionary: [.seoul: [TestData.testRecord01],
                                   .busan: [TestData.testRecord02]]
            )) {
            HomeViewFeature()
        }
        
        await store.send(.searchButtonTapped)
        await store.receive(\.startSearch) {
            $0.isSearching = true
        }
        await store.receive(\.searchBooksAndRecords) {
            $0.searchedBooks = [TestData.testBook01]
        }
        await store.receive(\.searchRecords) {
            $0.searchedRecords = [TestData.testRecord01]
        }
        await store.receive(\.fetchRecordDictionary) {
            $0.recordDictionary = [.seoul: [TestData.testRecord01]]
        }
    }
    
    // 검색 테스트 - 결과 X
    func testSearchMyBookFail() async {
        let store = TestStore(
            initialState: HomeViewFeature.State(
                searchText: "???",
                books: [TestData.testBook01, TestData.testBook02],
                records: [TestData.testRecord01, TestData.testRecord02],
                recordDictionary: [.seoul: [TestData.testRecord01],
                                   .busan: [TestData.testRecord02]]
            )) {
            HomeViewFeature()
        }
        
        await store.send(.searchButtonTapped)
        await store.receive(\.startSearch) {
            $0.isSearching = true
        }
        await store.receive(\.searchBooksAndRecords)    // 초기값 [] -> 상태 변화 X
        await store.receive(\.searchRecords)            // 초기값 [] -> 상태 변화 X
        await store.receive(\.fetchRecordDictionary) {
            $0.recordDictionary = [LocalName: [MomentRecord]]()
        }
    }
}
