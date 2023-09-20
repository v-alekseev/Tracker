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
        self.trackerEmodji = tracker.trackerEmodji
        self.trackerName = tracker.trackerName
        self.trackerColorHEX = tracker.trackerColor.toHex
        self.daysOfWeek = DaysConverter.getActiveDaysString(days: tracker.trackerActiveDays)
        self.isPinned = tracker.isPinned
    }
    func update( tracker: Tracker  ) {
        self.trackerEmodji = tracker.trackerEmodji
        self.trackerName = tracker.trackerName
        self.trackerColorHEX = tracker.trackerColor.toHex
        self.daysOfWeek = DaysConverter.getActiveDaysString(days: tracker.trackerActiveDays)
        self.isPinned = tracker.isPinned
    }
}


