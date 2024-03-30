//
//  AddRecordView.swift
//  Moment
//
//  Created by phang on 3/29/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - 기록 작성 뷰
struct AddRecordView: View {
    @Bindable var store: StoreOf<AddRecordViewFeature>
    @FocusState var focusedField: AddRecordViewFeature.State.Field?
    let book: SelectedBook
    
    var body: some View {
        ScrollView {
            VStack {
                // 책 제목
                Text(book.title)
                    .font(.bold20)
                    .padding(.horizontal, 20)
                // 이미지
                AsyncImage(url: URL(string: book.theCoverOfBook)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 70, height: 87)
                // 작가
                Text(book.author)
                    .font(.regular16)
                    .padding(.horizontal, 20)
                //
                VStack(alignment: .leading) {
                    // 현재 위치
                    Text("현재 위치")
                        .font(.regular16)
                    //
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.lightBrown)
                            .foregroundStyle(.clear)
                        HStack {
                            // 주소
                            Text(store.address)
                                .font(.regular14)
                            //
                            Spacer()
                            //
                            Button {
                                // 지도 피커 열기
                            } label: {
                                Image(systemName: "map")
                                    .foregroundStyle(.lightBrown)
                            }
//                            .sheet(isPresented: $showPickerMap) {
//                                LocationPickerMapView(showPickerMap: $showPickerMap,
//                                                      latitude: $latitude,
//                                                      longitude: $longitude,
//                                                      localName: $localName,
//                                                      place: $place)
//                            }
                        }
                        .padding(20)
                    }
                    //
                    TextField("위치를 기억할 이름을 지어주세요.",
                              text: $store.myLocationAlias.sending(\.setMyLocationAlias))
                        .textFieldStyle(BorderedTextFieldStyle())
                        .focused($focusedField, equals: .myLocationAlias)
                        .padding(.bottom, 20)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(false)
                        .onSubmit {
                            store.send(.changeFocusedField)
                        }
                    //
                    Text("기억할 내용")
                        .font(.regular16)
                    TextField("책에서 기억하고자 하는 문장을 적어주세요.",
                              text: $store.paragraph.sending(\.setParagraph))
                        .textFieldStyle(BorderedTextFieldStyle())
                        .focused($focusedField, equals: .paragraph)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(false)
                        .onSubmit {
                            store.send(.changeFocusedField)
                        }
                    //
                    TextField("해당 문장이 있는 페이지를 적어주세요.",
                              text: $store.page.sending(\.setPage))
                        .textFieldStyle(BorderedTextFieldStyle())
                        .focused($focusedField, equals: .page)
                        .keyboardType(.asciiCapableNumberPad)
                        .onSubmit {
                            store.send(.changeFocusedField)
                        }
                    //
                    TextEditor(text: $store.content.sending(\.setContent))
                        .font(.regular14)
                        .focused($focusedField, equals: .content)
                        .padding(5)
                        .frame(height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.lightBrown)
                        )
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(false)
                        .keyboardType(.default)
                        .onSubmit {
                            store.send(.changeFocusedField)
                        }
                    //
                    SelectedImageHorizontalScrollView()
                        .padding(.vertical)
                    //
                    Button {
                        // TODO: - 저장 alert 띄우기
                    } label: {
                        Text(store.isSaveable ? "아직 다 작성되지 않았어요" : "기억 저장하기")
                            .font(.medium16)
                    }
                    .disabled(!store.isSaveable)
                    .buttonStyle(.customProminent(color: store.isSaveable ? .gray3 : .lightBrown))
//                    .alert("기억을 남길까요?", isPresented: $showingAlert) {
//                        Button("돌아가기") {}
//                        Button("저장하기") {
//                            isRecord = true
//                            Task {
//                                await swiftDataInsert()
//                            }
////                            showMainView = true
//                            router.clear()
//                        }
//                    } message: {
//                        Text("저장된 기억은 수정할 수 없어요...🥲")
//                    }
                }
                .padding(20)
            }
        }
        .bind($store.focusedField, to: $focusedField)
        .navigationBarBackButtonHidden()
        .scrollDismissesKeyboard(.immediately)
        // 위치 정보 가져오기
        .task {
            store.send(.fetchLocation)
        }
        // 키보드 숨기기
        .onTapGesture {
            store.send(.clearFocusedField)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    store.send(.dismiss)
                } label: {
                    Image(systemName: "chevron.left")
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
    }
    
    @ViewBuilder
    private func SelectedImageHorizontalScrollView() -> some View {
        VStack(alignment: .leading) {
            //
            HStack(alignment: .lastTextBaseline) {
                Text("사진 등록")
                    .font(.regular16)
                Text("(최대 3장)")
                    .font(.regular14)
                    .foregroundStyle(.gray1)
            }
            //
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(0..<store.maxSelectImageCount, id: \.self) { index in
                        if store.selectedImages.count > index {
                            ImageView(uiImage: store.selectedImages[index],
                                      currentIndex: index)
                        } else {
                            EmptyImageView()
                                .onTapGesture {
                                    store.send(.togglePhotoConfimationDialog)
                                }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .confirmationDialog("",
                            isPresented: $store.showPhotoConfimationDialog,
                            titleVisibility: .hidden) {
            Button {
//                isCameraPresented.toggle()
            } label: {
                Text("카메라")
            }
            Button {
//                isLibraryPresented.toggle()
            } label: {
                Text("라이브러리")
            }
        } message: {
            Text("불러올 사진 위치를 선택해주세요")
        }
//        .sheet(isPresented: $isCameraPresented) {
//            CameraSnap(store: store)
//        }
//        .sheet(isPresented: $isLibraryPresented) {
//            let remainingSpaces = getRemainigSpaces()
//            PhotoPicker(selectedPhotos: $photoDummyData,
//                        isLibraryPresented: $isLibraryPresented,
//                        remainingSpaces: remainingSpaces)
//        }
    }
    
    // MARK: - 선택된 사진들 보여주는 이미지
    @ViewBuilder
    private func ImageView(uiImage: UIImage, currentIndex: Int) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 160, height: 160)
            .clipped()
            .clipShape(.rect(cornerRadius: 10))
            .overlay(alignment: .topTrailing) {
                Button {
                    store.send(.removePhoto(currentIndex))
                } label: {
                    XmarkOnGrayCircle()
                        .padding([.top, .trailing], 10)
                }
            }
    }
}

// MARK: - 등록되지 않은 이미지 상태
private struct XmarkOnGrayCircle: View {
    fileprivate var body: some View {
        ZStack {
            Circle()
                .fill(.gray2)
                .opacity(0.6)
                .frame(width: 28)
            Image(systemName: "xmark")
                .foregroundStyle(.white)
                .fontWeight(.semibold)
        }
    }
}

// MARK: - 사진 등록되지 않은 이미지 상태
private struct EmptyImageView: View {
    fileprivate var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.gray5)
            .stroke(.gray3, lineWidth: 1)
            .frame(width: 160, height: 160)
            .overlay {
                VStack(spacing: 10) {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .foregroundStyle(.gray2)
                    Text("사진을 등록하세요!")
                        .font(.regular14)
                        .foregroundStyle(.gray1)
                }
            }
    }
}
