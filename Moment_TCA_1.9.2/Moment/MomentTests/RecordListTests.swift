//
//  RecordListTests.swift
//  MomentTests
//
//  Created by phang on 4/8/24.
//

import XCTest

import ComposableArchitecture

@testable import Moment

// MARK: - 기록 리스트 화면 테스트
@MainActor
final class RecordListTests: XCTestCase {
    
    // 책장 -> 리스트 의 경우
    // + 다이얼로그 열기 / 닫기
    func testShelfToList() async {
        let store = TestStore(
            initialState: RecordListViewFeature.State(
                usedTo: .usedToShelf,
                books: [TestData.testBook01, TestData.testBook02],
                records: [TestData.testRecord01, TestData.testRecord02],
                selectedBook: TestData.testBook01,
                localName: "",
                recordsOfLocal: [])
        ) {
            RecordListViewFeature()
        }
        
        await store.send(.toggledBookDataDialog) {
            $0.showBookDataDialog = true
        }
        await store.receive(\.showBookDataDialog) {
            $0.dialogOffset = 0
        }
        
        await store.send(.toggledBookDataDialog) {
            $0.showBookDataDialog = false
        }
        await store.receive(\.hideBookDataDialog) {
            $0.dialogOffset = 1000
        }
    }
    
    // 지도 -> 리스트 의 경우
    func testMapToList() async {
        let store = TestStore(
            initialState: RecordListViewFeature.State(
                usedTo: .usedToShelf,
                books: [TestData.testBook01, TestData.testBook02],
                records: [TestData.testRecord01, TestData.testRecord02],
                selectedBook: MomentBook(bookISBN: "",
                                         theCoverOfBook: "",
                                         title: "",
                                         author: "",
                                         publisher: "",
                                         plot: ""),
                localName: "서울특별시",
                recordsOfLocal: [TestData.testRecord01])
        ) {
            RecordListViewFeature()
        }
    }
}
