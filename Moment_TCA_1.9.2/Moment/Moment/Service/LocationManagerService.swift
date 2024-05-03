//
//  LocationManagerService.swift
//  Moment
//
//  Created by phang on 3/30/24.
//

import Foundation
import MapKit

import ComposableArchitecture

// MARK: - CLLocationManager 관련 Service
struct LocationManagerService {
    var fetch: () async throws -> (latitude: Double, longitude: Double, place: String, localName: String)
}

extension LocationManagerService: DependencyKey {
    static let liveValue = Self(
        fetch: {
            let manager = CLLocationManager()
            manager.requestWhenInUseAuthorization()
            
            return await withCheckedContinuation { continuation in
                Task {
                    // 위치 정보 동의가 이루어질 때까지 대기
                    while manager.authorizationStatus == .notDetermined {
                        try await Task.sleep(nanoseconds: 100_000_000)  // 0.1초
                    }
                    if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
                        manager.desiredAccuracy = kCLLocationAccuracyBest
                        do {
                            let result = try await fetchLocation(manager: manager)
                            continuation.resume(returning: result)
                        } catch {
                            throw LocationManagerError.geoCoding
                        }
                    } else {
                        throw LocationManagerError.authorizationDenied
                    }
                }
            }
            
            @Sendable func fetchLocation(manager: CLLocationManager) async throws -> (latitude: Double, longitude: Double, place: String, localName: String) {
                var latitude = Double()
                var longitude = Double()
                var place = String()
                var localName = String()
                guard let location = manager.location else {
                    throw LocationManagerError.invalidManager
                }
                latitude = location.coordinate.latitude
                longitude = location.coordinate.longitude
                let clLocation = CLLocation(latitude: latitude,
                                            longitude: longitude)
                let geoCoder = CLGeocoder()
                let locale = Locale(identifier: "ko-KR")
                let placemarks = try await geoCoder.reverseGeocodeLocation(clLocation, preferredLocale: locale)
                if let address = placemarks.last {
                    place = "\(address.country ?? "") \(address.locality ?? "") \(address.name ?? "")"
                    localName = address.administrativeArea ?? ""
                }
                return (latitude, longitude, place, localName)
            }            
        }
    )
}

// MARK: - TCA : DependencyValues +
extension DependencyValues {
    // CLLocation Service
    var locationManagerService: LocationManagerService {
        get { self[LocationManagerService.self] }
        set { self[LocationManagerService.self] = newValue }
    }
}
