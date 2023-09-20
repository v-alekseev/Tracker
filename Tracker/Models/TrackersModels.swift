//
//  TrackersModels.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 12.08.2023.
//

import Foundation
import UIKit

/// TrackerCategory  - содержит имя категории. Связь с трекером через relationship
struct TrackerCategory {
    let categoryName: String    // название категории
}

///  TrackerRecord структурв с информацией о том, что некий трекер был выполнен на некоторую дату;
struct TrackerRecord {
    let trackerID: UUID
    let date: Date
}

/// информация о трекере
struct Tracker {
    let trackerID: UUID
    let trackerName: String
    let trackerEmodji: String
    let trackerColor: UIColor
    let trackerActiveDays: [Int]
    let trackerCategoryName: String
    let isPinned: Bool
    
    /// инициализатор из TrackerCoreData
    init?(tracker: TrackerCoreData) {
        guard let  trackerID = tracker.trackerID,
              let trackerName = tracker.trackerName,
              let trackerEmodji = tracker.trackerEmodji,
              let trackerColorHEX = tracker.trackerColorHEX,
              let daysOfWeek = tracker.daysOfWeek,
              let trackerCategoryName = tracker.category?.categoryName else { return nil }
        
        self.trackerID = trackerID
        self.trackerName = trackerName
        self.trackerEmodji = trackerEmodji
        self.trackerColor =  UIColor(hex: trackerColorHEX) ?? .clear
        self.trackerActiveDays = DaysConverter.getActiveDaysInt(days: daysOfWeek)
        self.trackerCategoryName = trackerCategoryName
        self.isPinned = tracker.isPinned
    }
    /// базовый инициализатор
    init(trackerID: UUID,
         trackerName: String,
         trackerEmodji: String,
         trackerColor: UIColor,
         trackerScheduleDays: [Int],
         trackerCategoryName: String,
         isPinned: Bool) {
        
        self.trackerID = trackerID
        self.trackerName = trackerName
        self.trackerEmodji = trackerEmodji
        self.trackerColor = trackerColor
        self.trackerActiveDays = trackerScheduleDays
        self.trackerCategoryName = trackerCategoryName
        self.isPinned = isPinned
    }
    /// инициализатор копирует tracker в новый с только изменением isPinned. trackerID не меняется
    init(tracker: Tracker, isPinned: Bool) {
        self.trackerID = tracker.trackerID // не меняем
        self.trackerName = tracker.trackerName // не меняем
        self.trackerEmodji = tracker.trackerEmodji // не меняем
        self.trackerColor = tracker.trackerColor // не меняем
        self.trackerActiveDays = tracker.trackerActiveDays // не меняем
        self.trackerCategoryName = tracker.trackerCategoryName // не меняем
        self.isPinned = isPinned
    }
    /// инициализатор копирует tracker в новый с изменением всех параметров кроме trackerID . trackerID не меняется
    init(tracker: Tracker,
         trackerName: String,
         trackerEmodji: String,
         trackerColor: UIColor,
         trackerScheduleDays: [Int],
         trackerCategoryName: String,
         isPinned: Bool) {
        self.trackerID = tracker.trackerID  // не меняем
        self.trackerName = trackerName
        self.trackerEmodji = trackerEmodji
        self.trackerColor = trackerColor
        self.trackerActiveDays = trackerScheduleDays
        self.trackerCategoryName = trackerCategoryName
        self.isPinned = isPinned
    }
    ///  инициализатор пустого трекера.  Поле trackerID будет заполнено сгенерированным UUID
    init() {
        self.trackerID = UUID()
        self.trackerName = ""
        self.trackerEmodji = ""
        self.trackerColor = UIColor.clear
        self.trackerActiveDays = []
        self.trackerCategoryName = ""
        self.isPinned = false
    }
}



