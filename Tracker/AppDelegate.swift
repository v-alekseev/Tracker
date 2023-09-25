//
//  AppDelegate.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 05.08.2023.
//

import UIKit
import CoreData
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    @UserDefaultsBacked<Bool>(key: "is_coplete_onbording") var isCompleteOnbording
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: trackerCoreDataModel)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        guard let application = UIApplication.shared.delegate as? AppDelegate else { return false}

        if application.isCompleteOnbording == nil {
            application.isCompleteOnbording = false
        }
        
        
        AnalyticsService.activate()

        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    


}

