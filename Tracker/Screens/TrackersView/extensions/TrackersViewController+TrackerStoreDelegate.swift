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
        guard let collectionView = collectionView else { return }
        visibleTrackers = getVisibleTrackers(trackers: trackerStore.getTrackers())
        
        showLogo(visibleTrackers.count == 0)
        
        collectionView.reloadData()
    }
}
