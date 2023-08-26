//
//  DataProviderProtocol.swift
//  Tracker
//
//  Created by Vitaly on 21.08.2023.
//

import Foundation

// TODO: Переделать на протокол BaseDataProviderProtocol  c Generic <Тип записи, тип ключа для поиска>
protocol TrackerStoreDataProviderProtocol {
//    var numberOfSections: Int { get }
//    func numberOfRowsInSection(_ section: Int) -> Int
    
    func addTracker(_ record: Tracker) -> Bool
    func getTrackers() -> [Tracker]
    func getTrackersByTextInName(text: String) -> [Tracker]
}

protocol TrackerRecordStoreDataProviderProtocol {
    func getTrackerComletedDays(trackerID: UUID) -> Int
    func isRecordExist(_ record: TrackerRecord) -> Bool
    
    func addRecord(_ record: TrackerRecord) -> Bool
    func getRecords() -> [TrackerRecord]?
    func deleteRecord(_ record: TrackerRecord) -> Bool
}

protocol TrackerCategoryStoreDataProviderProtocol {
    func getTrackerCategory(trackerID: UUID) -> String?
    func getCategoriesCount() -> Int
    
    func addCategory(_ category: TrackerCategory) -> Bool
    func updateCategory(_ category: TrackerCategory) -> Bool
    func getCategory(_ category: String) -> TrackerCategory?
    func getCategories() -> [TrackerCategory]?
    func deleteCategory(_ category: String) -> Bool

}
