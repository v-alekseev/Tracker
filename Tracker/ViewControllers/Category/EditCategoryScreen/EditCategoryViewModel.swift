//
//  EditCategoryViewModel.swift
//  Tracker
//
//  Created by Vitaly on 06.09.2023.
//

import Foundation

final class EditCategoryViewModel {

    var currentCategoryName: String = ""
    @Observable
    var newCategoryName: String = ""
    @Observable
    var isRenameSuccsesed: Bool = true
    
    private var trackerCategoryStore = TrackerCategoryStore()
    
    func renameCategory() {
        guard !newCategoryName.isEmpty else { return }
        
        if trackerCategoryStore.updateCategory(category: TrackerCategory(categoryName: currentCategoryName), newCategory: TrackerCategory(categoryName: newCategoryName)) == false {
            isRenameSuccsesed = false
            return
        }
        
        isRenameSuccsesed = true
    }
}

