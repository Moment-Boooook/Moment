//
//  MKCoordinateRegion +.swift
//  Moment
//
//  Created by phang on 3/29/24.
//

import Foundation
import MapKit

// MARK: - Map : MKCoordinateRegion +
extension MKCoordinateRegion {
    // 현재 앱에서 지도 보여줄 때, 시작 위치
    static func defaultRegion() -> MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 36.358391,
                longitude: 127.859669
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 6,
                longitudeDelta: 6
            )
        )
    }
}
