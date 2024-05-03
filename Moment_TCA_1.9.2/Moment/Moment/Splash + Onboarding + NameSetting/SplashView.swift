//
//  SplashView.swift
//  Moment
//
//  Created by 정인선 on 12/14/23.
//

import SwiftUI

import ComposableArchitecture

// MARK: - Splash View
struct SplashView: View {
    let store: StoreOf<AppStartFeature>

    var body: some View {
        VStack(alignment: .center) {
            //
            Spacer()
            // 앱 로고 (with animation)
            HStack {
                Image("pieces")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .padding(.trailing, 5)
                Image("lastPiece")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .rotationEffect(.degrees(store.appLogoDegreeChange ? -9 : 0))
            }
            // 앱 title + 앱 sub title
            Text("Moment")
                .foregroundStyle(.darkBrown)
                .font(.medium36)
                .padding(5)
            Text("그 날, 그 곳, 그 구절")
                .foregroundStyle(.mainBrown)
                .font(.regular20)
                .opacity(0.5)
            //
            Spacer()
            // 앱 제작 정보
            VStack(alignment: .center) {
                Text("2023, Moment all rights reserved.")
                    .font(.light14)
                    .foregroundStyle(.gray2)
                Text("Powered by PJ2T3_BOOOOOK")
                    .font(.light14)
                    .foregroundStyle(.gray2)
            }
        }
        // 앱 시작 시, 애니메이션 동작 + splash 동작
        // books / records - SwiftData 에서 받아오기
        // 변경된 책 표지 업데이트
        .onAppear {
            store.send(.appStart)
        }
    }
}

#Preview {
    SplashView(
        store: Store(
            initialState: AppStartFeature.State(books: Shared([]),
                                                records: Shared([]))
        ) {
            AppStartFeature()
        }
    )
}
