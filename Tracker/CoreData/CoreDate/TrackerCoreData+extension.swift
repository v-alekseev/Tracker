//
//  TrackerCoreData+extension.swift
//  Tracker
//
//  Created by Vitaly on 23.08.2023.
//

import Foundation

extension TrackerCoreData {
    func set( tracker: Tracker ) {
        self.trackerID = tracker.trackerID
        self.trackerID = tracker.trackerID
        self.trackerEmodji = tracker.trackerEmodji
        self.trackerName = tracker.trackerName
        self.trackerColorHEX = UIColorMarshalling(color: tracker.trackerColor).colorHex
        self.daysOfWeek = ScheduleDays.getActiveDaysString(days: tracker.trackerScheduleDays)
    }
}
