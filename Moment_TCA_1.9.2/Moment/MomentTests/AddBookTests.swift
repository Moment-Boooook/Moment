//
//  AddBookTests.swift
//  MomentTests
//
//  Created by phang on 4/8/24.
//

import XCTest

import ComposableArchitecture

@testable import Moment

// MARK: - 책 서치 / 추가 화면 테스트
@MainActor
final class AddBookTests: XCTestCase {
    
    // 책 검색 - 검색어 작성 / 지우기
    func testSearchBook() async {
        let store = TestStore(
            initialState: AddBookViewFeature.State(
                books: [TestData.testBook01, TestData.testBook02])
        ) {
            AddBookViewFeature()
        }
        
        let text = "search"
        await store.send(.setSearchText(text)) {
            $0.searchText = text
        }
        
        await store.send(.removeSearchText) {
            $0.searchText = ""
        }
        await store.receive(\.endSearch)            // completedSearch 기본값 false -> 변화 X
        await store.receive(\.clearSearchedBooks)   // searchedBooks 기본값 [] -> 변화 X
    }
    
    
    // 책 검색 - 검색 O
    func testSearchBookSuccess() async {
        let store = TestStore(
            initialState: AddBookViewFeature.State(
                books: [TestData.testBook01, TestData.testBook02],
                searchText: "책 제목"
            )
        ) {
            AddBookViewFeature()
        } withDependencies: {
            $0.naverBookService = .init(
                fetch: { _ in
                    [Book(title: "책 제목",
                          theCoverOfBook: "표지",
                          author: "작가",
                          publisher: "출판사",
                          plot: "에베베베",
                          bookISBN: "1")]
                }
            )
        }
        
        await store.send(.searchButtonTapped)
        await store.receive(\.toggledIsSearching) {
            $0.isSearching = true
        }
        await store.receive(\.startSearch) {
            $0.completedSearch = true
        }
        await store.receive(\.fetchSearchedBooks) {
            $0.searchedBooks = [Book(title: "책 제목",
                                     theCoverOfBook: "표지",
                                     author: "작가",
                                     publisher: "출판사",
                                     plot: "에베베베",
                                     bookISBN: "1")]
        }
        await store.receive(\.toggledIsSearching) {
            $0.isSearching = false
        }
    }

    // 책 검색 - 검색 X
    func testSearchBookFail() async {
        let store = TestStore(
            initialState: AddBookViewFeature.State(
                books: [TestData.testBook01, TestData.testBook02],
                searchText: "???"
            )
        ) {
            AddBookViewFeature()
        } withDependencies: {
            $0.naverBookService = .init(
                fetch: { _ in [] }
            )
        }
        
        await store.send(.searchButtonTapped)
        await store.receive(\.toggledIsSearching) {
            $0.isSearching = true
        }
        await store.receive(\.startSearch) {
            $0.completedSearch = true
        }
        await store.receive(\.fetchSearchedBooks)       // searchedBooks 기본값 [] -> 변화 X
        await store.receive(\.toggledIsSearching) {
            $0.isSearching = false
        }
    }
}
