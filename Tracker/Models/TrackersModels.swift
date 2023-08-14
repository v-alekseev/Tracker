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
    let trackerIDs: [UUID]     // массив ID трекеров у которых эта директория
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
    let trackerScheduleDays: [Day]
}
