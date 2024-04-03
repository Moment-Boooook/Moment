//
//  BookShelf.swift
//  Moment
//
//  Created by phang on 3/28/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - 책장 View
struct BookShelf: View {
    let books: [MomentBook]
    let maxWidth: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if books.isEmpty {
                NoContent()
                    .padding(.bottom, 60)
                    .padding(.horizontal, 20)
            } else {
                ContentShelf(maxWidth: maxWidth, books: books)
                    .padding(.bottom, 20)
            }
            NavigationLink(
                state: HomeViewFeature.Path.State.addBook(
                    .init(books: books))) {
                Image(systemName: "plus")
                    .font(.medium30)
            }
            .buttonStyle(.circled(color: .lightBrown, size: 30))
            .padding(.trailing, 20)
            .padding(.bottom, 30)
        }
        .ignoresSafeArea()
    }
}

// MARK: - 책장
private struct ContentShelf: View {
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    let maxWidth: CGFloat
    let books: [MomentBook]

    fileprivate var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 50) {
                ForEach(books, id: \.self) { book in
                    ZStack(alignment: .bottom) {
                        // 책 이미지
//                        NavigationLink(store: ) { // ShelfRecordListView
//                        }
                        // TODO: - 위 네비 링크 내부에서 작동
                        BookImage(urlString: book.theCoverOfBook,
                                  maxWidth: maxWidth - 100)
                            .padding(.bottom, 10)
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
        AsyncImage(url: URL(string: urlString)) { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: maxWidth / 2)
                .shadow(radius: 3, x: -3, y: -2)
        } placeholder: {
            ProgressView()
        }
    }
}

// MARK: - 책이 책장에 없을 때 : No Content
private struct NoContent: View {
    fileprivate var body: some View {
        VStack {
            Text("책장이 비어있어요.\n 기억 속에 책을 남겨보세요.")
                .font(.regular20)
                .foregroundStyle(.lightBrown)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        BookShelf(books: [], maxWidth: geo.size.width - 40)
    }
}
