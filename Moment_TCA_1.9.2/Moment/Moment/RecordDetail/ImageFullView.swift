//
//  ImageFullView.swift
//  Moment
//
//  Created by phang on 4/4/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - 디테일에서 이미지 눌러서 크게 보는 화면
struct ImageFullView: View {
    @Bindable var store: StoreOf<ImageFullViewFeature>
    
    var body: some View {
        ZStack {
            // 배경
            Color.black.ignoresSafeArea()
            // 이미지
            Image(uiImage: store.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(store.scale)
                .gesture(MagnificationGesture()
                    .onChanged { state in
                        store.send(.adjustScale(state))
                    }
                    .onEnded { state in
                        store.send(.validateScaleLimits)
                    }
                )
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            store.send(.dismiss)
                        } label: {
                            Image(systemName: AppLocalized.beforeImage)
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(.offBrown)
                        }
                    }
                }
        }
    }
}
