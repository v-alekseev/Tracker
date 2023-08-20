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
        print("searchController text = \(searchText)")
        
        if(searchText == "") {
            showLogo(false)
            visibleTrackers = createVisibleTrackers(trackers: trackers)
            collectionView.reloadData()
            return
        }
    
        visibleTrackers = createVisibleTrackers(trackers: searchTrackers(text: searchText))
        if visibleTrackers.count == 0 {
            // отобразить заглушку
            showLogo(true, whichLogo: .searchNothing)
            return
        }
        
        showLogo(false)
        collectionView.reloadData()
    }
}
