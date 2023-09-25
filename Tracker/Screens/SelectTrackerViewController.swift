//
//  newTrackerSelectViewController.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 10.08.2023.
//

import Foundation
import UIKit
import Darwin

class SelectTrackerViewController: UIViewController {
    
    // MARK: - Public Properties
    var trackersViewController: TrackersViewController?
    
    // MARK: - UIViewController(*)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        
        self.navigationItem.title = L10n.SelectTypeTracker.title
        self.navigationController?.navigationBar.titleTextAttributes = [ .font: YFonts.fontYPMedium16]
        
        // первая кнопка
        let newTrackerButton = UIButton()
        newTrackerButton.setTitle(L10n.SelectTypeTracker.regularTracker, for: .normal)
        newTrackerButton.setTitleColor(.ypWhiteDay, for: .normal)
        newTrackerButton.titleLabel?.font = YFonts.fontYPMedium16
        newTrackerButton.layer.cornerRadius = 19
        newTrackerButton.backgroundColor = .ypBlackDay
        newTrackerButton.addTarget(self, action: #selector(self.buttonNewTrackerTapped), for: .touchUpInside)
        
        newTrackerButton.translatesAutoresizingMaskIntoConstraints =  false
        
        view.addSubview(newTrackerButton)
        newTrackerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 281).isActive = true
        newTrackerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        newTrackerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        newTrackerButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // втора кнопка
        let newEventButton = UIButton()
        newEventButton.setTitle(L10n.SelectTypeTracker.irregularTracker, for: .normal)
        newEventButton.setTitleColor(.ypWhiteDay, for: .normal)
        newEventButton.titleLabel?.font = YFonts.fontYPMedium16
        newEventButton.layer.cornerRadius = 19
        newEventButton.backgroundColor = .ypBlackDay
        newEventButton.addTarget(self, action: #selector(self.buttonNewEventTapped), for: .touchUpInside)
        
        newEventButton.translatesAutoresizingMaskIntoConstraints =  false
        
        view.addSubview(newEventButton)
        newEventButton.topAnchor.constraint(equalTo: newTrackerButton.bottomAnchor, constant: 16).isActive = true
        newEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        newEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        newEventButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    // MARK: - IBAction
    @IBAction private func buttonNewEventTapped(_ sender: UIButton) {
        presentCreteEventController(isEvent: true)
        return
    }
    
    @IBAction private func buttonNewTrackerTapped(_ sender: UIButton) {
        presentCreteEventController(isEvent: false)
        return
    }
    
    // MARK: - Private Methods
    private func presentCreteEventController(isEvent: Bool) {
        guard let trackersViewController = self.trackersViewController else { return }
        let createTrackerViewController = ModuleFactory.getCreateTrackerViewController(trackerViewController: trackersViewController , isEvent: isEvent)
        
        self.navigationController?.pushViewController(createTrackerViewController, animated: true)
    }
}
