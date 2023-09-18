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
    private let trackerStrore = TrackerStore()
    
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
        guard getRecordObject(record) != nil else { return  false}
        return true
    }
    
    func addRecord(_ record: TrackerRecord) -> Bool {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        
        let trackerObject = trackerStrore.getTrackerObject(record.trackerID)
        trackerRecordCoreData.date = record.date
        trackerRecordCoreData.trackerID = record.trackerID
        trackerRecordCoreData.tracker = trackerObject
        
        do { try context.save() } catch { return false }
        return true
    }
    
    func deleteRecord(_ record: TrackerRecord) -> Bool {
        guard let object = getRecordObject(record) else { return false }
        context.delete(object)
        do { try context.save() } catch { return false }
        return true
    }
    
    func getTrackerComletedDays(trackerID: UUID) -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        // Нам интересно лишь количество
        request.resultType = .countResultType
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), trackerID as CVarArg)
        
        var countRecords = 0
        do { countRecords = try context.count(for: request) } catch { return 0 }
        
        return countRecords
    }
    
    
    func getRecords() -> [TrackerRecord]? {
        let request = TrackerRecordCoreData.fetchRequest() //NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        //request.sortDescriptors = [NSSortDescriptor(key: "categoryName", ascending: true)]
        
        var records:[TrackerRecordCoreData] = []
        do { records = try context.fetch(request) } catch { return nil }
        
        return records.compactMap {
            guard let trackerID = $0.trackerID,
                  let date = $0.date else { return nil}
            return TrackerRecord(trackerID: trackerID, date: date)
        }
    }
    
    func getRecordsCount() -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        // Нам интересно лишь количество
        request.resultType = .countResultType

        var countRecords = 0
        do { countRecords = try context.count(for: request) } catch { return 0 }
        
        return countRecords
    }
    
    //MARK: - private methods
    //  Возвращвет запись о выполнении трекра для конкретной даты
    private func getRecordObject(_ record: TrackerRecord) -> TrackerRecordCoreData? {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                        #keyPath(TrackerRecordCoreData.trackerID), record.trackerID as CVarArg,
                                        #keyPath(TrackerRecordCoreData.date), record.date as CVarArg)
        
        var records:[TrackerRecordCoreData] = []
        do { records = try context.fetch(request) } catch { return nil }
        //print("getRecordObject tracker = \(records.first?.tracker), trackerID =  \(records.first?.trackerID), date =  \(records.first?.date),")
        return records.first
    }
    
    
}
