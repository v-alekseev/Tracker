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
    //var trackers: [Tracker] = []
    var collectionView: UICollectionView?
    var trackerStore = TrackerStore()
    var trackerRecordStore = TrackerRecordStore()
    var trackerCategoryStore = TrackerCategoryStore()
    
    private (set) var currentDate: Date = Date()

    // MARK: - Private Properties
  
   // private var categories: [TrackerCategory] = []
    //private var completedTrackers: [TrackerRecord] = []
    private var logoImageView: UIImageView?
    private var logoLabel: UILabel?
    private var datePicker: UIDatePicker?

    // MARK: - UIViewController(*)
    override func viewDidLoad() {
        super.viewDidLoad()
        trackerStore.delegate = self

        setupNavigationBar()
        logoImageView = addDefaultImageView()
        logoLabel = addDefaultLabel()
        collectionView = addTrackersCollectionsView()
        
        currentDate = getCurrentDate(incomingDate: Date())
        visibleTrackers = createVisibleTrackers(trackers: trackerStore.getTrackers())
        
        showLogo(visibleTrackers.count == 0)
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
        for tracker in self.trackerStore.getTrackers() {
            if tracker.trackerName.contains(text) {
                trackers.append(tracker)
            }
        }
        return trackers
    }
    
    func isTrackerCompleted(trackerID: UUID, date: Date) -> Bool {
        return trackerRecordStore.isRecordExist(TrackerRecord(trackerID: trackerID, date: currentDate))
    }
    
    // функция возвращает массив терекеров у которых либо нет рассписания, либо он должен быть показан в выбранную дату (день недели совпадает)
    func getVisibleTrackers(trackers: [Tracker]) -> [Tracker] {
        var visibleTrackers: [Tracker] = []
        
        guard let calendar = NSCalendar(identifier: .ISO8601) else { return visibleTrackers }
        let currentDayOfWeek =  DaysOfWeek(rawValue: calendar.component(.weekday, from: currentDate))
        
        for tracker in trackers {
            if tracker.trackerScheduleDays.filter({$0.dayValue == true}).count == 0 { // расписания нет, показываем каждый день
                visibleTrackers.append(tracker)
            } else {
                for day in tracker.trackerScheduleDays {
                    if day.dayOfWeek == currentDayOfWeek && day.dayValue == true {
                        visibleTrackers.append(tracker)
                    }
                }
            }
        }
        return visibleTrackers
    }
    
    // возвращает индекс массива и название категории по  ID трекера
    func getTrackersCategoriesCount(trackers: [Tracker]) -> Int {
        var categories = Set<String>()
        for tracker in trackers {
            categories.insert(getTrackerCategoryName(trackerID: tracker.trackerID))
        }
        return categories.count
    }

    func addTrackerRecord(trackerID: UUID) -> Bool {
        
        return trackerRecordStore.addRecord(TrackerRecord(trackerID: trackerID, date: currentDate))
    }
    
    func removeTrackerRecord(trackerID: UUID, date: Date) -> Bool {
        return trackerRecordStore.deleteRecord(TrackerRecord(trackerID: trackerID, date: currentDate))
    }
    
    // Обработка нажатия на кнопку Сохранить на форме создания трекера
    func addTracker(tracker: Tracker, trackerCategoryName: String) {
        print("TrackersViewController addTracker tracker = \(tracker), trackerCategory = \(trackerCategoryName)")
        // Обрабатываем создание категории category
        // TODO: это блок кода будет переписан в 16 спринте когда будут добавлена работа с категориями
        if linkTrackerToCategory(trackerID: tracker.trackerID, categoryName: trackerCategoryName) == false { return }

        if trackerStore.addTracker(tracker) == false { return }
        print("TrackersViewController final")
    }
    
    // сколько дней выполнен трекер
    func getComletedDays(trackerID: UUID) -> Int {
        return trackerRecordStore.getTrackerComletedDays(trackerID: trackerID)
    }
    
    // возвращает индекс массива и название категории по  ID трекера
    func getTrackerCategoryName(trackerID: UUID) -> String {
        return testCategory
        // TODO: 16 спринт. Проблема с поддержкой множественных категорий
//        var trackerCategoryName: String = ""
//
//        for category in categories {
//            for uuid in category.trackerIDs {
//                if(uuid == trackerID) {
//                    trackerCategoryName = category.categoryName
//                    break
//                }
//            }
//        }
//
//        return trackerCategoryName
    }


    // MARK: - IBAction
    // нажали кнопку добавить трекер
    @objc
    private func addNewTrackerButtonTap() {
        let viewControllerToPresent = SelectTrackerViewController()
        viewControllerToPresent.trackersViewController = self
       
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true, completion: nil)

    }

    func getCurrentDate(incomingDate: Date) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: incomingDate)
        print(dateString)

        return dateFormatter.date(from: dateString)!
    }
    
    // выбрали новую дату
    @IBAction private func didChangeDate(_ sender: UIButton) {
        print("didChangeDate")
        guard let collectionView = collectionView else { return }
        guard let datePicker = datePicker else { return }

        currentDate = getCurrentDate(incomingDate: datePicker.date as Date)

        visibleTrackers = getVisibleTrackers(trackers: trackerStore.getTrackers())
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
//    private func getCategoryIndex(categoryName: String) -> Int? {
//        var trackerCategoryIndex: Int?
//        for (index, category) in categories.enumerated() {
//            if(categoryName == category.categoryName) {
//                trackerCategoryIndex = index
//                break
//                }
//            }
//
//        return trackerCategoryIndex
//    }
    
    private func linkTrackerToCategory(trackerID: UUID, categoryName: String) -> Bool {
        var newIds: [UUID] = []
        
        // Получаем TrackerCategory
        guard let trackerCategoryRecord = trackerCategoryStore.getCategory(categoryName) else  {
            print("linkTrackerToCategory I have to add category \(categoryName)")
            newIds.append(trackerID)
            return trackerCategoryStore.addCategory(TrackerCategory(trackerIDs: newIds, categoryName: categoryName))
        }
        
        // добавляем в нее trackerIDs
        newIds = trackerCategoryRecord.trackerIDs
        newIds.append(trackerID)
        
        // вызываем Update
        return trackerCategoryStore.updateCategory(TrackerCategory(trackerIDs: newIds, categoryName: categoryName))

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
