//
//  SelectFilterViewModel.swift
//  Tracker
//
//  Created by Vitaly on 15.09.2023.
//

import Foundation
import UIKit

final class SelectFilterViewModel {
    
    @Observable
    var isShouldControllerClose = false
    @Observable
    var selectedFilter: Filter  = .all
    var selectionIndex: Int? {
        get {
            return Filter.allCases.firstIndex(of: self.selectedFilter)
        }
    }
    var filters =  Dictionary<Filter, String>()
    
    weak var selectFilterViewController: SelectFilterViewController?
    weak var trackersViewController: TrackersViewController?
    
    private var trackerCategoryStore = TrackerCategoryStore()
    
    init() {
        filters[.all] = L10n.Filter.all
        filters[.today] = L10n.Filter.today
        filters[.completed] = L10n.Filter.completed
        filters[.uncompleted] = L10n.Filter.uncompleted
    }
    
    func initViewModel(trackersViewController: TrackersViewController) {
        self.trackersViewController = trackersViewController
    }
    
    func didSelectRow(index: Int) {
        trackersViewController?.setFilter(filter: Filter.allCases[index])
        isShouldControllerClose = true
    }
}
