//
//  SearchBar.swift
//  Moment
//
//  Created by 백대홍 on 12/13/23.
//

import SwiftUI

struct SearchBar: View {
	@Binding var searchText: String
	@Binding var isTapButton: Bool
	@Binding var isSearch: Bool
	@FocusState var isSearchFocused: Bool
	
	var body: some View {
		HStack(alignment: .center, spacing: 0) {
			Image(systemName: "magnifyingglass")
				.foregroundStyle(Color.secondary)
				.padding(.leading)
			
			Spacer()
			
			TextField("책 제목", text: $searchText)
				.textInputAutocapitalization(.never)
				.focused($isSearchFocused)
				.onSubmit {
					isTapButton = true
				}
			
			if !searchText.isEmpty {
				Button(action: {
					searchText = ""
					isSearchFocused = true
					isSearch = false
				}, label: {
					Image(systemName: "xmark")
						.foregroundStyle(.mainBrown)
				})
				.padding(.horizontal, 10)
			}
			
			Button(action: {
				isTapButton = true
				isSearch = true
				isSearchFocused = false
				print("검색 버튼이 클릭되었습니다.")
			}) {
				Text("검색")
					.frame(width: 100,height: 40)
					.background(Color.mainBrown)
					.foregroundColor(Color.white)
					.clipShape(.rect(bottomTrailingRadius: 12, topTrailingRadius: 12))
			}
		}
		.frame(height: 40, alignment: .leading)
		.background(Color.white)
		.cornerRadius(15)
		.overlay(
			RoundedRectangle(cornerRadius: 15)
				.stroke(Color.mainBrown, lineWidth: 2)
		)
	}
}



//#Preview {
//	SearchBar(searchText: .constant("안뇽"), isTapButton: .constant(false))
//}
