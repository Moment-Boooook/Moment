//
//  LocalName.swift
//  Moment
//
//  Created by Minjae Kim on 12/12/23.
//

import Foundation
import CoreLocation

// MARK: - 지역 데이터
struct RecordLocalData: Identifiable {
	let id = UUID()
	let localName: LocalName
	let coordinate: CLLocationCoordinate2D
	let imageNames: String
	
	static let dummyDatas = [
		RecordLocalData(localName: .seoul, coordinate: CLLocationCoordinate2D(latitude: 37.5111158, longitude: 127.098167), imageNames: "hoon"),
		RecordLocalData(localName: .seoul, coordinate: CLLocationCoordinate2D(latitude: 37.498097, longitude: 127.0252657), imageNames: "bono"),
		RecordLocalData(localName: .busan, coordinate: CLLocationCoordinate2D(latitude: 35.1531696, longitude: 129.118666), imageNames: "hoon"),
		RecordLocalData(localName: .busan, coordinate: CLLocationCoordinate2D(latitude: 35.1964215, longitude: 129.2153664), imageNames: "bono"),
		RecordLocalData(localName: .daegu, coordinate: CLLocationCoordinate2D(latitude: 35.8577321, longitude: 128.6251586), imageNames: "hoon"),
		RecordLocalData(localName: .daegu, coordinate: CLLocationCoordinate2D(latitude: 35.8596852, longitude: 128.4909276), imageNames: "bono"),
		RecordLocalData(localName: .incheon, coordinate: CLLocationCoordinate2D(latitude: 37.4516923, longitude: 126.7019408), imageNames: "hoon"),
		RecordLocalData(localName: .incheon, coordinate: CLLocationCoordinate2D(latitude: 37.4619316, longitude: 126.7014995), imageNames: "bono"),
		RecordLocalData(localName: .gwangju, coordinate: CLLocationCoordinate2D(latitude: 35.1542933, longitude: 126.8544584), imageNames: "hoon"),
		RecordLocalData(localName: .gwangju, coordinate: CLLocationCoordinate2D(latitude: 35.1428153, longitude: 126.8750229), imageNames: "bono"),
		RecordLocalData(localName: .daejeon, coordinate: CLLocationCoordinate2D(latitude: 36.3381738, longitude: 127.4458014), imageNames: "hoon"),
		RecordLocalData(localName: .daejeon, coordinate: CLLocationCoordinate2D(latitude: 36.3276642, longitude: 127.4272908), imageNames: "bono"),
		RecordLocalData(localName: .ulsan, coordinate: CLLocationCoordinate2D(latitude: 35.562012, longitude: 129.2301815), imageNames: "hoon"),
		RecordLocalData(localName: .ulsan, coordinate: CLLocationCoordinate2D(latitude: 35.556479, longitude: 129.2625956), imageNames: "bono"),
		RecordLocalData(localName: .sejong, coordinate: CLLocationCoordinate2D(latitude: 36.5046979, longitude: 127.2654033), imageNames: "hoon"),
		RecordLocalData(localName: .sejong, coordinate: CLLocationCoordinate2D(latitude: 36.5040885, longitude: 127.2716325), imageNames: "bono"),
		RecordLocalData(localName: .gyeonggi, coordinate: CLLocationCoordinate2D(latitude: 37.3401906, longitude: 126.7335293), imageNames: "hoon"),
		RecordLocalData(localName: .gyeonggi, coordinate: CLLocationCoordinate2D(latitude: 37.6355584, longitude: 127.2160832), imageNames: "hoon"),
		RecordLocalData(localName: .gangwon_do, coordinate: CLLocationCoordinate2D(latitude: 37.4538118, longitude: 129.1623725), imageNames: "bono"),
		RecordLocalData(localName: .gangwon_do, coordinate: CLLocationCoordinate2D(latitude: 37.8694561, longitude: 127.7444707), imageNames: "hoon"),
		RecordLocalData(localName: .chungcheongbuk_do, coordinate: CLLocationCoordinate2D(latitude: 36.9494546, longitude: 127.9083146), imageNames: "bono"),
		RecordLocalData(localName: .chungcheongbuk_do, coordinate: CLLocationCoordinate2D(latitude: 36.7219682, longitude: 127.4958842), imageNames: "hoon"),
		RecordLocalData(localName: .chungcheongnam_do, coordinate: CLLocationCoordinate2D(latitude: 36.819908, longitude: 127.1565357), imageNames: "bono"),
		RecordLocalData(localName: .chungcheongnam_do, coordinate: CLLocationCoordinate2D(latitude: 36.117623, longitude: 127.1038948), imageNames: "hoon"),
		RecordLocalData(localName: .jeollabuk_do, coordinate: CLLocationCoordinate2D(latitude: 35.8042209, longitude: 127.1024972), imageNames: "bono"),
		RecordLocalData(localName: .jeollabuk_do, coordinate: CLLocationCoordinate2D(latitude: 35.4072366, longitude: 127.3721176), imageNames: "hoon"),
		RecordLocalData(localName: .jeollanam_do, coordinate: CLLocationCoordinate2D(latitude: 35.3911021, longitude: 126.9142839), imageNames: "bono"),
		RecordLocalData(localName: .jeollanam_do, coordinate: CLLocationCoordinate2D(latitude: 35.0064798, longitude: 126.8256908), imageNames: "hoon"),
		RecordLocalData(localName: .gyeongsangbuk_do, coordinate: CLLocationCoordinate2D(latitude: 35.1596815, longitude: 128.2942985), imageNames: "bono"),
		RecordLocalData(localName: .gyeongsangbuk_do, coordinate: CLLocationCoordinate2D(latitude: 35.2036105, longitude: 128.1456443), imageNames: "hoon"),
		RecordLocalData(localName: .gyeongsangnam_do, coordinate: CLLocationCoordinate2D(latitude: 36.4379438, longitude: 128.2263061), imageNames: "bono"),
		RecordLocalData(localName: .gyeongsangnam_do, coordinate: CLLocationCoordinate2D(latitude: 36.5760207, longitude: 128.5055956), imageNames: "hoon"),
		RecordLocalData(localName: .jeju, coordinate: CLLocationCoordinate2D(latitude: 33.5070537, longitude: 126.492776), imageNames: "bono"),
		RecordLocalData(localName: .jeju, coordinate: CLLocationCoordinate2D(latitude: 33.3942945, longitude: 126.2398813), imageNames: "hoon")
	]
}


