//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Vitaly on 21.08.2023.
//

import Foundation
import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    
    // MARK: - Private Properties
    //
    private let context: NSManagedObjectContext

    // MARK: - Initializers
    //
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
    }
}


extension TrackerCategoryStore: TrackerCategoryStoreDataProviderProtocol{
    
    func getTrackerCategory(trackerID: UUID) -> String? {
        print("getTrackerCategory trackerI = \(trackerID)")
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format:  "%K CONTAINS[n] %@",
                                        #keyPath(TrackerCategoryCoreData.trackerIDs),
                                        trackerID.uuidString)
        
        var records: [TrackerCategoryCoreData] = []
        do { records = try context.fetch(request) } catch { return nil }
        
        //print("getTrackerCategory category.first = \(records.first)")
        return records.first?.categoryName
    }
    
    func getCategoriesCount() -> Int {
        print("getCategoriesCount")
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.resultType = .countResultType
        
        var countRecords = 0
        do { countRecords = try context.count(for: request) } catch { return 0 }
        
        return countRecords
    }
    
    private func getRecordObject(_ category: String) -> TrackerCategoryCoreData? {
        print("TrackerCategoryStore getRecordObject")
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(TrackerCategoryCoreData.categoryName),
                                        category)
        
        var records:[TrackerCategoryCoreData] = []
        do { records = try context.fetch(request) } catch { return nil }
        //print("TrackerCategoryStore getRecordObject = \(records.first?.categoryName)")
        return records.first
    }
    
    func updateCategory(_ category: TrackerCategory) -> Bool  {
        print("addCategory \(category)")
        guard let categoryObject = getRecordObject(category.categoryName) else { return false }
        
        categoryObject.trackerIDs = category.trackerIDsString
        do { try context.save() } catch { return false }
        return true
    }
    
    func addCategory(_ category: TrackerCategory) -> Bool {
        print("addCategory \(category)")
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        
        trackerCategoryCoreData.categoryName = category.categoryName
        trackerCategoryCoreData.trackerIDs = category.trackerIDsString
        
        do { try context.save() } catch { return false }
        return true
    }
    
    func getCategory(_ category: String) -> TrackerCategory? {
        
        print("getCategory category = \(category)")
        guard let categoryObject = getRecordObject(category) else { return nil}
        
        return TrackerCategory(
            trackerIDs: TrackerCategory.trackerIDsFromString(udids: (categoryObject.trackerIDs)!),
            categoryName: (categoryObject.categoryName)!)
    }
    
    func getCategories() -> [TrackerCategory]? {
        // getRecordObjects(record)
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        
        var records:[TrackerCategoryCoreData] = []
        do { records = try context.fetch(request) } catch { return nil }
        
        print("getCategory category.first = \(records)")
        return records.map {TrackerCategory(
            trackerIDs: TrackerCategory.trackerIDsFromString(udids: ($0.trackerIDs)!),
            categoryName: $0.categoryName!)}
    }
    
    func deleteCategory(_ categoryName: String) -> Bool {
        print("deleteCategory \(categoryName)")
        guard let categoryObject = getRecordObject(categoryName) else { return false}
        
        context.delete(categoryObject)
        return true
    }
    
    
}
