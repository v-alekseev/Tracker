//
//  TrackerStore.swift
//  Tracker
//
//  Created by Vitaly on 21.08.2023.
//

import Foundation
import UIKit
import CoreData

struct TrackerStoreUpdateIndexes {
    //    struct Move: Hashable {
    //        let oldIndex: Int
    //        let newIndex: Int
    //    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    // let movedIndexes: Set<Move>
}


protocol TrackerStoreDelegate: AnyObject {
    func didUpdate(updateIndexes: TrackerStoreUpdateIndexes)
}

final class TrackerStore: NSObject {
    
    weak var delegate: TrackerStoreDelegate?
    private var trackerCategoryStore = TrackerCategoryStore()
    
    // MARK: - Private Properties
    //
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    //private var movedIndexes: Set<EmojiMixStoreUpdate.Move>?
    
    // MARK: - Initializers
    //
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.trackerName, ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
}

extension TrackerStore: TrackerStoreDataProviderProtocol {
    
    func getTrackers(contains text: String) -> [Tracker] {
//  вариант через fetchedResultsController
        guard let trackers = fetchedResultsController.fetchedObjects else { return [] }
        let filtredTrackers = trackers.filter { $0.trackerName?.contains(text) ?? false }
        return  filtredTrackers.compactMap { Tracker(tracker: $0) }
     
// вариант через базу
//        let request = TrackerCoreData.fetchRequest()
//        request.returnsObjectsAsFaults = false
//        request.predicate = NSPredicate(format: "%K CONTAINS %@",  #keyPath(TrackerCoreData.trackerName), text)
//        do {
//            let trackers = try context.fetch(request)
//            return trackers.compactMap { Tracker(tracker: $0)}
//        } catch {
//            return []
//        }
    }
    
    func getTrackers() -> [Tracker] {
        guard let trackers = fetchedResultsController.fetchedObjects else { return [] }
        return trackers.compactMap { Tracker(tracker: $0)}
    }
    
    func getCompletedTrackersAtDay(onDate: Date) -> [Tracker] {
        var trackers:[TrackerCoreData] = []
        let request = TrackerCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "records.date CONTAINS %@", onDate as CVarArg)
        
        do { trackers = try context.fetch(request) } catch { return [] }
        
        return trackers.compactMap { Tracker(tracker: $0)}
    }
    
    func addTracker(_ tracker: Tracker) -> Bool {
        guard tracker.trackerCategoryName != "",
              let categoryObj = trackerCategoryStore.getCategoryObject(tracker.trackerCategoryName) else { return false }
        
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.set(tracker: tracker)
        trackerCoreData.category = categoryObj
        do { try context.save() } catch { return false }
        return true
    }
    
    func deleteTracker(_ trackerID: UUID) -> Bool {
        guard let trackerObject = getTrackerObject(trackerID) else { return false }
        
        if let records = trackerObject.records {
            for record in records {
                guard let record = record as? TrackerRecordCoreData else { continue }
                context.delete(record)
            }
        }
        context.delete(trackerObject)
        
        do {  try context.save() } catch { return false }
        return true
    }
    
    func getTrackerObject(_ uuid: UUID) -> TrackerCoreData? {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerID), uuid.uuidString)
        var records:[TrackerCoreData] = []
        do { records = try context.fetch(request) } catch { return nil }
        
        return records.first
    }
    
    /// ID менять нельзя,  records измеить нельзя
    func updateTracker(_ tracker: Tracker) -> Bool {
        guard let trackerObject = getTrackerObject(tracker.trackerID) else { return false }
        trackerObject.update(tracker: tracker)
        if let currentTracetCategoryName = trackerObject.category?.categoryName,
           currentTracetCategoryName != tracker.trackerCategoryName,
           !tracker.trackerCategoryName.isEmpty {
            
            guard let categoryObj = trackerCategoryStore.getCategoryObject(tracker.trackerCategoryName) else { return false }
            trackerObject.category = categoryObj
        }
        
        do {  try context.save() } catch { return false }
        
        return true
    }
    /// Возвращает количество трекеров которые можно выполнить в день недели.  dayOfWeekIndex
    func getCountTrackersOnDay(dayOfWeekIndex: String) -> Int {
        let request = TrackerCoreData.fetchRequest()
        request.resultType = .countResultType
        // Select count trackers from trackers where (activedays has weekday) or (activedays is empty)
        request.predicate = NSPredicate(format: "%K CONTAINS %@ OR %K = ''", #keyPath(TrackerCoreData.daysOfWeek), dayOfWeekIndex, #keyPath(TrackerCoreData.daysOfWeek))
        var countRecords = 0
        do { countRecords = try context.count(for: request) } catch { return 0 }
        return countRecords
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        //movedIndexes = Set<EmojiMixStoreUpdate.Move>()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(
            updateIndexes: TrackerStoreUpdateIndexes(
                insertedIndexes: insertedIndexes ?? IndexSet(),
                deletedIndexes: deletedIndexes ?? IndexSet(),
                updatedIndexes: updatedIndexes ?? IndexSet()
                // movedIndexes: movedIndexes  ?? IndexSet()
            )
        )
        
        insertedIndexes = nil
        deletedIndexes = nil
        updatedIndexes = nil
        //movedIndexes = nil
    }
    
    func controller( _ controller: NSFetchedResultsController<NSFetchRequestResult>,
                     didChange anObject: Any,
                     at indexPath: IndexPath?,
                     for type: NSFetchedResultsChangeType,
                     newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes?.insert(indexPath.item)
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            deletedIndexes?.insert(indexPath.item)
        case .update:
            guard let indexPath = indexPath else { fatalError() }
            updatedIndexes?.insert(indexPath.item)
        case .move:
            fallthrough  // remove this line then use movedIndexes
            //            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { fatalError() }
            //            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
        @unknown default:
            fatalError()
        }
    }
}
