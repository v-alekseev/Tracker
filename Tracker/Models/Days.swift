//
//  Days.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 12.08.2023.
//

import Foundation

//enum DaysOfWeek: Int {
//    case Monday = 0, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
//}

struct  Day {
    var dayName: String
    var dayValue: Bool
    var shortDatName: String
}

class ScheduleDays {
//    var Days: [DaysOfWeek: Bool] = [
//        DaysOfWeek.Monday: false,
//        DaysOfWeek.Tuesday: false,
//        DaysOfWeek.Wednesday: false,
//        DaysOfWeek.Thursday: false,
//        DaysOfWeek.Friday: false,
//        DaysOfWeek.Saturday: false,
//        DaysOfWeek.Sunday: false
//    ]
    
     var weekDays: [Day] = [
        Day(dayName: "Понедельник", dayValue: false, shortDatName: "Пн"),
        Day(dayName: "Вторник", dayValue: false, shortDatName: "Вт"),
        Day(dayName: "Среда", dayValue: false, shortDatName: "Ср"),
        Day(dayName: "Четверг", dayValue: false, shortDatName: "Чт"),
        Day(dayName: "Пятница", dayValue: false, shortDatName: "Пт"),
        Day(dayName: "Суббота", dayValue: false, shortDatName: "Сб"),
        Day(dayName: "Воскресенье", dayValue: false, shortDatName: "Вс")
    ]
    
    func getDescription() -> String{
        var countDays: Int = 0
        var description: String = ""
        
        for day in weekDays {
            if day.dayValue {
                countDays += 1
                description += day.shortDatName + ", "
            }
        }
        if countDays == 7 {
            return "Каждый день"
        }
        
        if description.isEmpty == false {
            // удаляем последние символы ", "
            description.removeLast()
            description.removeLast()
        }
        
        return description
    }
    
    func getDescriptionFirstNewLine() -> String {
        let desription = getDescription()
        
        return  desription == "" ? desription : ("\n" + desription)
    }
}


