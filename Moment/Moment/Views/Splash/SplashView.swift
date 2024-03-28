//
//  SplashView.swift
//  Moment
//
//  Created by 정인선 on 12/14/23.
//

import SwiftUI
import ComposableArchitecture

struct SplashView: View {
//    @Binding var isActive: Bool
//    @State var degreeChange: Bool = false
	let store: StoreOf<SplashFeature>
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Spacer()
                
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
						.rotationEffect(.degrees(store.degreeChange ? -9 : 0))
                }
                
                Text("Moment")
                    .foregroundStyle(.darkBrown)
                    .font(.medium36)
                    .padding(5)
                
                Text("그 날, 그 곳, 그 구절")
                    .foregroundStyle(.mainBrown)
                    .font(.light20)
                    .opacity(0.5)
                
                Spacer()
                
                VStack(alignment: .center) {
                    Text("2023, Moment all rights reserved.")
                        .font(.footnote)
                        .foregroundStyle(.gray2)
                    Text("Powered by PJ2T3_BOOOOOK")
                        .font(.footnote)
                        .foregroundStyle(.gray2)
                }
            }
        }
        .onAppear {
//            withAnimation(.easeOut(duration: 2)) {
//                self.degreeChange = true
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
//                withAnimation {
//                    self.isActive = false
//                }
//            }
//			store.send(.degreeChange, animation: .easeOut(duration: 2))
//			
//			DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
//				store.send(.animationFinish, animation: .default)
//			}
			store.send(.appStart)
        }
    }
}


