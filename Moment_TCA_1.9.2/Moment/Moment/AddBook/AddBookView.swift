//
//  AddBookView.swift
//  Moment
//
//  Created by phang on 3/29/24.
//

import SwiftUI

import ComposableArchitecture

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
                            Text("책 검색 결과")
                                .font(.semibold18)
                                .opacity(store.completedSearch ? 1.0 : 0.0)
                                .padding(.vertical, 10)
                            // 검색 된 책 목록
                            BookCellList(searchedBooks: store.searchedBooks)
                        // 결과 없을 떄,
                        } else {
                            VStack {
                                Text("책 검색 결과가 없어요.")
                                    .font(.semibold18)
                                    .foregroundStyle(.lightBrown)
                                    .opacity(store.completedSearch ? 1.0 : 0.0)
                            }
                            .frame(maxHeight: .infinity, alignment: .center)
                        }
                    // 검색 안했을 경우,
                    } else {
                        Text(store.books.isEmpty ? "" : "기억에 남겨진 책")
                            .font(.semibold18)
                            .padding(.vertical, 10)
                        // 기존 보유 책 목록
                        BookCellList(searchedBooks: store.books)
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
                    Image(systemName: "chevron.left")
                        .aspectRatio(contentMode: .fit)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("기억하고 싶은 책 선택하기")
                    .fontWeight(.semibold)
                    .foregroundStyle(.darkBrown)
            }
        }
    }
    
    // MARK: - 서치 바
    @ViewBuilder
    private func searchBar() -> some View {
        HStack(alignment: .center, spacing: 0) {
            // 검색 심볼
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .padding(.leading, 14)
            //
            Spacer()
            // 검색 창
            TextField("책 제목 검색", text: $store.searchText.sending(\.setSearchText))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .focused($focusedField)
                .onSubmit {
                    store.send(.searchButtonTapped)
                }
            // 검색어 지우기
            if !store.searchText.isEmpty {
                Button {
                    store.send(.removeSearchText)
                    store.send(.clearFocusState)
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.mainBrown)
                }
                .padding(.horizontal, 14)
            }
            // 검색 버튼
            Button {
                store.send(.searchButtonTapped)
                store.send(.clearFocusState)
            } label: {
                Text("검색")
                    .padding(.horizontal, 20)
                    .frame(height: 40)
                    .background(.mainBrown)
                    .foregroundStyle(.white)
                    .clipShape(.rect(bottomTrailingRadius: 13, topTrailingRadius: 13))
            }
        }
        .bind($store.focusedField, to: $focusedField)
        .onChange(of: store.searchText) { _, newValue in
            if newValue == "" {
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
    private func BookCellList(searchedBooks: [SelectedBook]) -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(0..<searchedBooks.count, id: \.self) { index in
                    let book = searchedBooks[index]
                    NavigationLink(
                        state: HomeViewFeature.Path.State.addRecord(
                            .init(book: book, myBooks: store.books))) {
                            BookCell(book: book)
                    }
                    //
                    CustomListDivider()
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.immediately)
    }
}

// MARK: - 책 목록에 보여줄 셀
private struct BookCell: View {
    let book: SelectedBook
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top, spacing: 20) {
                // 이미지
                AsyncImage(url: URL(string: book.theCoverOfBook)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
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