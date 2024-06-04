//
//  BookShelf.swift
//  Moment
//
//  Created by phang on 3/28/24.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

// MARK: - 책장 View
struct BookShelf: View {
    @Bindable var store: StoreOf<HomeViewFeature>

    let maxWidth: CGFloat
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if store.books.isEmpty {
                NoContent(text: "\(store.userName)\(AppLocalized.emptyBookShelfMessage)")
                    .padding(.bottom, 60)
                    .padding(.horizontal, 20)
            } else if !store.searchText.isEmpty, store.searchedBooks.isEmpty, store.isSearching {
                NoContent(text: AppLocalized.bookSearchEmptyResult)
                    .padding(.bottom, 60)
                    .padding(.horizontal, 20)
            } else {
                ContentShelf(books: store.isSearching ? store.searchedBooks : store.books,
                             records: store.isSearching ? store.searchedRecords : store.records,
                             maxWidth: maxWidth)
                .padding(.bottom, 20)
            }
            NavigationLink(
                state: HomeViewFeature.Path.State.addBook(
                    .init(books: store.books))
            ) {
                Image(systemName: AppLocalized.plusImage)
                    .font(.medium30)
            }
            .buttonStyle(.circled(color: .lightBrown, size: 30))
            .padding(.trailing, 20)
            .padding(.bottom, 30)
        }
        .ignoresSafeArea()
    }
    
    // MARK: - 책이 책장에 없을 때 : No Content
    @ViewBuilder
    private func NoContent(text: String) -> some View {
        VStack {
            Text(text)
                .font(.regular20)
                .foregroundStyle(.lightBrown)
                .lineSpacing(2)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - 책장
    @ViewBuilder
    private func ContentShelf(books: [MomentBook],
                              records: [MomentRecord],
                              maxWidth: CGFloat) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 50) {
                ForEach(books, id: \.self) { book in
                    ZStack(alignment: .bottom) {
                        // 책 이미지
                        NavigationLink(
                            state: HomeViewFeature.Path.State.recordList(
                                .init(books: store.$books,
                                      records: store.$records,
                                      recordDictionary: store.$recordDictionary,
                                      usedTo: .usedToShelf,
                                      selectedBook: book,
                                      localName: .defaultCase))) {
                            BookImage(urlString: book.theCoverOfBook,
                                      maxWidth: maxWidth - 100)
                                .padding(.bottom, 10)
                        }
                        .zIndex(1)
                        // 책장 틀
                        CustomShelf(maxWidth: maxWidth - 40)
                    }
                    .padding(.top, 10)
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding(.top, 10)
    }
}

// MARK: - 책 표지
private struct BookImage: View {
    let urlString: String
    let maxWidth: CGFloat

    fileprivate var body: some View {
        KFImage.url(URL(string: urlString))
            .placeholder {
                ProgressView()
            }
            .loadDiskFileSynchronously(true) // 디스크에서 동기적으로 이미지 가져오기
            .cancelOnDisappear(true) // 화면 이동 시, 진행중인 다운로드 중단
            .cacheMemoryOnly() // 메모리 캐시만 사용 (디스크 X)
            .fade(duration: 0.2) // 이미지 부드럽게 띄우기
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: maxWidth / 2)
            .shadow(radius: 3, x: -3, y: -2)
    }
}

// MARK: - 책장 틀
private struct CustomShelf: View {
    let maxWidth: CGFloat

    fileprivate var body: some View {
        CustomShelfUP()
            .fill(.offBrown)
            .frame(width: maxWidth / 2)
            .padding(.bottom, 5)
        CustomShelfDOWN()
            .fill(.mainBrown)
            .frame(width: maxWidth / 2)
            .shadow(radius: 5, x: 0, y: 1)
    }
    
    private struct CustomShelfUP: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let height: CGFloat = 12
            
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY - height))
            path.addLine(to: CGPoint(x: rect.minX - 7, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX + 7, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - height))
            
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY - height))
            return path
        }
    }

    private struct CustomShelfDOWN: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let height: CGFloat = 5
            
            path.move(to: CGPoint(x: rect.minX , y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX - 7, y: rect.maxY - height))
            path.addLine(to: CGPoint(x: rect.maxX + 7, y: rect.maxY - height))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY - height))
            return path
        }
    }
}

#Preview {
    GeometryReader { geo in
        BookShelf(
            store: Store(
                initialState: HomeViewFeature.State(
                    userName: Shared(.empty),
                    books: Shared([]),
                    records: Shared([]),
                    recordDictionary: Shared([:]),
                    searchedBooks: Shared([]),
                    searchedRecords: Shared([]),
                    searchText: .empty
                )
            ) {
                HomeViewFeature()
            },
            maxWidth: geo.size.width - 40
        )
    }
}
