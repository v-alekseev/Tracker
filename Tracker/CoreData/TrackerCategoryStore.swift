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
    
    
    weak var delegate: TrackerCategoryStoreDelegateProtocol?
    
    // MARK: - Private Properties
    //
    private let context: NSManagedObjectContext
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    
    
    // MARK: - Initializers
    //
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.categoryName, ascending: true)
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


extension TrackerCategoryStore: TrackerCategoryStoreDataProviderProtocol{
    
    func getCategoriesCount() -> Int {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.resultType = .countResultType
        
        var countRecords = 0
        do { countRecords = try context.count(for: request) } catch { return 0 }
        
        return countRecords
    }
    
    func updateCategory(category: TrackerCategory, newCategory: TrackerCategory) -> Bool  {
        
        guard let categoryObject = getCategoryObject(category.categoryName) else { return false }
        
        categoryObject.categoryName = newCategory.categoryName
        do { try context.save() } catch { return false }
        // delegate?.didUpdate()
        return true
    }
    
    func addCategory(_ category: TrackerCategory) -> Bool {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        
        trackerCategoryCoreData.categoryName = category.categoryName
        
        do { try context.save() } catch { return false }
        
        // delegate?.didUpdate()
        return true
    }
    
    func getCategory(_ category: String) -> TrackerCategory? {
        guard let categoryObject = getCategoryObject(category),
              let categoryName = categoryObject.categoryName else { return nil}
        
        return TrackerCategory(categoryName: categoryName)
    }
    
    func getCategories() -> [TrackerCategory]? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: "categoryName", ascending: true)]
        
        var records:[TrackerCategoryCoreData] = []
        do { records = try context.fetch(request) } catch { return nil }
        
        return records.compactMap {
            guard let categoryName = $0.categoryName else { return nil}
            
            return TrackerCategory(categoryName: categoryName)
        }
    }
    
    func deleteCategory(_ categoryName: String) -> Bool {
        guard let categoryObject = getCategoryObject(categoryName) else { return false}
        if (categoryObject.tracker?.count ?? 0) > 0 {
            return false
        }
        context.delete(categoryObject)
        do { try context.save() } catch { return false }
        
        return true
    }
    
    func getCategoryObject(_ category: String) -> TrackerCategoryCoreData? {
        
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.categoryName), category)
        
        var records:[TrackerCategoryCoreData] = []
        do { records = try context.fetch(request) } catch { return nil }
        
        return records.first
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controller( _ controller: NSFetchedResultsController<NSFetchRequestResult>,
                     didChange anObject: Any,
                     at indexPath: IndexPath?,
                     for type: NSFetchedResultsChangeType,
                     newIndexPath: IndexPath?) {
        
        self.delegate?.didUpdate()
        
    }
}

