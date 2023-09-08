//
//  CreateGroupViewModel.swift
//  Tracker
//
//  Created by Vitaly on 06.09.2023.
//

import Foundation

final class CreateGroupViewModel {
    
    private var trackerCategoryStore = TrackerCategoryStore()
    
    @Observable
    var categoryName = ""
    
    @Observable
    var isAddCategorySuccsesed: Bool = true
    
    func addCategory(name: String) {
        if trackerCategoryStore.addCategory(TrackerCategory(categoryName: name)) == false  {
            isAddCategorySuccsesed = false
            return
        }
        
        isAddCategorySuccsesed = true
    }
}
