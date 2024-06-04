//
//  RecordListViewFeature.swift
//  Moment
//
//  Created by phang on 4/3/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - Record List View Reducer
@Reducer
struct RecordListViewFeature {
    
    @ObservableState
    struct State: Equatable {
        @ObservationStateIgnored
        @Shared var books: [MomentBook]             // 유저의 책장 책 목록
        @ObservationStateIgnored
        @Shared var records: [MomentRecord]         // 유저의 기록 목록
        @ObservationStateIgnored
        @Shared var recordDictionary: [LocalName: [MomentRecord]]   // 지역 별 기록 딕셔너리
        
        let usedTo: RecordListType                  // 시용되는 뷰
        
        // 기록 연도에 따른 리스트 : in BookShelf
        let selectedBook: MomentBook                // 선택된 책
        var recordsOfBook: [MomentRecord] {         // 책에 대한 기록 목록
            records.filter { $0.bookISBN == selectedBook.bookISBN }
        }
        var recordsYear: [Int] {                    // 책에 대한 기록들의 년도 목록
            Set(recordsOfBook.map { $0.year }).sorted { $0 > $1 }
        }
        var showBookDataDialog: Bool = false        // 책에 대한 대략적인 내용을 보여주는 다이얼로그
        var dialogOffset: CGFloat = 1000            // 다이얼로그 띄울때, offset
        // 책에 따른 리스트 : in Map
        let localName: LocalName                    // 선택된 지역 이름
        var recordsOfLocal: [MomentRecord] {        // 지역에 대한 기록 목록
            recordDictionary[localName] ?? []
        }
        var recordsBookData: [MomentBook] {         // 지역에 대한 책의 데이터
            return Set(recordsOfLocal.map { $0.bookISBN }).compactMap { isbn in
                if let book = books.first(where: { $0.bookISBN == isbn }) {
                    return book
                }
                return nil
            }
        }
    }
    
    enum Action {
        case dismiss
        case hideBookDataDialog
        case showBookDataDialog
        case toggledBookDataDialog
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // 뒤로가기
            case .dismiss:
                return .run { send in
                    await self.dismiss()
                }
            // 'BookDataDialog' 닫기
            case .hideBookDataDialog:
                state.dialogOffset = 1000
                return .none
            // 'BookDataDialog' 열기
            case .showBookDataDialog:
                withAnimation(.spring()) {
                    state.dialogOffset = 0
                }
                return .none
            // 'showBookDataDialog' 값 변경
            case .toggledBookDataDialog:
                state.showBookDataDialog.toggle()
                return .run { [showBookDataDialog = state.showBookDataDialog] send in
                    if showBookDataDialog {
                        await send(.showBookDataDialog)
                    } else {
                        await send(.hideBookDataDialog)
                    }
                }
            }
        }
    }
}
