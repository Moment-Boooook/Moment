//
//  HomeView.swift
//  Moment
//
//  Created by phang on 3/27/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - Home View
struct HomeView: View {
    @Bindable var store: StoreOf<HomeViewFeature>
    @FocusState var focusedField: Bool

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            // 뷰
            NavigationStack {
                VStack(spacing: 0) {
                    switch store.selectedOption {
                    // 책장
                    case .bookShelf:
                        VStack(spacing: 20) {
                            // 서치바
                            searchBar()
                            // 세그먼트
                            segment()
                            // 책장 뷰
                            BookShelf(books: store.isSearching ? store.searchedBooks : store.books,
                                      maxWidth: size.width - 40)
                        }
                        .padding(.horizontal, 20)
                    // 지도
                    case .map:
                        ZStack(alignment: .top) {
                            // 지도 뷰
                            RecordMap(store: store)
                            VStack(spacing: 20) {
                                // 서치바
                                searchBar()
                                // 세그먼트
                                segment()
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .navigationBarBackButtonHidden(true)
//                .onChange(of: recordList) {
//                    Task {
//                        mainBookList = bookList
//                        mainRecordList = recordList
//                        
//                        // Query로 저장되어있는 기록리스트 변경 시 검색된 데이터가 있다면 데이터 업데이트
//                        if isSearch {
//                            searchRecordList = await recordSearch(bookSearch: bookSearch)
//                        }
//                    }
//                }
            }
            .tint(.darkBrown)
            // books / records - SwiftData 에서 받아오기
            .task {
                store.send(.onAppear)
            }
            .onTapGesture {
                store.send(.clearFocusState)
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
                    store.send(.startSearch)
                }
            // 검색어 지우기
            if !store.searchText.isEmpty {
                Button {
                    store.send(.removeSearchText)
                    store.send(.endSearch)
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.mainBrown)
                }
                .padding(.horizontal, 14)
            }
            // 검색 버튼
            Button {
                store.send(.searchButtonTapped)
                store.send(.startSearch)
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
    
    // MARK: - 책장 / 지도 Segment
    @ViewBuilder
    private func segment() -> some View {
        HStack(spacing: 0) {
            ForEach(store.options, id: \.self) { option in
                ZStack(alignment: .center) {
                    // 세그먼트 모양
                    Rectangle()
                        .fill(.offBrown)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(store.selectedOption == option ? .mainBrown : .offBrown)
                        .padding(2)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.clear, lineWidth: 2)
                                .padding(.horizontal, -2)
                        }
                        // 세그먼트 변경
                        .onTapGesture {
                            store.send(.toggleSelectedOption(option))
                        }
                    // 세그먼트 텍스트
                    Text(option.rawValue)
                        .foregroundStyle(store.selectedOption == option ? .white : .mainBrown)
                        .padding(.horizontal, 10)
                }
            }
        }
        .frame(height: 40)
        .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    HomeView(
        store: Store(
            initialState: HomeViewFeature.State(
                searchText: "",
                books: [],
                records: [])
        ) {
            HomeViewFeature()
        }
    )
}
