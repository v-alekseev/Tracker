//
//  SelectGroupTableViewCell.swift
//  Tracker
//
//  Created by Vitaly on 04.09.2023.
//

import Foundation
import UIKit

final class SelectGroupTableViewCell : UITableViewCell {
    
    // MARK: - Consts
    static let cellID = "SelectGroupTableViewCellID"
    
    var separator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(separator)
        separator.backgroundColor = .ypGray
        
//        NSLayoutConstraint.activate([
//            //groupsTable.topAnchor.constraint(contentView: view.safeAreaLayoutGuide.topAnchor, constant: 24),
//            separator.heightAnchor.constraint(equalToConstant: 1),
//            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20),
//            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
//        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 0
        
        self.separator.isHidden = false
    }
}
