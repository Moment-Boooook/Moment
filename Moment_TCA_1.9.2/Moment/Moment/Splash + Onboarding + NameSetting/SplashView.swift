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
                Image(AppLocalized.logoBooks)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .padding(.trailing, 5)
                Image(AppLocalized.logoBook)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .rotationEffect(.degrees(store.appLogoDegreeChange ? -9 : 0))
            }
            // 앱 title + 앱 sub title
            Text(AppLocalized.appName)
                .foregroundStyle(.darkBrown)
                .font(.medium36)
                .padding(5)
            Text(AppLocalized.appSubTitle)
                .foregroundStyle(.mainBrown)
                .font(.regular20)
                .opacity(0.5)
            //
            Spacer()
            // 앱 제작 정보
            VStack(alignment: .center) {
                Text(AppLocalized.productionInfo)
                    .font(.light14)
                    .foregroundStyle(.gray2)
                    .lineSpacing(4)
            }
        }
        // 앱 시작 시, 애니메이션 동작 + splash 동작
        // books / records - SwiftData 에서 받아오기
        .onAppear {
            store.send(.appStart)
        }
    }
}

#Preview {
    SplashView(
        store: Store(
            initialState: AppStartFeature.State(userName: Shared(.empty),
                                                books: Shared([]),
                                                records: Shared([]))
        ) {
            AppStartFeature()
        }
    )
}
