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
        
        self.navigationItem.title = L10n.Statistic.title //"Новая привычка" //"statistic.title"
        self.navigationController?.navigationBar.titleTextAttributes = [ .font: YFonts.fontYPMedium16]

        let label = UILabel()
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = L10n.Statistic.lebel //"тестовый label" //"statistic.lebel"
        label.textColor = .ypBlackDay
        label.font = YFonts.fontYPMedium16

        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
}
