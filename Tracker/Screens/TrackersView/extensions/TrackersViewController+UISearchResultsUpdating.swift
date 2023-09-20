//
//  TrackersViewController+UISearchControllerDelegate.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 14.08.2023.
//

import Foundation
import UIKit

extension TrackersViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text,
              let collectionView = self.collectionView  else { return }
        
        if(searchText == "") {
            showLogo(false)
            visibleTrackers = getVisibleTrackers(trackers: trackerStore.getTrackers())
            collectionView.reloadData()
            return
        }
        
        visibleTrackers = getVisibleTrackers(trackers: trackerStore.getTrackersByTextInName(text: searchText))
        
        if visibleTrackers.count == 0 {
            // отобразить заглушку
            showLogo(true, whichLogo: .searchNothing)
            return
        }
        
        showLogo(false)
        collectionView.reloadData()
    }
}
