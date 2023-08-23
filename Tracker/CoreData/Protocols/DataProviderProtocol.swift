//
//  DataProviderProtocol.swift
//  Tracker
//
//  Created by Vitaly on 21.08.2023.
//

import Foundation
// TODO: Переделать на протокол BaseDataProviderProtocol  c Generic <Тип записи, тип ключа для поиска>
protocol TrackerStoreDataProviderProtocol {
    
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    
   // func getTrackerByIndexPath(at: IndexPath) -> Tracker
    func deleteTrackerByIndexPath(at indexPath: IndexPath) throws
  
    func addTracker(_ record: Tracker) -> Bool
    //func getTracker(id: Any) -> Tracker?
    func getTrackers() -> [Tracker]
    func getTrackersByTextInName(text: String) -> [Tracker]
    //func deleteTracker(_ trackerID: UUID) throws
}

protocol TrackerRecordStoreDataProviderProtocol {
    func getTrackerComletedDays(trackerID: UUID) -> Int
    func isRecordExist(_ record: TrackerRecord) -> Bool
    
    func addRecord(_ record: TrackerRecord) -> Bool
    //func getRecords(_ id: Any) -> TrackerRecord?
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
