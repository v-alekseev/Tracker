//
//  ColorsCollectionViewCell.swift
//  Tracker
//
//  Created by Vitaly on 15.08.2023.
//

import Foundation
import UIKit

class ColorsCollectionViewCell: UICollectionViewCell {
    
    let colorView = UIView()
    var isPressed = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 8

        
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
