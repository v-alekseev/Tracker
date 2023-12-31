//
//  ColorViewControllerDelegate.swift
//  Tracker
//
//  Created by Vitaly on 15.08.2023.
//

import Foundation
import UIKit


final class ColorViewControllerDelegate: NSObject {
    weak var createTrackerViewController: CreateTrackerViewController?
    
    let pointsBetwinCells: CGFloat = 5
    let countCellInRow: CGFloat = 6
    let pointsIndenXLeft: CGFloat = 18
    let pointsIndenXRight: CGFloat = 19
    
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
        
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: createTrackerViewController.colorCellId, for: indexPath) as? ColorsCollectionViewCell) ?? ColorsCollectionViewCell()
        
        cell.colorView.backgroundColor = createTrackerViewController.cellColors[indexPath.row]

        return cell
    }
    
    
}

extension ColorViewControllerDelegate: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = (collectionView.cellForItem(at: indexPath) as? ColorsCollectionViewCell) ?? ColorsCollectionViewCell()
        
        cell.backView.layer.borderWidth = 3
        cell.backView.layer.cornerRadius = 8
        cell.backView.layer.borderColor = cell.colorView.backgroundColor?.withAlphaComponent(0.3).cgColor

        self.createTrackerViewController?.changeFieldValueEvent()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ColorsCollectionViewCell
        
        cell?.backView.layer.borderColor = UIColor.clear.cgColor
        
        self.createTrackerViewController?.changeFieldValueEvent()
    }
}

extension ColorViewControllerDelegate: UICollectionViewDelegateFlowLayout {
    // размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let allCellsWidth = pointsBetwinCells * (countCellInRow-1)
        let collectionWidth = collectionView.bounds.width - (pointsIndenXLeft + pointsIndenXRight + allCellsWidth)
        let cellWight = collectionWidth/countCellInRow
        return CGSize(width: cellWight, height: cellWight)
    }
    // отступ между яейками в одном ряду
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return pointsBetwinCells
    }
    // отступы ячеек от краев  коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: pointsIndenXLeft, bottom: 24, right: pointsIndenXRight)
    }
    // отвечает за вертикальные отступы  между яцейками в коллекции;
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

