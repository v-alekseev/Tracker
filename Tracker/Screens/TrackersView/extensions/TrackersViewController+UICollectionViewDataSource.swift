//
//  TrackersViewController+UICollectionViewDataSource.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 14.08.2023.
//

import Foundation
import UIKit

extension TrackersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let categoryName = visibleTrackers.getKeyByIndex(index: section)
        let trackers = visibleTrackers[categoryName] ?? []
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? TrackerCollectionViewCell) ?? TrackerCollectionViewCell()
        
        let categoryName = visibleTrackers.getKeyByIndex(index: indexPath.section)
        guard let trackers = visibleTrackers[categoryName] else { return TrackerCollectionViewCell() }
        
        let tracker = trackers[indexPath.row]
        cell.tracker = tracker
        // TODO: убрать строки типа cell.trackerID = tracker.trackerID т.к. теперь есть cell.tracker = tracker
        cell.trackersViewController = self
        cell.trackerID = tracker.trackerID
        cell.titleLabel?.text = tracker.trackerName
        cell.setDaysCompleted(daysCompleted: getComletedDays(trackerID: tracker.trackerID))
        cell.emojiLabel?.text = tracker.trackerEmodji
        cell.cardTrackerView?.backgroundColor = tracker.trackerColor
        cell.completeButton?.tintColor = tracker.trackerColor
        cell.isPinned = tracker.isPinned
        
        var imageCellButtom = imageTrackerCellPlus
        if let currentDate = currentDate {
            imageCellButtom = isTrackerCompleted(trackerID: tracker.trackerID, date: currentDate) ? imageTrackerCellCompleted : imageTrackerCellPlus
        }
        
        cell.completeButton?.setImage(imageCellButtom, for: .normal)
        
        return cell
    }
    
    func numberOfSections(in: UICollectionView) -> Int {
        return visibleTrackers.keys.count
    }
    
    
}
