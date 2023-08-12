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
    var trackersViewController: TrackersViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("NewTrackerSelectViewController viewDidLoad()")
        view.backgroundColor = .ypWhiteDay
        
        self.navigationItem.title = "Создание трекера"
        self.navigationController?.navigationBar.titleTextAttributes = [ .font: YFonts.fontYPMedium16]

        // первая кнопка
        let newTrackerButton = UIButton()
        newTrackerButton.setTitle("Привычка", for: .normal)
        newTrackerButton.setTitleColor(.ypWhiteDay, for: .normal)
        newTrackerButton.titleLabel?.font = YFonts.fontYPMedium16
        //print("[TEST] view.layer.masksToBounds = \(newTrackerButton.layer.masksToBounds)")
        //newTrackerButton.layer.masksToBounds = true
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
        newEventButton.setTitle("Нерегулярное событие", for: .normal)
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
  
    @IBAction private func buttonNewEventTapped(_ sender: UIButton) {
        print("buttonNewEventTapped")
        presentCreteEventController(isEvent: true)
        return
    }
    
    @IBAction private func buttonNewTrackerTapped(_ sender: UIButton) {
        print("buttonNewTrackerTapped")
        presentCreteEventController(isEvent: false)
        return
    }
    

    
    private func presentCreteEventController(isEvent: Bool) {
        
        let createTrackerViewController = CreateTrackerViewController()
        createTrackerViewController.isEvent = isEvent
        createTrackerViewController.trackersViewController = self.trackersViewController
        let navigationController = UINavigationController(rootViewController: createTrackerViewController)
        navigationController.modalPresentationStyle = .pageSheet
        self.present(navigationController, animated: true)
    }
    
}
