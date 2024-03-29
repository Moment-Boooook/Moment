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
        VStack(spacing: -30) {
            // 서치 바
            searchBar()
                .padding(20)
            //
            VStack(alignment: .leading) {
                // 검색 텍스트가 비어있을 경우
                if store.searchText.isEmpty {
                    Text(store.books.isEmpty ? "" : "기억에 남겨진 책")
                        .font(.semibold18)
                        .padding(30)
                    // 기존 보유 책 목록
                    BookCellList(books: store.books)
                    // 책 검색 시,
                } else {
                    // 검색 결과가 있을 경우
                    if !store.searchedBooks.isEmpty {
                        Text("책 검색 결과")
                            .font(.semibold18)
                            .opacity(store.completedSearch ? 1.0 : 0.0)
                            .padding(30)
                        // 검색 된 책 목록
                        BookCellList(books: store.searchedBooks)
                        // 검색 결과가 없을 경우
                    } else {
                        VStack {
                            Spacer()
                            Text("책 검색 결과가 없어요.")
                                .font(.semibold18)
                                .foregroundStyle(.lightBrown)
                                .opacity(store.completedSearch ? 1.0 : 0.0)
                                .padding(30)
                        }
                    }
                }
            }
        }
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
                .autocorrectionDisabled(false)
                .focused($focusedField)
                .onSubmit {
                    store.send(.searchButtonTapped)
                }
            // 검색어 지우기
            if !store.searchText.isEmpty {
                Button {
                    store.send(.removeSearchText)
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.mainBrown)
                }
                .padding(.horizontal, 14)
            }
            // 검색 버튼
            Button {
                store.send(.searchButtonTapped)
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
        .frame(height: 40, alignment: .leading)
        .background(.white)
        .clipShape(.rect(cornerRadius: 15))
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(.mainBrown, lineWidth: 2)
        }
    }
}

// MARK: - 검색 결과 ( 책 목록 )
private struct BookCellList: View {
    let books: [SelectedBook]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: -30) {
                ForEach(0..<books.count, id: \.self) { index in
                    let book = books[index]
//                    NavigationLink(store: ) {
//                        // AddRecordView
//                    }
                    Button {
                        //
                    } label: {
                        BookCell(book: book)
                    }
                    //
                    CustomListDivider()
                }
            }
        }
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
        .padding(30)
    }
}

#Preview {
    AddBookView(
        store: Store(
            initialState: AddBookViewFeature.State()
        ) {
            AddBookViewFeature()
        }
    )
}
