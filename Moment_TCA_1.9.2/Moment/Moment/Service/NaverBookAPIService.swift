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
    private static let searchURLString = "https://openapi.naver.com/v1/search/book.json?query="
    
    var fetch: (String) async throws -> [Book]      // 책 제목 검색 결과 fetch
}

extension NaverBookAPIService: DependencyKey {
    static let liveValue = Self(
        fetch: { queryString in
            do {
                let data = try await fetchData(queryString: queryString)
                let json = try JSONDecoder().decode(BookList.self, from: data)
                return json.items
            } catch {
                throw NetworkError.invalidData
            }
        }
    )
}

extension NaverBookAPIService {
    // Data 를 반환하는 메서드
    private static func fetchData(queryString: String) async throws -> Data {
        guard let queryURL = URL(string: "\(searchURLString)\(queryString)") else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: queryURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            return data
        } catch {
            throw NetworkError.invalidResponse
        }
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
