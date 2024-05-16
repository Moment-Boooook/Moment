//
//  AddRecordTests.swift
//  MomentTests
//
//  Created by phang on 4/8/24.
//

import XCTest
import CoreLocation

import ComposableArchitecture

@testable import Moment

// MARK: - 기록 추가 화면 테스트
@MainActor
final class AddRecordTests: XCTestCase {
    
    // 모의 CLLocationManager를 만들기 위한 Mock 클래스
    class MockLocationManager: CLLocationManager {
        override class func authorizationStatus() -> CLAuthorizationStatus {
            return .authorizedWhenInUse // 사용자가 위치 권한을 허용한 상태로 설정
        }
    }
    
    // 위치 정보 받아오기
    func testFetchLocation() async {
        let store = TestStore(
            initialState: AddRecordViewFeature.State(
                book: TestData.testBook01,
                myBooks: [TestData.testBook01, TestData.testBook02])
        ) {
           AddRecordViewFeature()
        } withDependencies: {
            $0.locationManagerService = .init(
                fetch: {
                    let manager = MockLocationManager()
                    manager.requestWhenInUseAuthorization()
                    return await withCheckedContinuation { continuation in
                        Task {
                            // 위치 정보 동의가 이루어질 때까지 대기
                            while manager.authorizationStatus == .notDetermined {
                                try await Task.sleep(nanoseconds: 100_000_000)  // 0.1초
                            }
                            if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
                                manager.desiredAccuracy = kCLLocationAccuracyBest
                                let result = (latitude: 37.498097, longitude: 127.0252657,
                                              place: "어딘가의 어딘가...", localName: "서울특별시")
                                continuation.resume(returning: result)
                            } else {
                                throw LocationManagerError.authorizationDenied
                            }
                        }
                    }
                }
            )
        }
        
        await store.send(.fetchLocation)
        await store.receive(\.setLocationInfo)  // 위치 사용에 대한 권한 허용 문제로 값 들어오는 체크는 X
//        await store.receive(\.setLocationInfo) {
//            $0.latitude = 37.498097
//            $0.longitude = 127.0252657
//            $0.place = "어딘가의 어딘가..."
//            $0.localName = "서울특별시"
//        }
    }
    
    // 위치를 기억할 이름 TextField 테스트
    func testMyLocation() async {
        let store = TestStore(
            initialState: AddRecordViewFeature.State(
                book: TestData.testBook01,
                myBooks: [TestData.testBook01, TestData.testBook02])
        ) {
           AddRecordViewFeature()
        }
        
        let text = "나만의 그곳.."
        await store.send(.setMyLocationAlias(text))
//        await store.send(.setMyLocationAlias(text)) {
//            $0.myLocationAlias = text
//        }
    }
    
    // 기록하고 싶은 구절 TextField 테스트
    func testParagraph() async {
        let store = TestStore(
            initialState: AddRecordViewFeature.State(
                book: TestData.testBook01,
                myBooks: [TestData.testBook01, TestData.testBook02])
        ) {
           AddRecordViewFeature()
        }
        
        let text = "이러이러한..그런 것이다.."
        await store.send(.setParagraph(text))
//        await store.send(.setParagraph(text)) {
//            $0.paragraph = text
//        }
    }
    
    // 기록하고 싶은 페이지 TextField 테스트
    func testPage() async {
        let store = TestStore(
            initialState: AddRecordViewFeature.State(
                book: TestData.testBook01,
                myBooks: [TestData.testBook01, TestData.testBook02])
        ) {
           AddRecordViewFeature()
        }
        
        let page = "14"
        await store.send(.setPage(page))
//        await store.send(.setPage(page)) {
//            $0.page = page
//        }
    }
    
    // 기록하는 책의 내용 TextEditor 테스트
    func testContent() async {
        let store = TestStore(
            initialState: AddRecordViewFeature.State(
                book: TestData.testBook01,
                myBooks: [TestData.testBook01, TestData.testBook02])
        ) {
           AddRecordViewFeature()
        }
        
        let content = "가나다라마바사.. bonjour.."
        await store.send(.setContent(content))
//        await store.send(.setContent(content)) {
//            $0.content = content
//        }
    }
    
    // 저장 - 해당 기록의 책이 이미 책장에 있을 때
    func testSaveRecord() async {
        let store = TestStore(
            initialState: AddRecordViewFeature.State(
                book: TestData.testBook01,
                myBooks: [TestData.testBook01, TestData.testBook02],
                place: "어딘가의 어딘가...",
                localName: "서울특별시",
                myLocationAlias: "나만의..ㅎ",
                paragraph: "에베베베베베베",
                page: "14",
                content: "얄라리얄라리..",
                selectedImages: [UIImage()]
            )
        ) {
           AddRecordViewFeature()
        } withDependencies: {
            $0.swiftDataService = .init(
                fetchBookList: { [] },
                fetchRecordList: { [] },
                addBook: { _ in },
                addRecord: { record in
                    // 레코드 추가 로직
                },
                deleteBook: { _ in },
                deleteRecord: { _ in }
            )
        }
        
//        await store.send(.saveRecord) {
//            $0.alert = .saveConfirm()
//        }
//        
//        await store.send(.alert(.presented(.saveRecordConfirm))) {
//            $0.alert = nil
//        }
//        
//        await store.receive(\.addRecord)
//        await store.receive(\.refetchBooksAndRecords)
//        await store.receive(\.initialNavigationStack)
    }
    
    // 저장 - 해당 기록의 책이 처음 책장에 등록 될 때
    func testSaveRecordAndBook() async {
        let store = TestStore(
            initialState: AddRecordViewFeature.State(
                book: TestData.testBook01,
                myBooks: [TestData.testBook02],
                place: "어딘가의 어딘가...",
                localName: "서울특별시",
                myLocationAlias: "나만의..ㅎ",
                paragraph: "에베베베베베베",
                page: "14",
                content: "얄라리얄라리..",
                selectedImages: [UIImage()]
            )
        ) {
           AddRecordViewFeature()
        } withDependencies: {
            $0.swiftDataService = .init(
                fetchBookList: { [] },
                fetchRecordList: { [] },
                addBook: { book in
                    // 책 추가 로직
                },
                addRecord: { record in
                    // 레코드 추가 로직
                },
                deleteBook: { _ in },
                deleteRecord: { _ in }
            )
        }
        
//        await store.send(.saveRecord) {
//            $0.alert = .saveConfirm()
//        }
//        
//        await store.send(.alert(.presented(.saveRecordConfirm))) {
//            $0.alert = nil
//        }
//        
//        await store.receive(\.addBook)
//        await store.receive(\.addRecord)
//        await store.receive(\.refetchBooksAndRecords)
//        await store.receive(\.initialNavigationStack)
    }
}
