//
//  RecordMap.swift
//  Moment
//
//  Created by phang on 3/29/24.
//

import SwiftUI
import MapKit
import CoreLocation
import SwiftData

import ComposableArchitecture

// MARK: - 지도 View
struct RecordMap: View {
    @Bindable var store: StoreOf<HomeViewFeature>
    
    var body: some View {
        Map(initialPosition: MapCameraPosition.region(MKCoordinateRegion.defaultRegion()),
            bounds: .init(MapCameraBounds(maximumDistance: 1_600_000)),
            interactionModes: [.pan, .pitch, .zoom]) {
            // 값이 있을 때,
            if !store.recordDictionary.isEmpty {
                ForEach(store.recordDictionary.map { $0.key }, id: \.self) { local in
                    //
                    if let data = store.recordDictionary[local]?.first,
                       let count = store.recordDictionary[local]?.count,
                       let records = store.recordDictionary[local] {
                        Annotation("", coordinate: local.coordinate, anchor: .bottom) {
                            NavigationLink(
                                state: HomeViewFeature.Path.State.recordList(
                                    .init(books: store.$books,
                                          records: store.$records,
                                          usedTo: .usedToMap,
                                          selectedBook: MomentBook(bookISBN: "",
                                                                   theCoverOfBook: "",
                                                                   title: "",
                                                                   author: "",
                                                                   publisher: "",
                                                                   plot: ""),
                                          localName: local.rawValue,
                                          recordsOfLocal: records))) {
                                MarkerButton(size: 65,
                                             innerSize: 60,
                                             data: data)
                                .overlay {
                                    NotificationCount(value: count)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: store.isSearching) { _, _ in
            store.send(.fetchRecordDictionary)
        }
        .task {
            store.send(.fetchRecordDictionary)
        }
    }
}

// MARK: - 지도에 띄울 마커 버튼
private struct MarkerButton: View {
    let size: CGFloat
    let innerSize: CGFloat
    let data: MomentRecord
    
    fileprivate var body: some View {
        VStack {
            ZStack {
                RoundRectBalloon()
                    .fill(.white)
                    .frame(width: size, height: size)
                
                if let photo = data.photos.first,
                   let uiImage = UIImage(data: photo) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(.rect(cornerRadius: 8))
                } else {
                    Image("defaultImage")
                        .resizable()
                        .frame(width: innerSize, height: innerSize)
                        .clipShape(.rect(cornerRadius: 8))
                }
            }
        }
    }
}

// MARK: - 지도에 띄울 사각형 어노테이션 형태
private struct RoundRectBalloon: Shape {
    fileprivate func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = 10.0
        
        path.move(to: CGPoint(x: rect.minX + 10,
                              y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - 10,
                                 y: rect.minY))
        
        path.addRelativeArc(center: CGPoint(x: rect.maxX - 10,
                                            y: rect.minY + radius),
                            radius: radius,
                            startAngle: Angle.degrees(-90),
                            delta: Angle.degrees(90))
        
        path.move(to: CGPoint(x: rect.maxX,
                              y: rect.minY + radius))
        
        path.addLine(to: CGPoint(x: rect.maxX,
                                 y: rect.maxY - radius))
        path.addRelativeArc(center: CGPoint(x: rect.maxX - radius,
                                            y: rect.maxY - radius),
                            radius: radius,
                            startAngle: Angle.degrees(0),
                            delta: Angle.degrees(90))
        
        path.addLine(to: CGPoint(x: rect.midX + radius,
                                 y: rect.maxY))
        
        path.addLine(to: CGPoint(x: rect.midX, y:
                                    rect.maxY + 15))
        path.addLine(to: CGPoint(x: rect.midX - radius,
                                 y: rect.maxY))
        path.addRelativeArc(center: CGPoint(x: rect.minX + radius,
                                            y: rect.maxY - radius),
                            radius: radius,
                            startAngle: Angle.degrees(90),
                            delta: Angle.degrees(90))
        
        path.addLine(to: CGPoint(x: rect.minX,
                                 y: rect.minY + 10))
        path.addRelativeArc(center: CGPoint(x: rect.minX + radius,
                                            y: rect.minY + 10),
                            radius: radius,
                            startAngle: Angle.degrees(-180),
                            delta: Angle.degrees(90))
        return path
    }
}

// MARK: - 지도 마커에 띄워줄 기록 카운트 뱃지
private struct NotificationCount: View {
    private let x: CGFloat = 65
    private let y: CGFloat = 0
    let value: Int

    var body: some View {
        ZStack {
            Capsule()
                .fill(.darkBrown)
                .frame(width: 25 * Formatter.widthMultiplier(value), height: 25)
                .position(x: x, y: y)
            if value < 100 {
                Text("\(value)")
                    .foregroundStyle(.white)
                    .position(x: x, y: y)
                    .font(.light20)
            } else {
                Text("99+")
                    .foregroundStyle(.white)
                    .position(x: x, y: y)
                    .font(.light20)
            }
        }
    }
}

#Preview {
    RecordMap(
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
