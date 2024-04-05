//
//  MainViewModel.swift
//  Moment
//
//  Created by Minjae Kim on 12/24/23.
//

import SwiftUI

class MainViewModel: ObservableObject {
	@Published var selectedOption = 0 // 세그먼트 인덱스 저장 프로퍼티
	@Published var recordSearchText = "" // 기억 검색 텍스트 저장 프로퍼티
	@Published var isTapSearchButton = false // 검색 버튼탭 여부 저장 프로퍼티
	
	@Published var mainBookList: [MomentBook] = [] // 저장되어있는 모든 책 리스트 저장 프로퍼티
	@Published var mainRecordList: [MomentRecord] = [] // 저장되어있는 모든 책 기록 리스트 저장 프로퍼티
	
	@Published var searchBookList: [MomentBook] = [] // 검색된 책 리스트 저장 프로퍼티
	@Published var searchRecordList: [MomentRecord] = [] // 검색된 책들의 기록 리스트 저장 프로퍼티
	
	@Published var isSearch: Bool = false // 검색중인 상태를 나타내는 프로퍼티
	@FocusState var isSearchFocused: Bool
	
	@Published var path = NavigationPath()
	
	@MainActor
	func recordSearch(bookSearch: ([MomentBook]) async -> [MomentBook], bookList: [MomentBook], recordList: [MomentRecord]) async -> [MomentRecord] {
		searchBookList = await bookSearch(bookList)
		let result = searchBookList.reduce(into: [MomentRecord]()) { recordList, book in
			recordList += recordList.filter { $0.bookISBN == book.bookISBN }
		}
		return result
	}
	
	@MainActor
	func bookSearch(bookList: [MomentBook]) async -> [MomentBook] {
		let result = bookList.filter { $0.title.localizedStandardContains(recordSearchText) }
		return result
	}
}
