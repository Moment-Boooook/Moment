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
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                VStack(spacing: 0) {
                    switch store.selectedOption {
                    // 책장
                    case .bookShelf:
                        VStack(spacing: 20) {
                            HStack(alignment: .center, spacing: 20) {
                                // 서치바
                                searchBar()
                                    .frame(width: store.focusedField ? size.width - 40 : size.width - 100)
                                    .animation(.easeInOut(duration: 0.3),
                                               value: store.focusedField)
                                if !store.focusedField {
                                    // 설정
                                    settingButton()
                                        .transition(AnyTransition.opacity.animation(.easeInOut))
                                }
                            }
                            // 세그먼트
                            segment()
                            // 책장 뷰
                            BookShelf(store: store,
                                      maxWidth: size.width - 40)
                            .padding(.top, -10)
                        }
                        .padding(.horizontal, 20)
                    // 지도
                    case .map:
                        ZStack(alignment: .top) {
                            // 지도 뷰
                            RecordMap(store: store)
                            VStack(spacing: 20) {
                                HStack(alignment: .center, spacing: 20) {
                                    // 서치바
                                    searchBar()
                                        .frame(width: store.focusedField ? size.width - 40 : size.width - 100)
                                        .animation(.easeInOut(duration: 0.3),
                                                   value: store.focusedField)
                                    if !store.focusedField {
                                        // 설정
                                        settingButton()
                                            .transition(AnyTransition.opacity.animation(.easeInOut))
                                    }
                                }
                                // 세그먼트
                                segment()
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .navigationBarBackButtonHidden(true)
            // 네비게이션 이동
            } destination: { store in
                switch store.state {
                case .addBook:
                    if let store = store.scope(state: \.addBook, action: \.addBook) {
                        AddBookView(store: store)
                    }
                case .addRecord:
                    if let store = store.scope(state: \.addRecord, action: \.addRecord) {
                        AddRecordView(store: store)
                    }
                case .recordList:
                    if let store = store.scope(state: \.recordList, action: \.recordList) {
                        RecordListView(store: store)
                    }
                case .recordDetail:
                    if let store = store.scope(state: \.recordDetail, action: \.recordDetail) {
                        RecordDetailView(store: store)
                    }
                case .imageFull:
                    if let store = store.scope(state: \.imageFull, action: \.imageFull) {
                        ImageFullView(store: store)
                    }
                }
            }
            .tint(.darkBrown)
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
                .autocorrectionDisabled(true)
                .focused($focusedField)
                .onSubmit {
                    if !store.searchText.isEmpty {
                        store.send(.searchButtonTapped)
                    }
                }
                .submitLabel(.search)
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
    
    // MARK: - 세팅
    @ViewBuilder
    private func settingButton() -> some View {
        Button {
            //
        } label: {
            Image(systemName: "gearshape.fill")
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(height: 28)
                .foregroundStyle(.mainBrown)
        }
        .frame(width: 40, height: 40)
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
                userName: Shared(""),
                books: Shared([]),
                records: Shared([]),
                searchText: ""
            )
        ) {
            HomeViewFeature()
        }
    )
}
