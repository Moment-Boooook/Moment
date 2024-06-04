//
//  PickerMap.swift
//  Moment
//
//  Created by phang on 12/12/23.
//

import SwiftUI
import MapKit

import ComposableArchitecture

// MARK: - 지도에서 위치 선택하는 시트 뷰
struct LocationPickerMap: View {
    @Bindable var store: StoreOf<AddRecordViewFeature>
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        VStack {
            ZStack {
                PickerMap(locationManager: locationManager)
                    .ignoresSafeArea(.all)
                MapBalloon()
                    .frame(width: 30, height: 55)
                    .foregroundStyle(locationManager.isChanging ? .pink.opacity(0.7) : .pink)
                    .offset(y: locationManager.isChanging ? -20 : -15)
                Circle()
                    .fill(locationManager.isChanging ? .white.opacity(0.7) : .white)
                    .frame(width: 12)
                    .offset(y: locationManager.isChanging ? -20 : -15)
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    locationManager.mapViewFocusChange()
                } label: {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.9))
                            .frame(width: 40)
                        Image(systemName: AppLocalized.locationImage)
                            .foregroundStyle(.darkBrown)
                            .fontWeight(.bold)
                    }
                }
                .padding([.bottom, .trailing])
            }
            VStack(alignment: .leading, spacing: 30) {
                Text(locationManager.place)
                    .font(.bold20)
                Button {
                    if !locationManager.isChanging {
                        store.latitude = locationManager.latitude
                        store.longitude = locationManager.longitude
                        store.localName = locationManager.localName
                        store.place = locationManager.place
                    }
                    store.isPickerMapSheet = false
                } label: {
                    Text(AppLocalized.locationSaveButton)
                        .font(.bold18)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.customProminent(color: locationManager.isChanging ? .gray3 : .lightBrown))
            }
            .padding()
        }
    }
}

// MARK: - 지도 에서 위치 선택하는 핀
private struct MapBalloon: Shape {
    fileprivate func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.midY),
                      control1: CGPoint(x: rect.midX, y: rect.maxY),
                      control2: CGPoint(x: rect.minX, y: rect.midY + rect.height / 5))
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2,
                    startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.maxY),
                      control1: CGPoint(x: rect.maxX, y: rect.midY + rect.height / 5),
                      control2: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}

// MARK: - 지도에서 위치 선택하는 뷰
private struct PickerMap: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager
    
    func makeUIView(context: Context) -> some UIView {
        return locationManager.mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //
    }
}

// MARK: - Location Manager : ObservableObject ( Not TCA )
final class LocationManager: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
    @Published var mapView: MKMapView = .init()
    @Published var isChanging: Bool = false
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    @Published var localName: String = .empty
    @Published var place: String = .empty
    private var manager: CLLocationManager = .init()
    private var currentGeoPoint: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        self.configureLocationManager()
    }
    
    // 위치 권한 여부 확인, 요청
    func configureLocationManager() {
        mapView.isRotateEnabled = false
        
        mapView.delegate = self
        manager.delegate = self

        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        let status = manager.authorizationStatus
        if status == .notDetermined {
            manager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    // 화면 이동 시, 호출
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        DispatchQueue.main.async {
            self.isChanging = true
        }
    }
    
    // 화면 이동 종료 시, 호출
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location: CLLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        self.convertLocationToAddress(location: location)
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        DispatchQueue.main.async {
            self.isChanging = false
        }
    }
    
    // 지도 포커스 옮기는 메서드
    func mapViewFocusChange() {
        let span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        // 현재 위치 받아서 위도 경도 넣어주기
        let region = MKCoordinateRegion(center: self.currentGeoPoint ?? CLLocationCoordinate2D(latitude: 37.5100, longitude: 126.9956),
                                        span: span)
        mapView.setRegion(region, animated: true)
    }
    
    // 위치 권한 변경 시 호출
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            guard let location = manager.location else {
                print("Error - No Location")
                return
            }
            self.currentGeoPoint = location.coordinate
            self.mapViewFocusChange()
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            self.convertLocationToAddress(location: location)
        }
    }
    
    // 사용자 위치 변경 시
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    // 현재 위치 가져오기 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - \(error.localizedDescription)")
    }
    
    // 주소 변환
    func convertLocationToAddress(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if error != nil {
                return
            }
            guard let placemark = placemarks?.first else { return }
            self.place = "\(placemark.country ?? .empty) \(placemark.locality ?? .empty) \(placemark.name ?? .empty)"
            self.localName = placemark.administrativeArea ?? .empty
        }
    }
}

