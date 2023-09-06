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
    
//    func addCategory(name: String)  -> Bool {
//        return trackerCategoryStore.addCategory(TrackerCategory(categoryName: name))
//    }
    
    func deleteCategory(name: String) -> Bool {
        return trackerCategoryStore.deleteCategory(name)
    }
    
//    func renameCategory(name: String, newCategoryName: String)  -> Bool {
//        guard !name.isEmpty else { return false }
//        return trackerCategoryStore.updateCategory(category: TrackerCategory(categoryName: name), newCategory: TrackerCategory(categoryName: newCategoryName))
//    }
//    
    func showCreateNewCategoryScreen() {
        guard let selectGroupViewController = selectGroupViewController else { return }
        let createGroupViewController = CreateGroupViewController()
        
        let navigationController = UINavigationController(rootViewController: createGroupViewController)
        navigationController.modalPresentationStyle = .pageSheet
        selectGroupViewController.present(navigationController, animated: true)
    }
    
    func showEditCategoryScreen(categoryName: String) {
        guard let selectGroupViewController = selectGroupViewController else { return }

        let editCategoryViewController = EditCategoryViewController(currentCategory: categoryName)
        //editCategoryViewController.selectGroupViewModel = self
        
        let navigationController = UINavigationController(rootViewController: editCategoryViewController)
        navigationController.modalPresentationStyle = .pageSheet
        selectGroupViewController.present(navigationController, animated: true)
    }
    
    func initViewModel(createTrackerViewController: CreateTrackerViewController) {
        self.createTrackerViewController = createTrackerViewController
    }
    
    func didSelectRow(index: Int) {
        guard let selectGroupViewController = selectGroupViewController else { return }
        
        createTrackerViewController?.setCategoryName(name: categories[index])
        
        selectGroupViewController.dismiss(animated: true)
    }
}

extension SelectGroupViewModel: TrackerCategoryStoreDelegateProtocol {
    func didUpdate() {
        print("Did Update")
        guard let trackersCategories = trackerCategoryStore.getCategories() else { return }
        categories = trackersCategories.map { $0.categoryName }
    }
}
