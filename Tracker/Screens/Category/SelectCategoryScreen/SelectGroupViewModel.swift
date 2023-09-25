//
//  SelectGroupViewModel.swift
//  Tracker
//
//  Created by Vitaly on 31.08.2023.
//

import Foundation
import UIKit

final class SelectGroupViewModel {
    
    @Observable
    var isShouldControllerClose = false
    @Observable
    var categories: [String] =  []
    var selectedCategory: String = ""
    var selectionIndex: Int? {
        get {
            return self.categories.firstIndex(of: self.selectedCategory)
        }
    }
    
    weak var selectGroupViewController: SelectGroupViewController?
    weak var createTrackerViewController: CreateTrackerViewController?
    
    //TODO: did set setCategoryName
    
    private var trackerCategoryStore = TrackerCategoryStore()
    
    init() {
        trackerCategoryStore.delegate = self
        
        guard let trackersCategories = trackerCategoryStore.getCategories(),
              let currentCategory = trackersCategories.first  else { return }
        
        categories = trackersCategories.map { $0.categoryName }
        selectedCategory = currentCategory.categoryName
    }
    
    func deleteCategory(name: String) -> Bool {
        return trackerCategoryStore.deleteCategory(name)
    }
    
    func showCreateNewCategoryScreen() {
        guard let selectGroupViewController = selectGroupViewController else { return }
        
        let navigationController = ModuleFactory.getCreateGroupNavigationController ()
        selectGroupViewController.present(navigationController, animated: true)
    }
    
    func showEditCategoryScreen(categoryName: String) {
        guard let selectGroupViewController = selectGroupViewController else { return }
        
        let navigationController = ModuleFactory.getEditCategoryNavigationController (currentCategoryName: categoryName)
        selectGroupViewController.present(navigationController, animated: true)
    }
    
    func initViewModel(createTrackerViewController: CreateTrackerViewController) {
        self.createTrackerViewController = createTrackerViewController
    }
    
    func didSelectRow(index: Int) {
        createTrackerViewController?.setCategoryName(name: categories[index])        
        isShouldControllerClose = true
    }
}

extension SelectGroupViewModel: TrackerCategoryStoreDelegateProtocol {
    func didUpdate() {
        guard let trackersCategories = trackerCategoryStore.getCategories() else { return }
        categories = trackersCategories.map { $0.categoryName }
    }
}
