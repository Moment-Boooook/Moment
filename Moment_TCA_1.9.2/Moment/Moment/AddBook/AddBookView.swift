//
//  AddBookView.swift
//  Moment
//
//  Created by phang on 3/29/24.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

// MARK: - 책 찾아서 선택하는 뷰
struct AddBookView: View {
    @Bindable var store: StoreOf<AddBookViewFeature>
    @FocusState var focusedField: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            // 서치 바
            searchBar()
                .padding(.top, 10)
            //
            ZStack {
                Rectangle()
                    .fill(.background)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                VStack(alignment: .leading) {
                    // 검색 했을 경우,
                    if store.completedSearch {
                        // 검색 중일 때,
                        if store.isSearching {
                            VStack {
                                ProgressView()
                            }
                            .frame(maxHeight: .infinity, alignment: .center)
                            
                        // 결과 있을 때,
                        } else if !store.searchedBooks.isEmpty {
                            Text(AppLocalized.bookSearchResult)
                                .font(.semibold18)
                                .opacity(store.completedSearch ? 1.0 : 0.0)
                                .padding(.vertical, 10)
                            // 검색 된 책 목록
                            BookCellList(searchedBooks: store.searchedBooks,
                                         usedToSearch: true)
                        // 결과 없을 떄,
                        } else {
                            VStack {
                                Text(AppLocalized.bookSearchEmptyResult)
                                    .font(.semibold18)
                                    .foregroundStyle(.lightBrown)
                                    .opacity(store.completedSearch ? 1.0 : 0.0)
                            }
                            .frame(maxHeight: .infinity, alignment: .center)
                        }
                    // 검색 안했을 경우,
                    } else {
                        Text(store.books.isEmpty ? .empty : AppLocalized.bookLeftInMemory)
                            .font(.semibold18)
                            .padding(.vertical, 10)
                        // 기존 보유 책 목록
                        BookCellList(searchedBooks: store.books,
                                     usedToSearch: false)
                    }
                }
            }
            .onTapGesture {
                store.send(.clearFocusState)
            }
        }
        .padding(.horizontal, 20)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    store.send(.dismiss)
                } label: {
                    Image(systemName: AppLocalized.beforeImage)
                        .aspectRatio(contentMode: .fit)
                }
            }
            ToolbarItem(placement: .principal) {
                Text(AppLocalized.addBookTitle)
                    .font(.semibold18)
                    .foregroundStyle(.darkBrown)
            }
        }
    }
    
    // MARK: - 서치 바
    @ViewBuilder
    private func searchBar() -> some View {
        HStack(alignment: .center, spacing: 0) {
            // 검색 심볼
            Image(systemName: AppLocalized.searchImage)
                .foregroundStyle(.secondary)
                .padding(.leading, 14)
            //
            Spacer()
            // 검색 창
            TextField(AppLocalized.searchBookTitle,
                      text: $store.searchText.sending(\.setSearchText))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .focused($focusedField)
                .onSubmit {
                    store.send(.searchButtonTapped)
                }
                .submitLabel(.search)
            // 검색어 지우기
            if !store.searchText.isEmpty {
                Button {
                    store.send(.removeSearchText)
                    store.send(.clearFocusState)
                } label: {
                    Image(systemName: AppLocalized.xImage)
                        .foregroundStyle(.mainBrown)
                }
                .padding(.horizontal, 14)
            }
        }
        .bind($store.focusedField, to: $focusedField)
        .onChange(of: store.searchText) { _, newValue in
            if newValue == .empty {
                store.send(.endSearch)
            }
        }
        .frame(height: 40, alignment: .leading)
        .background(.white)
        .clipShape(.rect(cornerRadius: 15))
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(.mainBrown, lineWidth: 2)
        }
    }
    
    // MARK: - 검색 결과 ( 책 목록 )
    @ViewBuilder
    private func BookCellList(
        searchedBooks: [SelectedBook],
        usedToSearch: Bool
    ) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(searchedBooks, id: \.bookISBN) { book in
                    NavigationLink(
                        state: HomeViewFeature.Path.State.addRecord(
                            .init(book: book,
                                  myBooks: store.books)
                        )
                    ) {
                        BookCell(book: book)
                    }
                    .onAppear {
                        if book as? Book == store.searchedBooks.last,
                           usedToSearch {
                            store.send(.nextPage)
                        }
                    }
                    //
                    CustomListDivider()
                }
            }
            .padding(.horizontal, 20)
            // 추가 데이터 받을 때, 로딩 표시
            if store.isFetchNextPage {
                ProgressView()
                    .frame(height: 20)
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .padding(.horizontal, -20)
    }
}

// MARK: - 책 목록에 보여줄 셀
private struct BookCell: View {
    let book: SelectedBook
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top, spacing: 20) {
                // 이미지
                KFImage.url(URL(string: book.theCoverOfBook))
                    .placeholder {
                        ProgressView()
                    }
                    .loadDiskFileSynchronously(true) // 디스크에서 동기적으로 이미지 가져오기
                    .cancelOnDisappear(true) // 화면 이동 시, 진행중인 다운로드 중단
                    .cacheMemoryOnly() // 메모리 캐시만 사용 (디스크 X)
                    .fade(duration: 0.2) // 이미지 부드럽게 띄우기
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 87)
                    .clipped()
                // 제목, 작가, 출판사
                VStack(alignment: .leading, spacing: 10) {
                    Text(book.title)
                        .font(.medium16)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                    
                    VStack(alignment: .leading) {
                        Text(book.author)
                        Text(book.publisher)
                    }
                    .font(.medium14)
                    .foregroundStyle(.gray)
                    .lineLimit(1)
                }
            }
        }
    }
}

#Preview {
    AddBookView(
        store: Store(
            initialState: AddBookViewFeature.State(books: [])
        ) {
            AddBookViewFeature()
        }
    )
}
