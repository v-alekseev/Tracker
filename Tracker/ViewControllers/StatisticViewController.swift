//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 09.08.2023.
//

import Foundation
import UIKit

class StatisticViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        
        self.navigationItem.title = "Новая привычка"
        self.navigationController?.navigationBar.titleTextAttributes = [ .font: YFonts.fontYPMedium16]

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "тестовый label"
        label.textColor = .ypBlackDay
        label.font = YFonts.fontYPMedium16
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
}
