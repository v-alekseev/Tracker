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
    // конвертер из строки "1,2,3" в массив [1,2,3]
    static func getActiveDaysInt(days: String) -> [Int] {
        return days.split(separator: ",").map { Int($0)! }
    }
    
    // конвертер из массива [1,2,3] в строку  "1,2,3"
    static func getActiveDaysString(days: [Int] ) -> String {
        let activeDayNums:[String] = days.map { String($0) }
        return activeDayNums.joined(separator: ",")
    }
}
