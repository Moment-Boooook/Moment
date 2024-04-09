//
//  RecordDetailTests.swift
//  MomentTests
//
//  Created by phang on 4/8/24.
//
import SwiftUI
import MapKit
import XCTest

import ComposableArchitecture

@testable import Moment

// MARK: - 기록 디테일 화면 테스트
@MainActor
final class RecordDetailTests: XCTestCase {
    
    // 미니맵 위치 변경 / 초기화
    func testMinimapMoveAndInit() async {
        let store = TestStore(
            initialState: RecordDetailViewFeature.State(
                record: TestData.testRecord01,
                isRecordIsLast: true,
                book: TestData.testBook01,
                region: Formatter.getMapCameraPosition(
                    latitude: TestData.testRecord01.latitude,
                    longitude: TestData.testRecord01.longitude))
        ) {
            RecordDetailViewFeature()
        }
        
        let newPosition = Formatter.getMapCameraPosition(
            latitude: TestData.testRecord02.latitude,
            longitude: TestData.testRecord02.longitude)
        await store.send(.setRegion(newPosition)) {
            $0.region = newPosition
        }
        
        let originalValue = CLLocationCoordinate2D(
            latitude: TestData.testRecord01.latitude,
            longitude: TestData.testRecord01.longitude)
        await store.send(.initialRegion(originalValue)) {
            $0.region = MapCameraPosition.region(
                MKCoordinateRegion(center: originalValue,
                                   span: MKCoordinateSpan(
                                    latitudeDelta: 0.01,
                                    longitudeDelta: 0.01)
                                  )
            )
        }
    }
    
    // 해당 기록 삭제 - 기록이 해당 책의 마지막 기록일 때
    func testDeleteRecordAndBook() async {
        var bookList: [MomentBook] = [TestData.testBook01, TestData.testBook02]
        var recordList: [MomentRecord] = [TestData.testRecord01, TestData.testRecord02]
        
        let store = TestStore(
            initialState: RecordDetailViewFeature.State(
                record: TestData.testRecord01,
                isRecordIsLast: true,
                book: TestData.testBook01,
                region: Formatter.getMapCameraPosition(
                    latitude: TestData.testRecord01.latitude,
                    longitude: TestData.testRecord01.longitude))
        ) {
            RecordDetailViewFeature()
        } withDependencies: {
            $0.swiftDataService = .init(
                bookListFetch: { [] },
                recordListFetch: { [] },
                addBook: { _ in },
                addRecord: { _ in },
                deleteBook: { book in
                    if let index = bookList.firstIndex(of: book) {
                        bookList.remove(at: index)
                    }
                },
                deleteRecord: { record in
                    if let index = recordList.firstIndex(of: record) {
                        recordList.remove(at: index)
                    }
                }
            )
        }
        
        await store.send(.deleteRecordButtonTapped) {
            $0.alert = .deleteConfirm()
        }
        
        await store.send(.alert(.presented(.deleteRecordConfirm))) {
            $0.alert = nil
        }
        await store.receive(\.deleteBook)
        await store.receive(\.deleteRecord)
        await store.receive(\.initialNavigationStack)
        await store.receive(\.refetchBooksAndRecords)
    }
    
    // 해당 기록 삭제 - 해당 책에 다른 기록들이 남아있을 때
    func testDeleteRecord() async {
        var bookList: [MomentBook] = [TestData.testBook01, TestData.testBook02]
        var recordList: [MomentRecord] = [TestData.testRecord01, TestData.testRecord02]
        
        let store = TestStore(
            initialState: RecordDetailViewFeature.State(
                record: TestData.testRecord01,
                isRecordIsLast: false,
                book: TestData.testBook01,
                region: Formatter.getMapCameraPosition(
                    latitude: TestData.testRecord01.latitude,
                    longitude: TestData.testRecord01.longitude))
        ) {
            RecordDetailViewFeature()
        } withDependencies: {
            $0.swiftDataService = .init(
                bookListFetch: { [] },
                recordListFetch: { [] },
                addBook: { _ in },
                addRecord: { _ in },
                deleteBook: { book in
                    if let index = bookList.firstIndex(of: book) {
                        bookList.remove(at: index)
                    }
                },
                deleteRecord: { record in
                    if let index = recordList.firstIndex(of: record) {
                        recordList.remove(at: index)
                    }
                }
            )
        }
        
        await store.send(.deleteRecordButtonTapped) {
            $0.alert = .deleteConfirm()
        }
        
        await store.send(.alert(.presented(.deleteRecordConfirm))) {
            $0.alert = nil
        }
        await store.receive(\.deleteRecord)
        await store.receive(\.initialNavigationStack)
        await store.receive(\.refetchBooksAndRecords)
    }
}
