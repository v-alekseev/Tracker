//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 05.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        // первый экран на tabBar
        let trackersViewController = TrackersViewController()
        let navigationController = UINavigationController(rootViewController: trackersViewController)
        navigationController.tabBarItem = UITabBarItem( // так, наверно, более правильно
            title: barControllerTrackers,
            image: UIImage(named: "trackers"),
            selectedImage: nil
        )
        // второй экран на tabBar
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: barControllerStatisic,
            image: UIImage(named: "Stats"),
            selectedImage: nil
        )
        
        let tabBar = TabBarController()
        tabBar.tabBar.backgroundColor = .ypWhiteDay
        tabBar.viewControllers = [navigationController, statisticViewController]
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }

}

