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



// TODO: добавить в DataProviderProtocol<Tracker>
extension TrackerStore: TrackerStoreDataProviderProtocol {
    
    func getTrackersByTextInName(text: String) -> [Tracker] {
        let filtredTrackers = fetchedResultsController.fetchedObjects!.filter { ($0.trackerName?.contains(text))! }
        return  filtredTrackers.map { Tracker(tracker: $0) }
    }
    
    func getTrackers() -> [Tracker] {
        return fetchedResultsController.fetchedObjects!.map { Tracker(tracker: $0)}
    }
    
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    //    func getTrackerByIndexPath(at indexPath: IndexPath) -> Tracker {
    //        return Tracker(tracker: fetchedResultsController.object(at: indexPath))
    //    }
    
    func addTracker(_ record: Tracker) -> Bool {
        let trackerCoreData = TrackerCoreData(context: context)
        // fillTrackerCoreData(trackerCoreData: trackerCoreData, tracker: record)
        trackerCoreData.set(tracker: record)
        do { try context.save() } catch { return false }
        return true
    }
    
    //    private func fillTrackerCoreData(trackerCoreData: TrackerCoreData, tracker: Tracker) {
    //        trackerCoreData.trackerID = tracker.trackerID
    //        trackerCoreData.trackerEmodji = tracker.trackerEmodji
    //        trackerCoreData.trackerName = tracker.trackerName
    //        trackerCoreData.trackerColorHEX = UIColorMarshalling(color: tracker.trackerColor).colorHex
    //        trackerCoreData.daysOfWeek = TrackerStore.getActiveDaysString(days: tracker.trackerScheduleDays) // [1,2,3] в строку daysOfWeek  "1,2,3"
    //    }
    
    func deleteTrackerByIndexPath(at indexPath: IndexPath) throws {
        //TODO:
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("TrackerStore controllerWillChangeContent")
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        //movedIndexes = Set<EmojiMixStoreUpdate.Move>()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("TrackerStore controllerDidChangeContent")
        delegate?.didUpdate(
            updateIndexes: TrackerStoreUpdateIndexes(
                insertedIndexes: insertedIndexes!,
                deletedIndexes: deletedIndexes!,
                updatedIndexes: updatedIndexes!
                // movedIndexes: movedIndexes!
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
        //print("TrackerStore controller() newIndexPath = \(newIndexPath), type = \(type), indexPath = \(indexPath)")
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
