//
//  EmojiCollectionViewDelegate.swift
//  Tracker
//
//  Created by Vitaly on 15.08.2023.
//

import Foundation
import UIKit



final class EmojiViewControllerDelegate: NSObject {
    weak var createTrackerViewController: CreateTrackerViewController?
    
    init(createTrackerViewController: CreateTrackerViewController? = nil) {
        self.createTrackerViewController = createTrackerViewController
    }
}

extension EmojiViewControllerDelegate: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let createTrackerViewController = createTrackerViewController else { return 0}
        return createTrackerViewController.getCountEmojis()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let createTrackerViewController = createTrackerViewController else { return UICollectionViewCell()}
        
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: createTrackerViewController.emojiCellId, for: indexPath) as? EmojiCollectionViewCell) ?? EmojiCollectionViewCell()
       
        cell.titleLabel.text = createTrackerViewController.emojis[indexPath.row]
        return cell
    }
}

extension EmojiViewControllerDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
        cell?.backgroundColor = .ypLightGray
        self.createTrackerViewController?.changeFieldValueEvent()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
        cell?.backgroundColor = .clear
        self.createTrackerViewController?.changeFieldValueEvent()
    }
}

extension EmojiViewControllerDelegate: UICollectionViewDelegateFlowLayout {
    // размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWight = (collectionView.bounds.width-18-19-(5*5))/6
        return CGSize(width: cellWight, height: 52)
    }
    // отступ между яейками в одном ряду
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    // отступы ячеек от краев  коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 19)
    }
    // отвечает за вертикальные отступы  между яцейками в коллекции;
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

