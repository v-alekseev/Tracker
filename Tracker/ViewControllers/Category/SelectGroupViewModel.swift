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
    var categories: [String] =  []
    var selectedCategory: String = ""
    var selectionIndex: Int? {
        get {
            return self.categories.firstIndex(of: self.selectedCategory)
        }
    }
    
    weak var selectGroupViewController: SelectGroupViewController?
    
    
    //TODO: did set setCategoryName
    
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
        if(name == "") {
            return false
        }
        return trackerCategoryStore.updateCategory(category: TrackerCategory(categoryName: name), newCategory: TrackerCategory(categoryName: newCategoryName))
    }
    
    func showCreateNewCategoryScreen() {
        guard let selectGroupViewController = selectGroupViewController else { return }
        let createGroupViewController = CreateGroupViewController()
        
        createGroupViewController.selectGroupViewModel = selectGroupViewController.selectGroupViewModel
        
        let navigationController = UINavigationController(rootViewController: createGroupViewController)
        navigationController.modalPresentationStyle = .pageSheet
        selectGroupViewController.present(navigationController, animated: true)
    }
    
    func showEditCategoryScreen(categoryName: String) {
        guard let selectGroupViewController = selectGroupViewController else { return }

        let editCategoryViewController = EditCategoryViewController(currentCategory: categoryName)
        editCategoryViewController.selectGroupViewModel = self
        
        let navigationController = UINavigationController(rootViewController: editCategoryViewController)
        navigationController.modalPresentationStyle = .pageSheet
        selectGroupViewController.present(navigationController, animated: true)
    }
    
}

extension SelectGroupViewModel: TrackerCategoryStoreDelegateProtocol {
    func didUpdate() {
        guard let a = trackerCategoryStore.getCategories() else { return }
        categories = a.map { $0.categoryName }
    }
    
    
    
}
