//
//  LottieView.swift
//  Moment
//
//  Created by phang on 5/3/24.
//

import SwiftUI
import Lottie

// MARK: - 로티 애니메이션 뷰
struct LottieView: UIViewRepresentable {
    var name : String
    var loopMode: LottieLoopMode
    
    // JSON 파일 이름으로 애니메이션을 실행
    init(jsonName: String = "", loopMode : LottieLoopMode = .loop){
        self.name = jsonName
        self.loopMode = loopMode
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(name)
        animationView.animation = animation
        // AspectFit으로 적절한 크기의 에니매이션을 불러오기
        animationView.contentMode = .scaleAspectFit
        // 애니메이션은 동작 설정
        animationView.loopMode = loopMode
        // 애니메이션을 재생
        animationView.play()
        // 백그라운드에서 재생이 멈추는 오류를 잡기
        animationView.backgroundBehavior = .pauseAndRestore
  
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
         //레이아웃의 높이와 넓이의 제약
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        //
    }
}

#Preview {
    LottieView(jsonName: "book")
}
