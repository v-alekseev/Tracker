//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Vitaly on 15.08.2023.
//

import Foundation
import UIKit



class EmojiCollectionViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    var isPressed = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = YFonts.fontYPBold32
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
