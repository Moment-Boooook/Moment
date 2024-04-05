//
//  Formatter.swift
//  Moment
//
//  Created by phang on 12/19/23.
//

import SwiftUI
import MapKit

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
        } else if value < 100 {
            return 1.5
        } else {
            return 2.0
        }
    }
    
    // UIimage -> Data 변환 메서드
    static func uiImageToData(images: [UIImage]) -> [Data] {
        var imageDatas: [Data] = []
        for image in images {
            let image = image.resize(newWidth: 300)
            if let jpegData = image.jpegData(compressionQuality: 1.0) {
                imageDatas.append(jpegData)
            } else if let pngData = image.pngData() {
                imageDatas.append(pngData)
            }
        }
        return imageDatas
    }
    
    // 시간 (Int) -> 시간대 (String) : 기록 리스트에서 사용
    static func timeToTimeZone(timeString: String) -> String {
        switch Int(timeString.prefix(2)) ?? 0 {
        case 0...5: 
            return "새벽"
        case 6...11: 
            return "아침"
        case 12...16: 
            return "낮"
        case 17...23: 
            return "밤"
        default: 
            return "새벽"
        }
    }
    
    // 시간 (Int) -> 시간 (String) : 기록 디테일에서 사용
    static func timeToString(timeString: String) -> String {
        let hour = Int(timeString.prefix(2)) ?? 0
        let minute = Int(timeString.suffix(2)) ?? 0
        var result = ""
        switch hour {
        case 0:
            result += "오전 12시"
        case 1...11:
            result += "오전 \(hour)시"
        case 12:
            result += "오후 \(hour)시"
        default:
            result += "오후 \(hour - 12)시"
        }
        
        return result + " \(minute)분"
    }
    
    // 카메라 포지션 반환 : 기록 디테일 미니 맵에서 사용 (리스트에서 디테일 갈 때 전달)
    static func getMapCameraPosition(latitude: Double, longitude: Double) -> MapCameraPosition {
        return MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: latitude,
                    longitude: longitude),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01)))
    }
}
