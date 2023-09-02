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
        
        
        // делаем visibleSections SET в классе
        // конвертим его Sorted
        // у visibleTrackers на didSet заполняем его
        // тут вернуть count в зависимости от section
        let categoryName = visibleTrackers.getKeyByIndex(index: section)
        print("numberOfItemsInSection categoryName=\(categoryName),  visibleTrackers[categoryName].count = \(visibleTrackers[categoryName]?.count)")
        return visibleTrackers[categoryName]!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
        print("cellForItemAt index = \(indexPath)")
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? TrackerCollectionViewCell) ?? TrackerCollectionViewCell()

        let categoryName = visibleTrackers.getKeyByIndex(index: indexPath.section)
        let tracker = visibleTrackers[categoryName]![indexPath.row] //visibleTrackers[indexPath.row] //   trackers[indexPath.row]
        cell.trackersViewController = self
        cell.trackerID = tracker.trackerID
        cell.titleLabel?.text = tracker.trackerName
        cell.daysCompletedLabel?.text = "\(getComletedDays(trackerID: tracker.trackerID)) дней"
        cell.emojiLabel?.text = tracker.trackerEmodji
        cell.cardTrackerView?.backgroundColor = tracker.trackerColor
        cell.completeButton?.tintColor = tracker.trackerColor
        
        var imageCellButtom = imageTrackerCellPlus
        if let currentDate = currentDate {
            imageCellButtom = isTrackerCompleted(trackerID: tracker.trackerID, date: currentDate) ? imageTrackerCellCompleted : imageTrackerCellPlus
        }
        print("numberOfItemsInSection indexPath = \(indexPath) tracker.category = \(tracker.trackerCategoryName)")
        cell.completeButton?.setImage(imageCellButtom, for: .normal)

        return cell
        
    }
    
    func numberOfSections(in: UICollectionView) -> Int {

        print("numberOfSections = \(visibleTrackers.keys.count)")
        return visibleTrackers.keys.count
    }

    
}
