//
//  TrackersViewController+TrackerStoreDelegate.swift
//  Tracker
//
//  Created by Vitaly on 21.08.2023.
//

import Foundation
import UIKit


extension TrackersViewController: TrackerStoreDelegate {
    
    func didUpdate(updateIndexes: TrackerStoreUpdateIndexes) {
        print("TrackersViewController didUpdate()")
        // update UI Collection
    
        guard let collectionView = collectionView else { return }
        //var visibleTrackersCountOld = visibleTrackers.count
        visibleTrackers = getVisibleTrackers(trackers: trackerStore.getTrackers())// trackerStore.getObjects()
        
        showLogo(visibleTrackers.count == 0)
        
        collectionView.reloadData()
        // Код ниже вызывает ошщибку из-за visibleTrackers и CoreData  из-за индексов которые расчитываются в NSFetchedResultsController
        
        //            collectionView.performBatchUpdates {
        //                let insertedIndexPaths = updateIndexes.insertedIndexes.map { IndexPath(item: $0, section: 0) }
        //                let deletedIndexPaths = updateIndexes.deletedIndexes.map { IndexPath(item: $0, section: 0) }
        //                let updatedIndexPaths = updateIndexes.updatedIndexes.map { IndexPath(item: $0, section: 0) }
        //                collectionView.insertItems(at: insertedIndexPaths)
        //                collectionView.deleteItems(at: deletedIndexPaths)
        //                collectionView.reloadItems(at: updatedIndexPaths)
        //                //            for move in update.movedIndexes {
        //                //                collectionView.moveItem(
        //                //                    at: IndexPath(item: move.oldIndex, section: 0),
        //                //                    to: IndexPath(item: move.newIndex, section: 0)
        //                //                )
        //                //            }
        //            }
        
    }
}
