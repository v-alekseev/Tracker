//
//  CreateGroupViewModel.swift
//  Tracker
//
//  Created by Vitaly on 06.09.2023.
//

import Foundation
import UIKit

final class CreateGroupViewModel {
    
    private var trackerCategoryStore = TrackerCategoryStore()
    
    func addCategory(name: String)  -> Bool {
        return trackerCategoryStore.addCategory(TrackerCategory(categoryName: name))
    }
    

}
