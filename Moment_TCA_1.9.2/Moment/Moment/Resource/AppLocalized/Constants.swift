//
//  Constants.swift
//  Moment
//
//  Created by phang on 3/29/24.
//

import Foundation
import CoreLocation

// MARK: - Record List Type
enum RecordListType {
    case usedToMap
    case usedToShelf
}

// MARK: - Home View Segment enum
enum HomeSegment: String, CaseIterable {
    case bookShelf = "책장으로 보기"
    case map = "지도로 보기"
}

// MARK: - 지역 별 이름 & 위도, 경도
enum LocalName: String, CaseIterable {
    case seoul = "서울특별시"
    case busan = "부산광역시"
    case daegu = "대구광역시"
    case incheon = "인천광역시"
    case gwangju = "광주광역시"
    case daejeon = "대전광역시"
    case ulsan = "울산광역시"
    case sejong = "세종특별자치시"
    case gyeonggi = "경기도"
    case gangwon_do = "강원도"
    case chungcheongbuk_do = "충청북도"
    case chungcheongnam_do = "충청남도"
    case jeollabuk_do = "전라북도"
    case jeollanam_do = "전라남도"
    case gyeongsangbuk_do = "경상북도"
    case gyeongsangnam_do = "경상남도"
    case jeju = "제주특별자치도"
    case defaultCase = "없음"
    
    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .seoul:
            return CLLocationCoordinate2D(latitude: 37.5518911, longitude: 126.9917937)
        case .busan:
            return CLLocationCoordinate2D(latitude: 35.2100142, longitude: 129.0688702)
        case .daegu:
            return CLLocationCoordinate2D(latitude: 35.8294374, longitude: 128.5655119)
        case .incheon:
            return CLLocationCoordinate2D(latitude: 37.4562557, longitude: 126.7052062)
        case .gwangju:
            return CLLocationCoordinate2D(latitude: 35.1557358, longitude: 126.8354271)
        case .daejeon:
            return CLLocationCoordinate2D(latitude: 36.3398175, longitude: 127.3940486)
        case .ulsan:
            return CLLocationCoordinate2D(latitude: 35.5537228, longitude: 129.2380554)
        case .sejong:
            return CLLocationCoordinate2D(latitude: 36.5606976, longitude: 127.2587334)
        case .gyeonggi:
            return CLLocationCoordinate2D(latitude: 37.5289145, longitude: 127.1727772)
        case .gangwon_do:
            return CLLocationCoordinate2D(latitude: 37.724962, longitude: 128.3009629)
        case .chungcheongbuk_do:
            return CLLocationCoordinate2D(latitude: 36.7378449, longitude: 127.8305242)
        case .chungcheongnam_do:
            return CLLocationCoordinate2D(latitude: 36.5296003, longitude: 126.8590621)
        case .jeollabuk_do:
            return CLLocationCoordinate2D(latitude: 35.7197198, longitude: 127.1243977)
        case .jeollanam_do:
            return CLLocationCoordinate2D(latitude: 34.9402001, longitude: 126.9565003)
        case .gyeongsangbuk_do:
            return CLLocationCoordinate2D(latitude: 36.3436011, longitude: 128.7401566)
        case .gyeongsangnam_do:
            return CLLocationCoordinate2D(latitude: 35.369563, longitude: 128.2570135)
        case .jeju:
            return CLLocationCoordinate2D(latitude: 33.3846216, longitude: 126.5534925)
        case .defaultCase:
            return CLLocationCoordinate2D(latitude: 37.5518911, longitude: 126.9917937)
        }
    }
}

// MARK: - 네트워크 에러
enum NetworkError: Error {
    case clientError
    case serverError
    case unknownError
    case errorInUrl
    case errorDecoding
    
    var errorMessage: String {
        switch self {
        case .clientError:
            return "클라이언트 오류"
        case .serverError:
            return "서버 오류"
        case .unknownError:
            return "알 수 없는 오류"
        case .errorInUrl:
            return "잘못된 URL"
        case .errorDecoding:
            return "디코딩 실패"
        }
    }
}

// MARK: - 네트워크 에러
enum LocationManagerError: Error {
    case invalidManager
    case geoCoding
    case authorizationDenied
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case get = "GET"
}

// MARK: - HTTP Response Status
enum HttpResponseStatus {
    static let ok = 200...299
    static let clientError = 400...499
    static let serverError = 500...599
}

// MARK: - Naver API
enum Endpoint {
    static let naverAPIURL = "https://openapi.naver.com/v1/search/book.json?query="
    static let naverAPIContentType = "application/json"
    static let headerFieldType = "Content-Type"
    static let headerFieldID = "X-Naver-Client-Id"
    static let headerFieldSecret = "X-Naver-Client-Secret"
}
