//
//  TrackersModels.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 12.08.2023.
//

import Foundation
import UIKit

// TrackerCategory  - содержит имя категории и список трекеров с этой категориией
struct TrackerCategory {
    let categoryName: String    // название категории
}

//  TrackerRecord структурв с информацией о том, что некий трекер был выполнен на некоторую дату;
struct TrackerRecord {
    let trackerID: UUID
    let date: Date
}

// информация о трекере
struct Tracker {
    let trackerID: UUID
    let trackerName: String
    let trackerEmodji: String
    let trackerColor: UIColor
    let trackerActiveDays: [Int]
    let trackerCategoryName: String
    
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
        self.trackerColor = UIColorMarshalling(colorHex: trackerColorHEX).color
        self.trackerActiveDays = DaysConverter.getActiveDaysInt(days: daysOfWeek)
        self.trackerCategoryName = trackerCategoryName
    }
    
    init(trackerID: UUID,
         trackerName: String,
         trackerEmodji: String,
         trackerColor: UIColor,
         trackerScheduleDays: [Int],
         trackerCategoryName: String) {
        
        self.trackerID = trackerID
        self.trackerName = trackerName
        self.trackerEmodji = trackerEmodji
        self.trackerColor = trackerColor
        self.trackerActiveDays = trackerScheduleDays
        self.trackerCategoryName = trackerCategoryName
    }
    
}



