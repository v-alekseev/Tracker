//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Vitaly on 21.08.2023.
//

import Foundation
import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    
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


extension TrackerRecordStore: TrackerRecordStoreDataProviderProtocol {
    
    func isRecordExist(_ record: TrackerRecord) -> Bool {
        print("isRecordExist tracker = \(record.trackerID), date = \(record.date)")
        guard getRecordObject(record) != nil else { return  false}
        print("isRecordExist2 record = \(record)")
        return true
    }
    
    func getRecords() -> [TrackerRecord]? {
        return nil
    }
    
    private func getRecordObject(_ record: TrackerRecord) -> TrackerRecordCoreData? {
        print("getRecordObject tracker = \(record.trackerID)")
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                        #keyPath(TrackerRecordCoreData.trackerID),
                                        record.trackerID as CVarArg,
                                        #keyPath(TrackerRecordCoreData.date),
                                        record.date as CVarArg)
        
        var records:[TrackerRecordCoreData] = []
        do { records = try context.fetch(request) } catch { return nil }
        
        return records.first
    }
    
    func addRecord(_ record: TrackerRecord) -> Bool {
        print("addRecord \(record)")
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        
        trackerRecordCoreData.date = record.date
        trackerRecordCoreData.trackerID = record.trackerID
        do { try context.save() } catch { return false }
        return true
    }
    
    func deleteRecord(_ record: TrackerRecord) -> Bool {
        print("deleteRecord 1")
        guard let object = getRecordObject(record) else { return false }
        
        print("deleteRecord 2")
        context.delete(object)
        return true
    }
    
    
    private func getRecordObjects(_ record: TrackerRecord) -> NSManagedObject? {
        print("getRecordObjectS tracker = \(record.trackerID)")
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(TrackerRecordCoreData.trackerID),
                                        record.trackerID as CVarArg)
        
        var records:[TrackerRecordCoreData] = []
        do { records = try context.fetch(request) } catch { return nil }
        
        // Распечатываем результат.
        print("getRecordObjectS request.predicate = \(request.predicate.debugDescription)")
        print("getRecordObjectS record.first = \(record)")
        
        return records.first
    }
    
    
    func getTrackerComletedDays(trackerID: UUID) -> Int {
        print("getTrackerComletedDays tracker = \(trackerID)")
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        // Нам интересно лишь количество
        request.resultType = .countResultType
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), trackerID as CVarArg)
        
        var countRecords = 0
        do { countRecords = try context.count(for: request) } catch { return 0 }
        
        print("getTrackerComletedDays count = \(countRecords)")
        return countRecords
    }
    
}
