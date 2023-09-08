//
//  CreateTrackerViewController+UITableViewDataSource.swift
//  Tracker
//
//  Created by Vitaly on 05.09.2023.
//

import Foundation
import UIKit

extension CreateTrackerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  UITableViewCell()
        
        if let reusedCell =  tableView.dequeueReusableCell(withIdentifier: "cell")  {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        setupCell(cell: cell, cellIndex: indexPath.row)
        
        return cell
    }
}
