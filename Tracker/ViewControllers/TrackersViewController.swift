//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 09.08.2023.
//

import Foundation


import UIKit

class TrackersViewController: UIViewController {
    
    
    // MARK: - Types

    // MARK: - Constants

    // MARK: - Public Properties

    // MARK: - IBOutlet

    // MARK: - Private Properties
    private var noTrackersImageView: UIImageView?
    private var noTrackersLabel: UILabel?

    // MARK: - Initializers

    // MARK: - UIViewController(*)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let navBar = navigationController?.navigationBar else  { return }
        
        self.view.backgroundColor = .ypWhiteDay
        self.navigationController?.navigationBar.topItem?.title = "Трекеры"
        self.navigationController?.navigationBar.largeTitleTextAttributes = [ .font: YFonts.fontYPMedium34]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        // Добавляем + //
        //let leftButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTracker))
        let leftButton = UIBarButtonItem(image: UIImage(named: "AddTracker"), style: .plain, target: self, action: #selector(addTracker))
        leftButton.tintColor = .black
        navBar.topItem?.setLeftBarButton(leftButton, animated: false)

        // добавляем строку поиска
        let seachController = UISearchController()  //
        seachController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.searchController = seachController
        
        
        // добавляем DatePicker
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        
        // TODO выводит дату не так как в ТЗ. В паке есть тред про это.,но решения нет
        //            datePicker.translatesAutoresizingMaskIntoConstraints = false
        //            datePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        //            datePicker.locale = Locale(identifier: "en")
        let rightButton = UIBarButtonItem(customView: datePicker)
        navBar.topItem?.setRightBarButton(rightButton, animated: false)
        
        // это была попытка сделать поиск самому
        //
        //        let seachBar = UISearchTextField()
        //        seachBar.translatesAutoresizingMaskIntoConstraints = false
        //        seachBar.enablesReturnKeyAutomatically = true
        //        self.view.addSubview(seachBar)
        

        noTrackersImageView = addDefaultImageView()
        noTrackersLabel = addDefaultLabel()
    }

    // MARK: - Public Methods
    
    func setDefaultText(text: String) {
        guard let noTrackersLabel = noTrackersLabel else { return }
        noTrackersLabel.text = text
        
    }

    // MARK: - IBAction
    @objc
    private func addTracker() {
        print("addTracker")
        
        let viewControllerToPresent = SelectTrackerViewController()
        viewControllerToPresent.trackersViewController = self
       
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true, completion: nil)

    }

    // MARK: - Private Methods
    
    private func addDefaultImageView() -> UIImageView? {
        let noTrackersImageView =  UIImageView(image: UIImage(named: "NoTrackers"))
        noTrackersImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(noTrackersImageView)
        noTrackersImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 220).isActive = true
        noTrackersImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        return noTrackersImageView
    }

    
    private func addDefaultLabel() ->  UILabel? {
        guard let noTrackersImageView = noTrackersImageView else { return nil }
        
        let noTrackersLabel = UILabel()
        noTrackersLabel.text = "Что будем отслеживать?"
        noTrackersLabel.font = YFonts.fontYPMedium12
        noTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(noTrackersLabel)
        noTrackersLabel.topAnchor.constraint(equalTo: noTrackersImageView.bottomAnchor).isActive = true
        noTrackersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        return noTrackersLabel
    }

}

