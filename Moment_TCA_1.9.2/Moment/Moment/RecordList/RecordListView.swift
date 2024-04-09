//
//  RecordListView.swift
//  Moment
//
//  Created by phang on 4/3/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - 기록들을 볼 수 있는 화면
struct RecordListView: View {
    @Bindable var store: StoreOf<RecordListViewFeature>
    
    var body: some View {
        VStack {
            switch store.usedTo {
                // 책장 -> 리스트
            case .usedToShelf:
                ShelfToRecordList()
                // 지도 -> 리스트
            case .usedToMap:
                MapToRecordList()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    store.send(.dismiss)
                } label: {
                     Image(systemName: "chevron.left")
                        .aspectRatio(contentMode: .fit)
                }
            }
            ToolbarItem(placement: .principal) {
                Text(store.usedTo == .usedToShelf ? store.selectedBook.title : store.localName)
                    .fontWeight(.semibold)
                    .foregroundStyle(.darkBrown)
                    .lineLimit(1)
            }
            if store.usedTo == .usedToShelf {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.send(.toggledBookDataDialog)
                    } label: {
                        Image(systemName: "info.circle")
                            .aspectRatio(contentMode: .fit)
                    }
                }
            }
        }
    }
    
    // MARK: - 책장에서 리스트로 넘어왔을 때, 년도마다 기록을 보여주는 화면
    @ViewBuilder
    private func ShelfToRecordList() -> some View {
        ZStack {
            ScrollView {
                ForEach(store.recordsYear, id: \.self) { year in
                    let recordsOfBook = store.recordsOfBook.filter { $0.year == year }
                    VStack(alignment: .leading) {
                        //
                        RecordTitleTag(title: String(year))
                            .padding(.horizontal, 20)
                        ForEach(recordsOfBook, id: \.id) { record in
                            //
                            CustomListDivider()
                            //
                            if let book = store.books.first(where: { $0.bookISBN == record.bookISBN }) {
                                NavigationLink(
                                    state: HomeViewFeature.Path.State.recordDetail(
                                        .init(record: record,
                                              isRecordIsLast: store.records.filter {
                                                  $0.bookISBN == record.bookISBN
                                              }.count == 1,
                                              book: book,
                                              region: Formatter.getMapCameraPosition(
                                                latitude: record.latitude,
                                                longitude: record.longitude)))) {
                                    RecordListCell(recordData: record)
                                }
                            } else {
                                RecordListCell(recordData: record)
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .padding(.top, 20)
            if store.showBookDataDialog {
                BookInfoDialog()
            }
        }
    }
    
    // MARK: - 지도에서 리스트로 넘어왔을 때, 책마다 기록을 보여주는 화면
    @ViewBuilder
    private func MapToRecordList() -> some View {
        ScrollView {
            ForEach(store.recordsBookData, id: \.self) { book in
                let recordsOfLocal = store.recordsOfLocal.filter { $0.bookISBN == book.bookISBN }
                VStack(alignment: .leading) {
                    //
                    RecordTitleTag(title: book.title)
                        .padding(.horizontal, 20)
                    ForEach(recordsOfLocal, id: \.id) { record in
                        //
                        CustomListDivider()
                        //
                        NavigationLink(
                            state: HomeViewFeature.Path.State.recordDetail(
                                .init(record: record,
                                      isRecordIsLast: recordsOfLocal.count == 1,
                                      book: book,
                                      region: Formatter.getMapCameraPosition(
                                        latitude: record.latitude,
                                        longitude: record.longitude)))) {
                            RecordListCell(recordData: record)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: - 기록 리스트 셀
    @ViewBuilder
    private func RecordListCell(recordData: MomentRecord) -> some View {
        VStack(spacing: 20) {
            HStack(alignment: .top, spacing: 15) {
                if let photoData = recordData.photos.first,
                   let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 90, height: 90)
                        .clipShape(
                            .rect(topLeadingRadius: 10.0, bottomLeadingRadius: 10.0,
                                  bottomTrailingRadius: 10.0, topTrailingRadius: 10.0)
                        )
                } else {
                    Image("defaultImage") // 임시 이미지
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 90, height: 90)
                        .clipShape(
                            .rect(topLeadingRadius: 10.0, bottomLeadingRadius: 10.0,
                                  bottomTrailingRadius: 10.0, topTrailingRadius: 10.0)
                        )
                }
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .lastTextBaseline) {
                        Text(recordData.monthAndDay)
                            .font(.medium16)
                            .foregroundStyle(.darkBrown)
                        Text(Formatter.timeToTimeZone(timeString: recordData.time))
                            .font(.medium14)
                            .foregroundStyle(.darkBrown)
                            .foregroundStyle(.black)
                    }
                    Text("“" + recordData.paragraph + "“")
                        .font(.regular16)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - 책 간단 상세 정보 보여주는 다이얼로그
    @ViewBuilder
    private func BookInfoDialog() -> some View {
        ZStack {
            // 배경
            Color.black.opacity(0.15)
            // 뷰
            VStack(alignment: .leading, spacing: 10) {
                //
                HStack(alignment: .top) {
                    // 책 제목
                    Text(store.selectedBook.title)
                        .font(.bold20)
                        .lineLimit(2)
                    Spacer()
                    // 닫기 버튼
                    Button {
                        store.send(.toggledBookDataDialog)
                    } label: {
                        Image(systemName: "xmark")
                            .frame(width: 24, height: 24)
                    }
                    .tint(.darkBrown)
                }
                //
                Divider()
                    .background(.darkBrown)
                    .frame(height: 1)
                // 책 - 작가, 출판사, 줄거리
                HStack(alignment: .top, spacing: 10) {
                    Text("지은이")
                        .font(.medium16)
                    Text(store.selectedBook.author)
                        .font(.light16)
                        .lineLimit(2)
                }
                HStack(alignment: .top, spacing: 10) {
                    Text("출판사")
                        .font(.medium16)
                    Text(store.selectedBook.publisher)
                        .font(.light16)
                        .lineLimit(2)
                }
                HStack(alignment: .top, spacing: 10) {
                    Text("줄거리")
                        .font(.medium16)
                    ScrollView {
                        VStack {
                            Text(store.selectedBook.plot)
                                .font(.light16)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .frame(minHeight: 0, maxHeight: 200)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(20)
            .background(.white)
            .clipShape(.rect(cornerRadius: 10))
            .padding(.horizontal, 25)
            .offset(x: 0, y: store.dialogOffset)
            .onAppear {
                store.send(.showBookDataDialog)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - 연도별 태그
private struct RecordTitleTag: View {
    let title: String   // String(year) || title
    
    fileprivate var body: some View {
        Text("\(title)")
            .foregroundColor(.mainBrown)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 3)
            .background(.offBrown)
            .clipShape(.rect(cornerRadius: 10))
            .fixedSize(horizontal: false, vertical: false)
            .lineLimit(1)
    }
}
