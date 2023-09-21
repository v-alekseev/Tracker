//
//  StatisticViewPresenter.swift
//  Tracker
//
//  Created by Vitaly on 18.09.2023.
//

import Foundation


final class StatisticViewPresenter {
    
    weak var statisticViewController: StatisticViewController?
    
    private var completedTrackersCount: Int = 0 {
        didSet {
            statisticViewController?.updateStatisticPraram(param: .completedTrackersCount, value: String(completedTrackersCount))
            didParamChanged()
        }
    }
    private var completedTrackersCountAverage: Float = 0 {
        didSet {
            statisticViewController?.updateStatisticPraram(param: .completedTrackersCountAverage, value: String(completedTrackersCountAverage))
            didParamChanged()
        }
    }
    private var idealDaysCount: Int = 0 {
        didSet {
            statisticViewController?.updateStatisticPraram(param: .idealDaysCount, value: String(idealDaysCount))
            didParamChanged()
        }
    }
    private var bestSeries: Int = 0 {
        didSet {
            statisticViewController?.updateStatisticPraram(param: .bestPeriod, value: String(bestSeries))
            didParamChanged()
        }
    }
    
    
    private func didParamChanged() {
        var showLogo = false
        if completedTrackersCount == 0 &&
            completedTrackersCountAverage == 0 &&
            idealDaysCount == 0 &&
            bestSeries == 0 {
            showLogo =  true
        }
        
        statisticViewController?.showLogo(showLogo)
    }
    
    private let trackerRecordStore = TrackerRecordStore()
    private let trackerStore = TrackerStore()
    
    func updateStatistic() {
        completedTrackersCount = getCompletedTrackersCount()
        completedTrackersCountAverage = getCompletedTrackersCountAverage()
        idealDaysCount = getIdealDaysCount()
        bestSeries = getBestSeries()
    }
    
    /// «Трекеров завершено» считает общее количество выполненных привычек за все время;
    func getCompletedTrackersCount() -> Int {
        let countCompletedTrackers = trackerRecordStore.getRecordsCount()
        return countCompletedTrackers
    }
    /// «Среднее значение» считает среднее количество привычек, выполненных за 1 день.
    func getCompletedTrackersCountAverage() -> Float {
        guard let allRecords = trackerRecordStore.getRecords() else { return 0 }
        
        let recordsGrouppedByDay = Dictionary(grouping: allRecords, by: {$0.date})
        guard recordsGrouppedByDay.count != 0 else { return 0 }
        
        let average = Float(Float(allRecords.count)/Float(recordsGrouppedByDay.count))
        return Float(round(average*1000)/1000)
    }
    /// «Идеальные дни» считает дни, когда были выполнены все запланированные привычки;
    func getIdealDaysCount() -> Int {
        guard let allRecords = trackerRecordStore.getRecords() else { return 0 }
        let recordsGrouppedByDay = Dictionary(grouping: allRecords, by: {$0.date})
        
        var countIdealDays = 0
        for date in recordsGrouppedByDay.keys {
            let dayOfWeekIndex = Locale.current.calendar.component(.weekday, from: date)  // dayOfWeek  = 1..7  // 1 - sunday
            // количество трекеров в этом дне
            let countTrackers = trackerStore.getCountTrackersOnDay(dayOfWeekIndex: String(dayOfWeekIndex))
            // количество выполненных трекоров в этом дне
            guard let completedTrackers = recordsGrouppedByDay[date] else { continue }
            if(countTrackers == completedTrackers.count) {
                countIdealDays += 1
            }
        }
        
        return countIdealDays
    }
    /// «Лучший период» считает максимальное количество дней без перерыва по всем трекерам;
    func getBestSeries() -> Int {
        guard let allRecords = trackerRecordStore.getRecords() else { return 0 }
        let recordsGrouppedByTracker = Dictionary(grouping: allRecords, by: {$0.trackerID})
        
        var series: [Int] = []
        
        for trackerID in recordsGrouppedByTracker.keys {
            guard let records = recordsGrouppedByTracker[trackerID] else { continue }
            let dates = records.map ({$0.date}).sorted()
            
            guard let minDate =  dates.min(),
                  var prevDate = Calendar.current.date(byAdding: .day, value: -5, to: minDate)  else { continue } // prevDate в начале цикла не должна быть перед минимальной даты среди выполненных трекеров. Сместили ее на 5 дней назад
            
            var trackerSeries = 1
            for date in dates {
                if date == Calendar.current.date(byAdding: .day, value: 1, to: prevDate) {
                    trackerSeries += 1
                } else {
                    trackerSeries = 1  // 1 т.к. у нас перебор по выполненным трекерам, а значит минимальное значение серии 1
                }
                series.append(trackerSeries)
                prevDate = date
            }
        }
        return series.max() ?? 0
    }
}
