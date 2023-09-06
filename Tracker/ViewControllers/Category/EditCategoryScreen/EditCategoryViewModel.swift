//
//  EditCategoryViewModel.swift
//  Tracker
//
//  Created by Vitaly on 06.09.2023.
//

import Foundation

import Foundation
import UIKit

final class EditCategoryViewModel {
    
    private var trackerCategoryStore = TrackerCategoryStore()
    
    func renameCategory(name: String, newCategoryName: String)  -> Bool {
        guard !name.isEmpty else { return false }
        return trackerCategoryStore.updateCategory(category: TrackerCategory(categoryName: name), newCategory: TrackerCategory(categoryName: newCategoryName))
    }
    
}

