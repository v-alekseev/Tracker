//
//  Date+extension.swift
//  Tracker
//
//  Created by Vitaly on 15.09.2023.
//

import Foundation

extension Date{
    func startOfDay() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: self)
        
        return dateFormatter.date(from: dateString)
        
       // Locale.current.calendar.startOfDay(for: self)
    }
}
