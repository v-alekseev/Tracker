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
    enum LogoType {
        case searchNothing
        case noTrackers
    }

    // MARK: - Constants
    let cellId = "TrackerCell"

    // MARK: - Public Properties
    var visibleTrackers: [Tracker] = []
    var trackers: [Tracker] = []
    var collectionView: UICollectionView?
    
    private (set) var currentDate: Date = Date()

    // MARK: - Private Properties
  
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var logoImageView: UIImageView?
    private var logoLabel: UILabel?
    private var datePicker: UIDatePicker?

    // MARK: - UIViewController(*)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        logoImageView = addDefaultImageView()
        logoLabel = addDefaultLabel()
        collectionView = addTrackersCollectionsView()
        
        showLogo(true)
    }

    // MARK: - Public Methods
    
    private func setupNavigationBar() {
        guard let navBar = navigationController?.navigationBar else  { return }
        
        self.view.backgroundColor = .ypWhiteDay
        navBar.topItem?.title = "Трекеры"
        navBar.largeTitleTextAttributes = [ .font: YFonts.fontYPBold34]
        navBar.prefersLargeTitles = true
        
        // Добавляем +
        let leftButton = UIBarButtonItem(image: UIImage(named: "AddTracker"), style: .plain, target: self, action: #selector(addNewTrackerButtonTap))
        leftButton.tintColor = .black
        navBar.topItem?.setLeftBarButton(leftButton, animated: false)

        // добавляем строку поиска
        let seachController = UISearchController()  //
        seachController.hidesNavigationBarDuringPresentation = false
        seachController.searchResultsUpdater = self
        self.navigationItem.searchController = seachController
        
        // добавляем DatePicker
        datePicker = UIDatePicker()
        guard let datePicker = datePicker  else { return }
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.calendar.firstWeekday = 2
        //datePicker.tintColor = .ypBlackDay
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.didChangeDate), for: .valueChanged)
        let rightButton = UIBarButtonItem(customView: datePicker)
        navBar.topItem?.setRightBarButton(rightButton, animated: false)
        
        currentDate = datePicker.date
        
        // TODO выводит дату не так как в ТЗ. В паке есть тред про это.,но решения нет
        //            datePicker.translatesAutoresizingMaskIntoConstraints = false
        //            datePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        //            datePicker.locale = Locale(identifier: "en")
        
        view.frame.size.height = 200
    }

    func showLogo(_ uiShow: Bool, whichLogo: LogoType = .noTrackers) {
        logoImageView?.isHidden = !uiShow
        logoImageView?.image = (whichLogo == .noTrackers) ? UIImage(named: "NoTrackers") : UIImage(named: "SearchError")
        logoLabel?.isHidden = !uiShow
        logoLabel?.text = (whichLogo == .noTrackers) ? "Что будем отслеживать?" : "Ничего не найдено"
        collectionView?.isHidden = uiShow
    }
    
    func searchTrackers(text: String) -> [Tracker] {
        var trackers: [Tracker] = []
        for tracker in self.trackers {
            if tracker.trackerName.contains(text) {
                trackers.append(tracker)
            }
        }
        return trackers
    }
    
    func isTrackerCompleted(trackerID: UUID, date: Date) -> Bool {
        for trackerRecors in completedTrackers {
            if trackerRecors.trackerID == trackerID && trackerRecors.date == date {
                return true
            }
        }
        return false
    }
    
    // функция возвращает массив терекеров у которых либо нет рассписания, либо он должен быть показан в выбранную дату (день недели совпадает)
    func createVisibleTrackers(trackers: [Tracker]) -> [Tracker] {
        var visibleTrackers: [Tracker] = []
        
        guard let calendar = NSCalendar(identifier: .ISO8601) else { return visibleTrackers }
        let currentDayOfWeek =  DaysOfWeek(rawValue: calendar.component(.weekday, from: currentDate))
        
        for tracker in trackers {
            if tracker.trackerScheduleDays.count == 0 { // расписания нет, показываем каждый день
                visibleTrackers.append(tracker)
            } else {
                for day in tracker.trackerScheduleDays {
                    if day.dayOfWeek == currentDayOfWeek {
                        visibleTrackers.append(tracker)
                    }
                }
            }
        }
        return visibleTrackers
    }
    
    // возвращает индекс массива и название категории по  ID трекера
    func getTrackersCollectionsCount(trackers: [Tracker]) -> Int {
        var categories = Set<String>()
        for tracker in trackers {
            categories.insert(getTrackerCategoryName(trackerID: tracker.trackerID))
        }
        return categories.count
    }

    func addTrackerRecord(trackerID: UUID) {
        completedTrackers.append(TrackerRecord(trackerID: trackerID, date: currentDate))
    }
    
    func removeTrackerRecord(trackerID: UUID, date: Date) -> Bool {
        for (index, trackerRecors) in completedTrackers.enumerated() {
            if trackerRecors.trackerID == trackerID &&
               trackerRecors.date == date {
                completedTrackers.remove(at: index)
                return true
            }
        }
        print("[error] removeTrackerRecord(\(trackerID), \(date)) return FALSE")
        return false
    }
    
    // Обработка нажатия на кнопку Сохранить на форме создания трекера
    func addTracker(tracker: Tracker, trackerCategory: String) {
        guard let collectionView = collectionView else { return }
 
        // Обрабатываем создание категории category
        // это блок кода будет переписан в 15 спринте когда будут добавлена работа с категориями
        // TODO
        addNewCategory(trackerID: tracker.trackerID, name: trackerCategory)

        // Орабатываем создание трекера
        trackers.append(tracker)
        let oldVisibleTrackersCount =  visibleTrackers.count
        visibleTrackers = createVisibleTrackers(trackers: trackers)

        // добавленный трекер может быть и не должен отображаться.
        if(visibleTrackers.count > oldVisibleTrackersCount){
            showLogo(false)
            // Нельзя делать performBatchUpdates если при этом добавляется категория
            // Нужно понимать добавилась новая категория или нет. Если добавилась, то перерисовываем полностью
            // Возможно решение ВСЕГДА отображать ВСЕ категории. Но этого в ТЗ ни как не описано
            collectionView.reloadData()
//            collectionView.performBatchUpdates {
//                collectionView.insertItems(at: [IndexPath(row: visibleTrackers.count-1, section: 0) ])
//            }
        }

    }
    
    // сколько дней выполнен трекер
    func getComletedDays(trackerID: UUID) -> Int {
        var countDays = 0
        for trackerRecors in completedTrackers {
            if trackerRecors.trackerID == trackerID {
                countDays += 1
            }
        }
        return countDays
    }
    
    // возвращает индекс массива и название категории по  ID трекера
    func getTrackerCategoryName(trackerID: UUID) -> String {
        var trackerCategoryName: String = ""
        
        for category in categories {
            for uuid in category.trackerIDs {
                if(uuid == trackerID) {
                    trackerCategoryName = category.categoryName
                    break
                }
            }
        }
        
        return trackerCategoryName
    }


    // MARK: - IBAction
    // нажали кнопку добавить трекер
    @objc
    private func addNewTrackerButtonTap() {
        print("addTracker")
        
        let viewControllerToPresent = SelectTrackerViewController()
        viewControllerToPresent.trackersViewController = self
       
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true, completion: nil)

    }
    
    // выбрали новую дату
    @IBAction private func didChangeDate(_ sender: UIButton) {
        print("didChangeDate")
        guard let collectionView = collectionView else { return }
        guard let datePicker = datePicker else { return }
        currentDate = datePicker.date
        //self.view.endEditing(true)
        visibleTrackers = createVisibleTrackers(trackers: trackers)
        if visibleTrackers.count > 0 {
            showLogo(false)
            collectionView.reloadData()
        }
        else {
            showLogo(true)
        }


    }



    // MARK: - Private Methods
    
    // возвращает индекс массива с категорией
    private func getCategoryIndex(categoryName: String) -> Int? {
        var trackerCategoryIndex: Int?
        for (index, category) in categories.enumerated() {
            if(categoryName == category.categoryName) {
                trackerCategoryIndex = index
                break
                }
            }
        
        return trackerCategoryIndex
    }
    
    private func addNewCategory(trackerID: UUID, name: String) {
        var newIds: [UUID] = []
        for (index, category) in categories.enumerated() {
            if(category.categoryName == name) {
                newIds = categories[index].trackerIDs
                categories.remove(at: index)
            }
        }

        newIds.append(trackerID)
        categories.append(TrackerCategory(trackerIDs: newIds, categoryName: name))
    }

    private func addTrackersCollectionsView() -> UICollectionView? {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true;
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true;
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true;
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true;
        
        view.backgroundColor = .white
        return collectionView
    }
    
    private func addDefaultImageView() -> UIImageView? {
        let noTrackersImageView =  UIImageView(image: UIImage(named: "NoTrackers"))
        noTrackersImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(noTrackersImageView)
        noTrackersImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 220).isActive = true
        noTrackersImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        return noTrackersImageView
    }

    private func addDefaultLabel() ->  UILabel? {
        guard let noTrackersImageView = logoImageView else { return nil }
        
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
