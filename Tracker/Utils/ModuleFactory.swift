//
//  ModuleFactory.swift
//  Tracker
//
//  Created by Vitaly on 25.09.2023.
//

import Foundation
import UIKit

struct ModuleFactory {

//         static func createSelectGroupModule() -> ViewController {
//               let vc = ViewController()
//               let viewModel = ViewModel()
//               vc.viewModel = viewModel
    
//               /// если сделаешь роутер
//              let router = Router()
//              router.viewController = vc
//             return vc
//         }

     /// Создает основной экран со списком трекеров (TrackersViewController)
     static func createTrackersNavigationController() -> UINavigationController {
         let trackersViewController = TrackersViewController()
         let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
         trackersNavigationController.tabBarItem = UITabBarItem(
             title: barControllerTrackers,
             image: UIImage(named: "trackers"),
             selectedImage: nil
         )
         trackersNavigationController.navigationBar.backgroundColor = .ypWhiteDay
         
           /// если сделаешь роутер
//          let router = Router()
//          router.viewController = vc
         return trackersNavigationController
     }
    
    /// Создает  экран со статистикой  (StatisticViewController)
    static func createStatisticNavigationController() -> UINavigationController {
        let statisticViewController = StatisticViewController()
        let statisticNavigationController = UINavigationController(rootViewController: statisticViewController)
        statisticNavigationController.tabBarItem = UITabBarItem(
            title: barControllerStatisic,
            image: UIImage(named: "Stats"),
            selectedImage: nil
        )
        return statisticNavigationController
    }
    
    /// Создает  TabBarController  для основного экрана приложения
    static func getTabBarViewController() -> UITabBarController {
        
        // экран трекеров
        let trackersNavigationController =  ModuleFactory.createTrackersNavigationController()
        // экран статистики на tabBar
        let statisticNavigationController = ModuleFactory.createStatisticNavigationController()
        
        let tabBar = UITabBarController()
        tabBar.tabBar.backgroundColor = .ypWhiteDay
        tabBar.viewControllers = [trackersNavigationController, statisticNavigationController]
        tabBar.tabBar.layer.borderWidth = 0.50
        tabBar.tabBar.layer.borderColor = UIColor.ypWhiteNight.cgColor
        tabBar.tabBar.clipsToBounds = true
        tabBar.view.backgroundColor = .ypWhiteDay
        
        return tabBar
        
    }
    /// Создает  экран фильтров  (SelectFilterViewController)  selectedFilter - какой фильтр должен быть выбран на экране
    static func getSelectFilterNavigatorController(trackerViewController: TrackersViewController, selectedFilter: Filter) -> UINavigationController {
        
        let viewControllerToPresent = SelectFilterViewController()
        viewControllerToPresent.selectFilterViewModel.trackersViewController = trackerViewController
        viewControllerToPresent.selectFilterViewModel.selectedFilter = selectedFilter
        
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        navigationController.modalPresentationStyle = .pageSheet
        
        return navigationController
    }
    /// Создает экран с выбором типа создаваемого трекера  (SelectTrackerViewController)
    static func getSelectTrackerNavigatorController(trackerViewController: TrackersViewController) -> UINavigationController {
        
        let viewControllerToPresent = SelectTrackerViewController()
        viewControllerToPresent.trackersViewController = trackerViewController
        
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        navigationController.modalPresentationStyle = .pageSheet
        
        return navigationController
    }
    
    /// Создает экран создания трекера  (SelectTrackerViewController)  isEvent  - false видна кнопка выбора рассписания,   true - расписание скрываем и создается трекер типа событие на каждый день
    static func getCreateTrackerViewController(trackerViewController: TrackersViewController, isEvent: Bool) -> CreateTrackerViewController {
        
        let createTrackerViewController = CreateTrackerViewController()
        createTrackerViewController.isEvent = isEvent
        createTrackerViewController.trackersViewController = trackerViewController
        
        return createTrackerViewController
    }
    
    /// Создает экран выбора расписания трекера  (CreateScheduleViewController) scheduleDays - класс в котром хранится расписание
    static func getCreateScheduleNavigationController (createTrackerViewController: CreateTrackerViewController, scheduleDays: ScheduleDays) -> UINavigationController {
        
        let createScheduleViewController = CreateScheduleViewController()
        createScheduleViewController.scheduleDays = scheduleDays
        createScheduleViewController.createTrackerViewController = createTrackerViewController
        
        let navigationController = UINavigationController(rootViewController: createScheduleViewController)
        navigationController.modalPresentationStyle = .pageSheet
        
        return navigationController
    }

    /// Создает экран выбора расписания трекера  (CreateScheduleViewController) categoryName - название текущей выбранной категории
    static func getSelectGroupNavigationController (createTrackerViewController: CreateTrackerViewController, categoryName: String) -> UINavigationController {
        
        let selectGroupViewController = SelectGroupViewController()
        selectGroupViewController.setCurrentCategory(name: categoryName)
        selectGroupViewController.selectGroupViewModel.initViewModel(createTrackerViewController: createTrackerViewController)
        
        let navigationController = UINavigationController(rootViewController: selectGroupViewController)
        navigationController.modalPresentationStyle = .pageSheet
        
        return navigationController
    }
    
    /// Создает экран выбора расписания трекера  (CreateGroupViewController)
    static func getCreateGroupNavigationController () -> UINavigationController {
        let createGroupViewController = CreateGroupViewController()
        
        let navigationController = UINavigationController(rootViewController: createGroupViewController)
        navigationController.modalPresentationStyle = .pageSheet
        
        return navigationController
    }
    
    /// Создает экран выбора расписания трекера  (CreateGroupViewController), currentCategoryName - имя категории которое будет показано в окне редактирования
    static func getEditCategoryNavigationController ( currentCategoryName: String) -> UINavigationController {
        let editCategoryViewController = EditCategoryViewController(currentCategory: currentCategoryName)
        
        let navigationController = UINavigationController(rootViewController: editCategoryViewController)
        navigationController.modalPresentationStyle = .pageSheet
        
        return navigationController
    }
}
