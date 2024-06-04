//
//  Date +.swift
//  Moment
//
//  Created by phang on 5/20/24.
//

import Foundation

extension Date {
    // yyyy.MM.dd
    func formattedToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
    
        return dateFormatter.string(from: self)
    }
}
