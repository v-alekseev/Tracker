//
//  TrackersViewController+UICollectionViewDelegateFlowLayout.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 14.08.2023.
//

import Foundation
import UIKit

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    // размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWight = (collectionView.bounds.width-16-16-9)/2
        return CGSize(width: cellWight, height: 148)
    }
    // отступ между яейками в одном ряду  (горизонтальные отступы)   // отвечает за горизонтальные отступы между ячейками.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    // отступы ячеек от краев  коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    }
    // отвечает за вертикальные отступы  между яцейками в коллекции;
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // устанавливаем категорию для ячейки
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
        default:
            id = ""
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! SupplementaryView
        
        view.titleLabel.text = visibleTrackers.getKeyByIndex(index: indexPath.section) //visibleTrackers.keys.sorted()[indexPath.section]
        return view
    }
    
    // устанавливаем размер хидера в секции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        // FIXIT: UICollectionView internal inconsistency: attempting to apply nil layout attributes to view.
        let headerView = SupplementaryView()
        var categoryName = ""
        if(visibleTrackers.keys.count > 0 ) {
            categoryName =  visibleTrackers.getKeyByIndex(index: section) //visibleTrackers.keys.sorted()[section]
        }
        
        headerView.titleLabel.text = categoryName
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(actionProvider: { [weak self] suggestedActions in
            guard let self = self,
                  let cell = collectionView.cellForItem(at: indexPaths.first!) as? TrackerCollectionViewCell,
                  let isCellPinned = cell.isPinned,
                  let tracker = cell.tracker else { return UIMenu() }
            
            let pinMenuItemString = isCellPinned ? L10n.Tracker.ContextMenu.unpin : L10n.Tracker.ContextMenu.pin
            if indexPaths.count == 1 {
                return UIMenu(children: [
                    // pin/unpin
                    UIAction(title: pinMenuItemString) {  [weak self] _ in
                        guard let self = self,
                              let currentTracker = cell.tracker else {return}
                        let newTracker = Tracker(tracker: currentTracker, isPinned: !isCellPinned)
                        self.updateTracker(tracker: newTracker)
                    },
                    // edit
                    UIAction(title: L10n.Tracker.ContextMenu.edit) {  [weak self] _ in
                        guard let self = self else { return }
                        self.analyticsService.eventEdit()
                        let createTrackerViewController = CreateTrackerViewController(isEdit: true, tracker: tracker)
                        createTrackerViewController.isEvent = false
                        createTrackerViewController.trackersViewController = self

                        let navigationController = UINavigationController(rootViewController: createTrackerViewController)
                        navigationController.modalPresentationStyle = .pageSheet
                        
                        self.present(navigationController, animated: true)
                    },
                    // delete
                    UIAction(title: L10n.Tracker.ContextMenu.delete, attributes: .destructive) { [weak self] _ in
                        guard let self = self,
                              let trackerID = cell.trackerID else { return }
                        self.analyticsService.eventDelete()
                        
                        self.deleteTracker(trackerID: trackerID)
                    }
                ])
            }
            
            return UIMenu()
        })
    }
}
