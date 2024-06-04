//
//  NaverBookAPIService.swift
//  Moment
//
//  Created by phang on 3/29/24.
//

import Foundation

import ComposableArchitecture

// MARK: - Naver Book API Service
struct NaverBookAPIService {
    private static let clientID = Bundle.main.bookID
    private static let clientSecret = Bundle.main.bookSECRET
    private static let searchURLString = Endpoint.naverAPIURL
    
    var fetch: (String) async throws -> (books: [Book],
                                         total: Int)            // 책 제목 검색 결과 fetch
    var nextPageFetch: (String, Int) async throws -> [Book]     // 페이징 fetch
}

extension NaverBookAPIService: DependencyKey {
    static let liveValue = Self(
        fetch: { queryString in
            do {
                let data = try await fetchData(searchText: queryString)
                let json = try JSONDecoder().decode(BookList.self, from: data)
                return (books: json.items, total: json.total)
            } catch {
                throw NetworkError.errorDecoding
            }
        },
        nextPageFetch: { (queryString, startPoint) in
            do {
                let data = try await fetchData(searchText: queryString,
                                               startPoint: startPoint)
                let json = try JSONDecoder().decode(BookList.self, from: data)
                return json.items
            } catch {
                throw NetworkError.errorDecoding
            }
        }
    )
}

extension NaverBookAPIService {
    // Data 를 반환하는 메서드
    private static func fetchData(
        searchText: String,
        startPoint: Int = 1
    ) async throws -> Data {
        let queryURL = try convertQueryURL(searchText: searchText,
                                           startPoint: startPoint)
        //
        var request = URLRequest(url: queryURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(Endpoint.naverAPIContentType,
                         forHTTPHeaderField: Endpoint.headerFieldType)
        request.addValue(clientID,
                         forHTTPHeaderField: Endpoint.headerFieldID)
        request.addValue(clientSecret,
                         forHTTPHeaderField: Endpoint.headerFieldSecret)
        //
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknownError
            }
            //
            switch httpResponse.statusCode {
            case HttpResponseStatus.ok:
                return data
            case HttpResponseStatus.clientError:
                throw NetworkError.clientError
            case HttpResponseStatus.serverError:
                throw NetworkError.serverError
            default:
                throw NetworkError.unknownError
            }
        } catch {
            throw NetworkError.unknownError
        }
    }
    
    // query URL 변환 메서드
    private static func convertQueryURL(
        searchText: String,
        startPoint: Int
    ) throws -> URL {
        let queryString = "\(searchURLString)\(searchText)\(Endpoint.displayCount)\(Endpoint.startPoint)\(startPoint)\(Endpoint.sortType)"
        guard let queryURL = URL(string: queryString) else {
            throw NetworkError.errorInUrl
        }
        return queryURL
    }
}

// MARK: - TCA : DependencyValues +
extension DependencyValues {
    // Naver Book API Service
    var naverBookService: NaverBookAPIService {
        get { self[NaverBookAPIService.self] }
        set { self[NaverBookAPIService.self] = newValue }
    }
}
