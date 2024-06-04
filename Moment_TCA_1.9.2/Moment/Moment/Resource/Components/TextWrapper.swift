//
//  TextWrapper.swift
//  Moment
//
//  Created by phang on 5/28/24.
//

import SwiftUI

// MARK: - 텍스트 복사를 가능하게 하기 위한 Wrapper 구조체
struct TextWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView
    
    var text: String
    var fontSize: CGFloat
    var fontWeight: FontType
    var lineSpacing: CGFloat = 5
    var allowTruncating: Bool = false
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = true
        textView.dataDetectorTypes = .link
        textView.backgroundColor = .clear
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        if allowTruncating {
            textView.textContainer.lineBreakMode = .byTruncatingTail
        } else {
            textView.textContainer.lineBreakMode = .byWordWrapping
        }
    
        let font = Formatter.convertCustomFontToUIFont(
            fontSize: fontSize,
            fontWeight: fontWeight)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributeString = NSAttributedString(string: text,
                                                 attributes: attributes)
        textView.attributedText = attributeString
        textView.setContentCompressionResistancePriority(.defaultLow,
                                                         for: .horizontal)
        textView.setContentCompressionResistancePriority(.defaultHigh,
                                                         for: .vertical)
        textView.textContainerInset = .zero
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        textView.text = text
        textView.sizeToFit()
        textView.layoutIfNeeded()
    }
}
