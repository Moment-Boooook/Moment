//
//  String +.swift
//  Moment
//
//  Created by phang on 5/16/24.
//

import Foundation

extension String {
    func removeWhiteSpace() -> String {
        String(self.filter { !$0.isWhitespace })
    }
    
    static var empty: String {
        String()
    }
}
