//
//  Days.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 12.08.2023.
//

import Foundation


struct  Day {
    var dayValue: Bool = false
    var dayIndex: Int // index ( 0 .. 6) в массивах типа calendar.shortWeekdaySymbol
}

class ScheduleDays {
    
    var weekDays: [Day] = (0..<7).map { Day(dayIndex: weekDaysLocale[$0]) }
    
    private var activeWeekDays: [Day] {
        get {
            weekDays.filter { $0.dayValue }
        }
    }

    static let weekDaysLocale: [Int] = {
                let firstDay = Locale.current.calendar.firstWeekday
                return (firstDay..<firstDay+7).map { $0 == 8 ? 0 : $0-1}
    }()
    
    
    //MARK: public functions
    // возвращает список дней недели в которые активирован трекер
    func getActiveDayInScheduleDays() -> [Int] {
        return activeWeekDays.map { $0.dayIndex+1 }  // +1 т.к. номера дней идут от 1 до 7 (напримкр тут calendar.firstWeekday)
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

        for day in activeWeekDays {
                countDays += 1
                description += Locale.current.calendar.shortWeekdaySymbols[day.dayIndex] + ", "
        }
        
        if countDays == 7 {
            return L10n.Sheduler.allDays //"Каждый день"
        }
        
        if description.isEmpty == false {
            // удаляем последние 2 символа ", "
            description.removeLast(2)
        }
        
        return description
    }
}


