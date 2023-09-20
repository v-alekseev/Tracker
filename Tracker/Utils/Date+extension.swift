//
//  Date+extension.swift
//  Tracker
//
//  Created by Vitaly on 15.09.2023.
//

import Foundation

extension Date{
    func startOfDay() -> Date? {
        return Locale.current.calendar.startOfDay(for: self) 
    }
    
    static func getDateFromString(isoDate: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from:isoDate)
    }
}
