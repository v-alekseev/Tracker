//
//  DaysConverter.swift
//  Tracker
//
//  Created by Vitaly on 23.08.2023.
//

import Foundation
import UIKit

final class DaysConverter {
    //MARK: Static functions
    // daysOfWeek = "1,2,3"
    static func getActiveDaysInt(days: String) -> [Int] {
        return days.split(separator: ",").map { Int($0)! }
    }
    
    // конвертер из массива tracker.trackerScheduleDays [1,2,3] в строку daysOfWeek  "1,2,3"
    static func getActiveDaysString(days: [Int] ) -> String {
        //let activeDays = days.filter {$0.dayValue == true}
        let activeDayNums:[String] = days.map { String($0) }
        return activeDayNums.joined(separator: ",")
    }
}
