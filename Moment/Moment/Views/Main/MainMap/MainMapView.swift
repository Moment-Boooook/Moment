//
//  MainMapView.swift
//  Moment
//
//  Created by Minjae Kim on 12/11/23.
//

import SwiftUI
import MapKit
import CoreLocation
import SwiftData

// AddRecordView에서 현재 위치를 저장 시
// LocalName enum 형태의 값으로 저장 후
// 그 값을 가져와ㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏ라.
struct MainMapView: View {
	@Binding var recordList: [MomentRecord]
	@State var dict: [LocalName: [MomentRecord]] = [:]
	let localNames = LocalName.allCases
	@State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.358391, longitude: 127.859669),
												   span: MKCoordinateSpan(latitudeDelta: 6, longitudeDelta: 6))
	
	var body: some View {
		Map(initialPosition: MapCameraPosition.region(region),
			bounds: .init(MapCameraBounds(maximumDistance: 1600000)), interactionModes: [.pan, .pitch, .zoom]) {
			// 딕셔너리가 비어있지 않을 때
			if !dict.isEmpty {
				// 딕셔너리의 키값으로 배열을 매핑 후 순회
				ForEach(dict.map { $0.key }, id: \.self) { local in
					if let data = dict[local]?.first, let count = dict[local]?.count, let bookRecordList = dict[local] {
						let bookISBNList = Set(bookRecordList.map { $0.bookISBN }).map { $0 }
						Annotation("", coordinate: local.coodinate, anchor: .bottom) {
							NavigationLink {
								MapToRecordListView(bookISBNList: bookISBNList,
													recordList: bookRecordList,
													localName: local.rawValue)
							} label: {
								ZStack {
									RoundRectBalloon()
										.fill(.white)
										.frame(width: 65, height: 65)
									if let photo = data.photos.first, let uiImage = UIImage(data: photo) {
										Image(uiImage: uiImage)
											.resizable()
											.frame(width: 60, height: 60)
											.clipShape(.rect(cornerRadius: 8))
									} else {
										Image("defaultImage")
											.resizable()
											.frame(width: 60, height: 60)
											.clipShape(.rect(cornerRadius: 8))
									}
								}
								.overlay {
									NotificationCount(value: count)
								}
							}
						}
					}
				}
			}
		}
		.task {
			await fetchLocalData()
		}
		.onChange(of: recordList) {
			Task {
				print("MainMapView에서 recordList 변경사항 있음")
				await fetchLocalData()
			}
		}
	}
	
	@MainActor
	func fetchLocalData() async {
		dict = Dictionary(grouping: recordList) { record in
			if let localName = localNames.first(where: { $0.rawValue == record.localName }) {
				return localName
			} else {
				return LocalName.defaultCase
			}
		}
		.compactMapValues { records in
			records.reduce(into: []) { result, record in
				result.append(record)
			}
		}
	}
}

//#Preview {
//	MainMapView(recordList: .constant(UserData.mangjaeData.recordList))
//}
