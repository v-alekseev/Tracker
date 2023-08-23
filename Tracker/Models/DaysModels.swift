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
    

    
    init() {
    }
    
    init(activeDays: String) {
        setActiveDaysOfWeek(daysOfWeek: activeDays)
    }

    // daysOfWeek = "1,2,3"
    func setActiveDaysOfWeek(daysOfWeek: String) {
        let days = daysOfWeek.split(separator: ",").map {DaysOfWeek(rawValue: Int($0)!)}
        for day in days {
            let activeDayIndex = weekDays.firstIndex {$0.dayOfWeek == day}
            guard let activeDayIndex = activeDayIndex else { continue }
            weekDays[activeDayIndex].dayValue = true
        }
    }
    
    // если это нерегулярное событие (все дни неактивны), возвращаем true  Кстати это = привычка без рассписания
    func isUnregularEvent() -> Bool {
        for day in weekDays {
            if day.dayValue {
                return false
            }
        }
        
        return true
    }
    
    // возвращает список дней недели в которые активирован трекер
    func getActiveDayInScheduleDays() -> [Day] {
        var activeDays: [Day] = []
        
        for day in weekDays {
            if day.dayValue {
                activeDays.append(day)
            }
        }
        return activeDays
    }
    
    // возвращает рассписание ативности трекера в виде строки  "Вт, Чт"
    func getScheduleAsText() -> String {
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
    
    // добавляет перенос строки перед строкой расписания.
    func getScheduleAsTextWithNewLine() -> String {
        let desription = getScheduleAsText()
        
        return  desription == "" ? desription : ("\n" + desription)
    }
    
    // TODO: в tracker.trackerScheduleDays передавать класс ScheduleDays и в него уже перенести все конвертации
    // конвертер из массива tracker.trackerScheduleDays [1,2,3] в строку daysOfWeek  "1,2,3"
    static func getActiveDaysString(days: [Day] ) -> String {
        let activeDays = days.filter {$0.dayValue == true}
        let activeDayNums:[String] = activeDays.map { String($0.dayOfWeek.rawValue) }
        return activeDayNums.joined(separator: ",")
    }
    
}


