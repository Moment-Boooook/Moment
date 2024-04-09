//
//  TestData.swift
//  MomentTests
//
//  Created by phang on 4/8/24.
//

import Foundation

@testable import Moment

// MARK: - Test 에서 사용될 데이터
enum TestData {
    static let testBook01 = MomentBook(
        bookISBN: "1",
        theCoverOfBook: "dummyBookImage01",
        title: "햄버거",
        author: "이창준",
        publisher: "한빛미디어",
        plot: "줄거리다"
    )
    
    static let testBook02 = MomentBook(
        bookISBN: "2",
        theCoverOfBook: "bono",
        title: "피자",
        author: "김민재",
        publisher: "우렁찬",
        plot: "졸려..."
    )
    
    static let testRecord01 = MomentRecord(
        latitude: 37.5111158,
        longitude: 127.098167,
        localName: "서울특별시",
        myLocation: "어디지",
        year: 2024,
        monthAndDay: "7",
        time: String(format: "%02d%02d", Int.random(in: 0...23), Int.random(in: 0...59)),
        paragraph: "없어",
        page: "14",
        commentary: "생각안나...",
        photos: [Data()],
        bookISBN: "1"
    )
    
    static let testRecord02 = MomentRecord(
        latitude: 35.1531696,
        longitude: 129.118666,
        localName: "부산광역시",
        myLocation: "푸싼푸싼잇츠푸싼",
        year: 2024,
        monthAndDay: "12",
        time: String(format: "%02d%02d", Int.random(in: 0...23), Int.random(in: 0...59)),
        paragraph: "없어",
        page: "12",
        commentary: "안읽을래!!!!!!!!!!!!!!",
        photos: [Data()],
        bookISBN: "2"
    )
}
