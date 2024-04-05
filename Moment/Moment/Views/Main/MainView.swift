//
//  MainView.swift
//  Moment
//
//  Created by phang on 12/13/23.
//

import SwiftUI
import SwiftData

struct MainView: View {
	@Query var bookList: [MomentBook]
	@Query var recordList: [MomentRecord]
	
	@State var selectedOption = 0 // 세그먼트 인덱스 저장 프로퍼티
	@State var recordSearchText = "" // 기억 검색 텍스트 저장 프로퍼티
	@State var isTapSearchButton = false // 검색 버튼탭 여부 저장 프로퍼티
	
	@State var mainBookList: [MomentBook] = [] // 저장되어있는 모든 책 리스트 저장 프로퍼티
	@State var mainRecordList: [MomentRecord] = [] // 저장되어있는 모든 책 기록 리스트 저장 프로퍼티
	
	@State var searchBookList: [MomentBook] = [] // 검색된 책 리스트 저장 프로퍼티
	@State var searchRecordList: [MomentRecord] = [] // 검색된 책들의 기록 리스트 저장 프로퍼티
	
	@FocusState var isSearchFocused: Bool
	@State var isSearch: Bool = false // 검색중인 상태를 나타내는 프로퍼티
	
	@StateObject var router = Router()

	var body: some View {
		GeometryReader { geo in
			NavigationStack(path: $router.path) {
				VStack(spacing: 0) {
					if selectedOption == 0 {
						VStack(spacing: 20) {
							SearchBar(searchText: $recordSearchText,
									  isTapButton: $isTapSearchButton,
									  isSearch: $isSearch,
									  isSearchFocused: _isSearchFocused)
							.padding(.horizontal, 20)
							SegmentBar(preselectedIndex: $selectedOption, geo: geo)
							
							MainShelfView(bookList: isSearch ? $searchBookList : $mainBookList,
										  recordSearchText: $recordSearchText,
										  isSearchFocused: _isSearchFocused,
										  geo: geo)
						}
					} else if selectedOption == 1 {
						ZStack(alignment: .top) {
							MainMapView(recordList: isSearch ? $searchRecordList : $mainRecordList)
							VStack(spacing: 20) {
								SearchBar(searchText: $recordSearchText,
										  isTapButton: $isTapSearchButton,
										  isSearch: $isSearch,
										  isSearchFocused: _isSearchFocused)
								.padding(.horizontal, 20)
								SegmentBar(preselectedIndex: $selectedOption, geo: geo)
							}
						}
					}
				}
				//MARK: [추후 업데이트] 문제3 수정
//                .onDisappear(perform: {
//                    recordSearchText = ""
//                })
				.onChange(of: isTapSearchButton) {
					Task {
						if isTapSearchButton && !recordSearchText.isEmpty {
							searchRecordList = await recordSearch(bookSearch: bookSearch)
						}
						isTapSearchButton = false
					}
				}
				.onChange(of: recordList) {
					Task {
						mainBookList = bookList
						mainRecordList = recordList
						
						// Query로 저장되어있는 기록리스트 변경 시 검색된 데이터가 있다면 데이터 업데이트
						if isSearch {
							searchRecordList = await recordSearch(bookSearch: bookSearch)
						}
					}
				}
				.navigationBarBackButtonHidden(true)
			}
			.environmentObject(router)
			.tint(.darkBrown)
//            .onAppear {
//                mainBookList = bookList
//                mainRecordList = recordList
//            }
			.task {
				mainBookList = bookList
				mainRecordList = recordList
			}
			.onTapGesture {
				hideKeyboard()
			}
		}
	}
	
	@MainActor
	func recordSearch(bookSearch: () async -> [MomentBook]) async -> [MomentRecord] {
		self.searchBookList = await bookSearch()
		let result = self.searchBookList.reduce(into: [MomentRecord]()) { recordList, book in
			recordList += self.recordList.filter { $0.bookISBN == book.bookISBN }
		}
		return result
	}
	
	@MainActor
	func bookSearch() async -> [MomentBook] {
		let result = bookList.filter { $0.title.localizedStandardContains(recordSearchText) }
		return result
	}
}

//#Preview {
//	MainView()
//}
