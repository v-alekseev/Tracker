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
        
        self.textLabel?.font = YFonts.fontYPRegular17
        self.backgroundColor = .ypBackground
        self.selectionStyle = .none

    }
    
    func markSelected(indexPath: Int, selectedIndex: Int?) {
        // отмечаем выбранную ячейку
        if(indexPath == selectedIndex) {
            self.accessoryType = .checkmark
            return
        }
        
        self.accessoryType = .none
    }
    
    func setupSeparator(tableViewWidth: CGFloat, indexPath: Int, categoriesCount: Int) {
        // расчитываем размер и позицию разделителя
        self.separator.frame.size = CGSize(width:  tableViewWidth - SelectCategoryDesign.separatorIndenXLeft - SelectCategoryDesign.separatorIndenXRight, height: SelectCategoryDesign.separatorHeight)
        self.separator.frame.origin = CGPoint(x: SelectCategoryDesign.separatorIndenXLeft, y: SelectCategoryDesign.cellHeight - SelectCategoryDesign.separatorHeight)
        
        // скрываем сепаратор в последней ячейки
        if indexPath == categoriesCount - 1 {
            self.separator.isHidden = true
        }
    }
    
    func setConerRadius(indexPath: Int, categoriesCount: Int) {
        //это первая ячейка
        if indexPath == 0 {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = SelectCategoryDesign.tableConerRadius
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        // это последняя ячейка
        if indexPath == categoriesCount - 1 {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = SelectCategoryDesign.tableConerRadius
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
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
