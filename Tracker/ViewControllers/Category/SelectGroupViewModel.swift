//
//  SelectGroupViewModel.swift
//  Tracker
//
//  Created by Vitaly on 31.08.2023.
//

import Foundation

final class SelectGroupViewModel {
    
    @Observable
    var categories: [String] =  [] //["Важное", "Радостные мелочи", "Самочувствие", "Привычки"]
    
    var selectedCategory: String = "" //Важное"
    
    weak var selectGroupViewController: SelectGroupViewController?
    
    
    // did set setCategoryName
    
    private var trackerCategoryStore = TrackerCategoryStore()
    
    init() {
        trackerCategoryStore.delegate = self
        
        guard let a = trackerCategoryStore.getCategories(),
              let currentCategory = a.first  else { return }
        
        categories = a.map { $0.categoryName }
        
        selectedCategory = currentCategory.categoryName
      
    }
    
    func addCategory(name: String)  -> Bool {
        return trackerCategoryStore.addCategory(TrackerCategory(categoryName: name))
    }
    
    func deleteCategory(name: String) -> Bool {
        return trackerCategoryStore.deleteCategory(name)
    }
    
    func renameCategory(name: String, newCategoryName: String)  -> Bool {
        return trackerCategoryStore.updateCategory(category: TrackerCategory(categoryName: name), newCategory: TrackerCategory(categoryName: newCategoryName))
    }
}

extension SelectGroupViewModel: TrackerCategoryStoreDelegateProtocol {
    func didUpdate() {
        //print("TrackerCategoryStoreDelegateProtocol didUpdate")
        
        guard let a = trackerCategoryStore.getCategories() else { return }
        categories = a.map { $0.categoryName }
    }
    
    
    
}
