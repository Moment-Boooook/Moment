//
//  Formatter.swift
//  Moment
//
//  Created by phang on 12/19/23.
//

import Foundation

// MARK: - Formatter
enum Formatter {
    // 시간 받아서 YYYY / MM월 dd일 / HHmm 로 반환
    static func formattedDateToString(date: Date) -> (year: Int, monthAndDay: String, time: String) {
        var year = Int()
        var monthAndDay = String()
        var time = String()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        year = Int(formatter.string(from: date)) ?? 2024
        formatter.dateFormat = "MM월 dd일"
        monthAndDay = formatter.string(from: date)
        formatter.dateFormat = "HHmm"
        time = formatter.string(from: date)
        return (year, monthAndDay, time)
    }
    
    // 지도에서 기록 카운트 뱃지 크기 조절 메서드
    static func widthMultiplier(_ value: Int) -> Double {
        if value < 10 {
            return 1.0
        }
        if value < 100 {
            return 1.5
        }
        return 2.0
    }
}