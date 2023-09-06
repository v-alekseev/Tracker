//
//  SelectGroupViewController+UITableViewDataSource.swift
//  Tracker
//
//  Created by Vitaly on 05.09.2023.
//

import Foundation
import UIKit

extension SelectGroupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectGroupViewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  SelectGroupTableViewCell()
        
        if let reusedCell =  tableView.dequeueReusableCell(withIdentifier: SelectGroupTableViewCell.cellID) as? SelectGroupTableViewCell {
            cell = reusedCell
        }

        cell.textLabel?.text = selectGroupViewModel.categories[indexPath.row];
        
        cell.markSelected(indexPath: indexPath.row, selectedIndex: selectGroupViewModel.selectionIndex)
        cell.setupSeparator(tableViewWidth: tableView.frame.width, indexPath: indexPath.row, categoriesCount: selectGroupViewModel.categories.count)
        cell.setConerRadius(indexPath: indexPath.row, categoriesCount: selectGroupViewModel.categories.count)

        return cell
    }
}
