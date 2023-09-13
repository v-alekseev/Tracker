//
//  DataProviderProtocol.swift
//  Tracker
//
//  Created by Vitaly on 21.08.2023.
//

import Foundation

// TODO: Переделать на протокол BaseDataProviderProtocol  c Generic <Тип записи, тип ключа для поиска>
protocol TrackerStoreDataProviderProtocol: AnyObject {
    func addTracker(_ record: Tracker) -> Bool
    func getTrackers() -> [Tracker]
    func getTrackersByTextInName(text: String) -> [Tracker]
    func deleteTracker(_ trackerID: UUID) -> Bool
}

protocol TrackerRecordStoreDataProviderProtocol: AnyObject {
    func getTrackerComletedDays(trackerID: UUID) -> Int
    func isRecordExist(_ record: TrackerRecord) -> Bool
    
    func addRecord(_ record: TrackerRecord) -> Bool
    func getRecords() -> [TrackerRecord]?
    func deleteRecord(_ record: TrackerRecord) -> Bool
}

protocol TrackerCategoryStoreDataProviderProtocol: AnyObject {
    func getCategoriesCount() -> Int
    
    func addCategory(_ category: TrackerCategory) -> Bool
    func updateCategory(category: TrackerCategory, newCategory: TrackerCategory) -> Bool
    func getCategory(_ category: String) -> TrackerCategory?
    func getCategories() -> [TrackerCategory]?
    func deleteCategory(_ category: String) -> Bool
}

protocol TrackerCategoryStoreDelegateProtocol: AnyObject {
    func didUpdate()
}
