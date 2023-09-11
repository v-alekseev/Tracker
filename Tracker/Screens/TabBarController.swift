//
//  TabBarController.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 09.08.2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(
            title: barControllerTrackers,
            image: UIImage(named: "trackers"),
            selectedImage: nil
        )
        let navigationController = UINavigationController(rootViewController: trackersViewController)
        
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: barControllerStatisic,
            image: UIImage(named: "stats"),
            selectedImage: nil
        )
        
        self.viewControllers = [navigationController, statisticViewController]
    }
}

