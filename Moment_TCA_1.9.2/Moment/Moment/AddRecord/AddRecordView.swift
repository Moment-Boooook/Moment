//
//  AddRecordView.swift
//  Moment
//
//  Created by phang on 3/29/24.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

// MARK: - 기록 작성 뷰
struct AddRecordView: View {
    @Bindable var store: StoreOf<AddRecordViewFeature>
    @FocusState var focusedField: AddRecordViewFeature.State.Field?
    
    var body: some View {
        ScrollView {
            VStack {
                // 책 제목
                Text(store.book.title)
                    .font(.bold20)
                    .padding(.horizontal, 20)
                // 이미지
                KFImage.url(URL(string: store.book.theCoverOfBook))
                    .placeholder {
                        ProgressView()
                    }
                    .loadDiskFileSynchronously(true) // 디스크에서 동기적으로 이미지 가져오기
                    .cancelOnDisappear(true) // 화면 이동 시, 진행중인 다운로드 중단
                    .cacheMemoryOnly() // 메모리 캐시만 사용 (디스크 X)
                    .fade(duration: 0.2) // 이미지 부드럽게 띄우기
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120)
                // 작가
                Text(store.book.author)
                    .font(.regular16)
                    .padding(.horizontal, 20)
                //
                VStack(alignment: .leading) {
                    // 현재 위치
                    Text(AppLocalized.setCurrentLocation)
                        .font(.regular16)
                    //
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.lightBrown)
                            .foregroundStyle(.clear)
                        HStack {
                            // 주소
                            Text(store.place)
                                .font(.regular14)
                            //
                            Spacer()
                            //
                            Button {
                                // 지도 피커 열기
                                store.send(.openPickerMap)
                            } label: {
                                Image(systemName: AppLocalized.mapImage)
                                    .foregroundStyle(.lightBrown)
                            }
                            .sheet(isPresented: $store.isPickerMapSheet) {
                                LocationPickerMap(store: store)
                            }
                        }
                        .padding(10)
                    }
                    //
                    TextField(AppLocalized.locationAliasSetGuide,
                              text: $store.myLocationAlias.sending(\.setMyLocationAlias))
                        .textFieldStyle(.bordered())
                        .focused($focusedField, equals: .myLocationAlias)
                        .padding(.bottom, 20)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .submitLabel(.next)
                        .onSubmit {
                            store.send(.changeFocusedField)
                        }
                    //
                    Text(AppLocalized.setParagraph)
                        .font(.regular16)
                    TextField(AppLocalized.paragraphSetGuide,
                              text: $store.paragraph.sending(\.setParagraph))
                        .textFieldStyle(.bordered())
                        .focused($focusedField, equals: .paragraph)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .submitLabel(.next)
                        .onSubmit {
                            store.send(.changeFocusedField)
                        }
                    //
                    TextField(AppLocalized.pageSetGuide,
                              text: $store.page.sending(\.setPage))
                        .textFieldStyle(.bordered())
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
                        .autocorrectionDisabled(true)
                        .keyboardType(.default)
                        .onSubmit {
                            store.send(.changeFocusedField)
                        }
                    //
                    SelectedImageHorizontalScrollView()
                        .padding(.vertical)
                    //
                    Button {
                        store.send(.saveRecord)
                    } label: {
                        Text(store.isSaveable ? AppLocalized.disableRecordSaveButton : AppLocalized.recordSaveButton)
                            .font(.medium16)
                    }
                    .disabled(store.isSaveable)
                    .buttonStyle(.customProminent(color: store.isSaveable ? .gray3 : .lightBrown))
                    .alert($store.scope(state: \.alert, action: \.alert))
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
                    Image(systemName: AppLocalized.beforeImage)
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
                Text(AppLocalized.photoSet)
                    .font(.regular16)
                Text(AppLocalized.photoSetLimitGuide)
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
        .confirmationDialog(LocalizedStringKey(.empty),
                            isPresented: $store.showPhotoConfimationDialog,
                            titleVisibility: .hidden
        ) {
            Button {
                store.send(.checkCameraAuthorization)
            } label: {
                Text(AppLocalized.cameraButton)
            }
            Button {
                store.send(.checkPhotoLibraryAuthorization)
            } label: {
                Text(AppLocalized.libraryButton)
            }
        } message: {
            Text(AppLocalized.photosPickGuide)
        }
        .sheet(isPresented: $store.isCameraSnapSheet) {
            CameraSnap(store: store)
                .ignoresSafeArea(edges: .all)
        }
        .sheet(isPresented: $store.isPhotoPickerSheet) {
            PhotoPicker(store: store)
                .ignoresSafeArea(edges: .all)
        }
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
            Image(systemName: AppLocalized.xImage)
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
                    Image(systemName: AppLocalized.photoImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .foregroundStyle(.gray2)
                    Text(AppLocalized.photoSetGuide)
                        .font(.regular14)
                        .foregroundStyle(.gray1)
                }
            }
    }
}
