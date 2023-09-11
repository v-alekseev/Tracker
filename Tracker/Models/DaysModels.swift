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
   // let dayName: String
    var dayValue: Bool
   // let shortDatName: String
    let dayOfWeek: DaysOfWeek
}

class ScheduleDays {
    var weekDays: [Day] = [
        Day(dayValue: false, dayOfWeek: DaysOfWeek.Monday),
        Day(dayValue: false, dayOfWeek: DaysOfWeek.Tuesday),
        Day(dayValue: false, dayOfWeek: DaysOfWeek.Wednesday),
        Day(dayValue: false, dayOfWeek: DaysOfWeek.Thursday),
        Day(dayValue: false, dayOfWeek: DaysOfWeek.Friday),
        Day(dayValue: false, dayOfWeek: DaysOfWeek.Saturday),
        Day(dayValue: false, dayOfWeek: DaysOfWeek.Sunday)
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
                description += Locale.current.calendar.shortWeekdaySymbols[day.dayOfWeek.rawValue-1] + ", "
            }
        }
        

        if countDays == 7 {
            return L10n.Sheduler.allDays //"Каждый день"  //"sheduler.all_days" 
        }
        
        if description.isEmpty == false {
            // удаляем последние 2 символа ", "
            description.removeLast(2)
        }
        
        return description
    }
}


