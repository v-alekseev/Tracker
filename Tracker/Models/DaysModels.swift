//
//  Days.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 12.08.2023.
//

import Foundation

enum DaysOfWeek: Int {
    case Monday = 2, Tuesday = 3, Wednesday = 4, Thursday = 5, Friday = 6, Saturday = 7, Sunday=1
}

struct  Day {
    let dayName: String
    var dayValue: Bool
    let shortDatName: String
    let dayOfWeek: DaysOfWeek
}

class ScheduleDays {
    
    var weekDays: [Day] = [
        Day(dayName: "Понедельник", dayValue: false, shortDatName: "Пн", dayOfWeek: DaysOfWeek.Monday),
        Day(dayName: "Вторник", dayValue: false, shortDatName: "Вт", dayOfWeek: DaysOfWeek.Tuesday),
        Day(dayName: "Среда", dayValue: false, shortDatName: "Ср", dayOfWeek: DaysOfWeek.Wednesday),
        Day(dayName: "Четверг", dayValue: false, shortDatName: "Чт", dayOfWeek: DaysOfWeek.Thursday),
        Day(dayName: "Пятница", dayValue: false, shortDatName: "Пт", dayOfWeek: DaysOfWeek.Friday),
        Day(dayName: "Суббота", dayValue: false, shortDatName: "Сб", dayOfWeek: DaysOfWeek.Saturday),
        Day(dayName: "Воскресенье", dayValue: false, shortDatName: "Вс", dayOfWeek: DaysOfWeek.Sunday)
    ]

    //MARK: public functions
    // возвращает список дней недели в которые активирован трекер
    func getActiveDayInScheduleDays() -> [Int] {
        var activeDays: [Int] = []
        
        for day in weekDays {
            if day.dayValue {
                activeDays.append(day.dayOfWeek.rawValue)
            }
        }
        
        return activeDays
    }
    
    // добавляет перенос строки перед строкой расписания.
    func getScheduleAsTextWithNewLine() -> String {
        let desription = getScheduleAsText()
        
        return  desription == "" ? desription : ("\n" + desription)
    }
    
    // возвращает рассписание ативности трекера в виде строки  "Вт, Чт"
    private func getScheduleAsText() -> String {
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
            // удаляем последние 2 символа ", "
            description.removeLast(2)
        }
        
        return description
    }
}


