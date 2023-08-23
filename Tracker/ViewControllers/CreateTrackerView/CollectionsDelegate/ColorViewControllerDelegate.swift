//
//  ColorViewControllerDelegate.swift
//  Tracker
//
//  Created by Vitaly on 15.08.2023.
//

import Foundation
import UIKit


final class ColorViewControllerDelegate: NSObject {
    var createTrackerViewController: CreateTrackerViewController?
    
    init(createTrackerViewController: CreateTrackerViewController? = nil) {
        self.createTrackerViewController = createTrackerViewController
    }
}

extension ColorViewControllerDelegate: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let createTrackerViewController = createTrackerViewController else { return 0}
        return createTrackerViewController.getCountColors()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let createTrackerViewController = createTrackerViewController else { return UICollectionViewCell()}
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: createTrackerViewController.colorCellId, for: indexPath) as? ColorsCollectionViewCell
        cell?.colorView.backgroundColor = createTrackerViewController.cellColors[indexPath.row]
        return cell!
    }
    
    
}

extension ColorViewControllerDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt \(indexPath)")
        
        let cell = collectionView.cellForItem(at: indexPath) as? ColorsCollectionViewCell
        cell?.layer.borderWidth = 3
        cell?.layer.cornerRadius = 8
        cell?.layer.borderColor = cell?.colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ColorsCollectionViewCell
        //cell?.layer.borderWidth = 0
        cell?.layer.borderColor = UIColor.clear.cgColor
    }
}

extension ColorViewControllerDelegate: UICollectionViewDelegateFlowLayout {
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

