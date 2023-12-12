//
//  SearchBar.swift
//  Moment
//
//  Created by 백대홍 on 12/11/23.
//

import SwiftUI

struct SearchBar: View {
    @State var searchBookText = ""
    @StateObject var network = BookAPI.shared
    @Binding var searchResults: [Book]
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.secondary)
            
            Spacer()
            TextField("책 제목", text: $searchBookText)
                .textInputAutocapitalization(.never)
            
            Button(action: searchBooks) {
                Text("검색")
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .frame(width: 100,height: 50)
                    .background(Color.mainBrown)
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
            }
            .padding(.leading)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 7)
        .frame(height: 40, alignment: .leading)
        .background(.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.mainBrown, lineWidth: 2)
        )
    }
    private func searchBooks() {
        Task {
            do {
                searchResults = try await network.fetchData(queryValue: searchBookText)
            } catch let error as NetworkError {
                print("Network error: \(error.errorMessage)")
            } catch {
                print("Unexpected error: \(error.localizedDescription)")
            }
        }
    }
}

//#Preview {
//    SearchBar()
//}
