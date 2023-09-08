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
        guard let scene = (scene as? UIWindowScene),
              let application = UIApplication.shared.delegate as? AppDelegate,
              let isCompleteOnbording = application.isCompleteOnbording else { return }
        

        window = UIWindow(windowScene: scene)
        let onboardingVC = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        let tabBarVC = application.getTabBarViewController()
        let firstViewController = isCompleteOnbording ? tabBarVC : onboardingVC
        
        window?.rootViewController = firstViewController 
        window?.makeKeyAndVisible()
    }

}

