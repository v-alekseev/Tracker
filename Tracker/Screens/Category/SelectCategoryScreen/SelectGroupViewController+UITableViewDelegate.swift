//
//  SelectGroupViewController+UITableViewDelegate.swift
//  Tracker
//
//  Created by Vitaly on 05.09.2023.
//

import Foundation
import UIKit

extension SelectGroupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SelectCategoryDesign.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectGroupViewModel.didSelectRow(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        let menu = UIContextMenuConfiguration(identifier: nil,
                                              previewProvider: nil,
                                              actionProvider: { [weak self] suggestedActions in
            //"Редактировать"
            let duplicateAction = UIAction(title: NSLocalizedString(L10n.CategoryScreen.menuEdit, comment: ""), image: nil) { action in
                guard let self = self else { return }
                self.selectGroupViewModel.showEditCategoryScreen(categoryName: self.selectGroupViewModel.categories[indexPath.row])
            }
            //"Удалить"
            let deleteAction = UIAction(title: NSLocalizedString(L10n.CategoryScreen.menuDelete, comment: ""), image: nil, attributes: .destructive) { action in
                guard let categoryName = self?.selectGroupViewModel.categories[indexPath.row] else { return }
                if self?.selectGroupViewModel.deleteCategory(name: categoryName) == false {
                    self?.alert(text: L10n.CategoryScreen.errorDelete)
                }
            }
            return UIMenu(title: "", children: [duplicateAction, deleteAction])
        })
        
        return menu
    }
    
}
