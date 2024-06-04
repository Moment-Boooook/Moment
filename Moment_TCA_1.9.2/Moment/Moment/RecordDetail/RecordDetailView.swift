//
//  RecordDetailView.swift
//  Moment
//
//  Created by phang on 4/4/24.
//

import SwiftUI
import MapKit

import ComposableArchitecture

// MARK: - 기록 디테일 화면
struct RecordDetailView: View {
    @Bindable var store: StoreOf<RecordDetailViewFeature>
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            // 뷰
            ScrollView {
                VStack(alignment: .leading) {
                    // 이미지
                    ImageHorizontalScroll(size: size, images: store.record.photos)
                    // 텍스트
                    Group {
                        Text("\(store.record.page)\(AppLocalized.page)")
                            .font(.light14)
//                        TextWrapper(
//                            text: store.record.paragraph,
//                            fontSize: 18,
//                            fontWeight: .Medium
//                        )
//                        .padding(.bottom, 20)
                        Text(store.record.paragraph)
                            .font(.medium18)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 20)
//                        TextWrapper(
//                            text: store.record.commentary,
//                            fontSize: 16,
//                            fontWeight: .Regular
//                        )
//                        .padding(.bottom, 20)
                        Text(store.record.commentary)
                            .font(.regular16)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 20)
                        
                        Text(Formatter.timeToString(timeString: store.record.time))
                            .font(.light14)
                        HStack(spacing: 0) {
                            Text(store.record.myLocation)
                                .font(.semibold16)
                            Text(AppLocalized.recordMemory) // 에서의 기억이에요
                                .font(.regular16)
                        }
                    }
                    .padding(.horizontal, 20)
                    // 지도
                    MiniMap(coordinate: CLLocationCoordinate2D(
                        latitude: store.record.latitude,
                        longitude: store.record.longitude),
                            locationName: store.record.localName,
                            size: size)
                }
            }
            .scrollIndicators(.hidden)
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
                    Text("\(String(store.record.year))\(AppLocalized.year) \(store.record.monthAndDay)")
                        .font(.semibold18)
                        .foregroundStyle(.darkBrown)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.send(.deleteRecordButtonTapped)
                    } label: {
                        Image(systemName: AppLocalized.trashImage)
                            .aspectRatio(contentMode: .fit)
                    }
                }
            }
            // 삭제 버튼 alert
            .alert($store.scope(state: \.alert, action: \.alert))
        }
    }
    
    // MARK: - 기록된 이미지 가로 스크롤 뷰
    @ViewBuilder
    private func ImageHorizontalScroll(size: CGSize, images: [Data]) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(images, id: \.self) { imageData in
                    if let uiImage = UIImage(data: imageData) {
                        NavigationLink(
                            state: HomeViewFeature.Path.State.imageFull(
                                .init(image: uiImage))) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: max(size.width - 40, 0),
                                       height: size.height * 0.3)
                                .clipped()
                                .clipShape(.rect(cornerRadius: 10))
                                .shadow(radius: 3, x: 0, y: 5)
                        }
                    } else {
                        Image(AppLocalized.defaultImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: max(size.width - 40, 0),
                                   height: size.height * 0.3)
                            .clipped()
                            .clipShape(.rect(cornerRadius: 10))
                            .shadow(radius: 3, x: 0, y: 5)
                    }
                }
            }
            .scrollTargetLayout()
            .padding(20)
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
    }
    
    // MARK: - 기록된 위치를 볼 수 있는 미니 맵
    @ViewBuilder
    private func MiniMap(coordinate: CLLocationCoordinate2D,
                         locationName: String,
                         size: CGSize) -> some View {
        Map(position: $store.region.sending(\.setRegion),
            interactionModes: [.pan, .pitch, .zoom]) {
            Annotation(locationName, coordinate: coordinate) {
                ZStack {
                    Circle()
                        .fill(.pink)
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                store.send(.initialRegion(coordinate))
            } label: {
                ZStack {
                    Circle()
                        .fill(.gray4.opacity(0.8))
                        .frame(width: 40)
                    Image(systemName: AppLocalized.locationImage)
                        .fontWeight(.semibold)
                        .foregroundStyle(.darkBrown)
                }
            }
            .padding([.bottom, .trailing], 14)
        }
        .frame(height: max(size.height * 0.2, 0))
        .clipShape(.rect(cornerRadius: 10))
        .padding([.horizontal, .bottom], 20)
    }
}
