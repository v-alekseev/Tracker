//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 09.08.2023.
//

import Foundation
import UIKit

extension Dictionary where  Key : Comparable {
    func getKeyByIndex(index: Int) -> Key {
        guard let impotantCategory = impotantCategory as? Key else { return self.keys.sorted()[index]}
        let sortedArray = moveElementToStart(array: self.keys.sorted(), element: impotantCategory)
        return sortedArray[index]
    }
    
    private func moveElementToStart<T: Equatable>( array: [T], element: T) -> [T]  {
        guard  let indexOfElement = array.firstIndex(of: element) else { return array}

        var sortedArray = array
        let element = sortedArray.remove(at: indexOfElement)
        sortedArray.insert(element, at: sortedArray.startIndex)
        
        return sortedArray
    }
}


class TrackersViewController: UIViewController {
    
    // MARK: - Types
    enum LogoType {
        case searchNothing
        case noTrackers
    }
    
    // MARK: - Constants
    let cellId = "TrackerCell"
    
    // MARK: - Public Properties
    var visibleTrackers: [String : [Tracker]] = [:]
    var collectionView: UICollectionView?
    

    private (set) var currentDate: Date? = Date()
    private (set) var trackerStore = TrackerStore()
    private (set) var trackerRecordStore = TrackerRecordStore()
    private (set) var trackerCategoryStore = TrackerCategoryStore()
    
    // MARK: - Private Properties
    private var logoImageView: UIImageView?
    private var logoLabel: UILabel?
    private var datePicker: UIDatePicker?
    private var filterButton: UIButton?
    private var currentFilter: Filter = Filter.all

    
    // MARK: - UIViewController(*)
    override func viewDidLoad() {
        super.viewDidLoad()
        trackerStore.delegate = self
        
        setupNavigationBar()
        logoImageView = addDefaultImageView()
        logoLabel = addDefaultLabel()
        collectionView = addTrackersCollectionsView()
        filterButton = addFilterButton()
        
        currentDate = Date().startOfDay() //  getCurrentDate(incomingDate: Date())
        visibleTrackers = getVisibleTrackers(trackers: trackerStore.getTrackers())
        
        showLogo(visibleTrackers.count == 0)
        
        
        //trackerStore.getCompletedTrackersAtDay(onDate: currentDate!)

    }
    
    // MARK: - Public Methods
    
    private func setupNavigationBar() {
        guard let navBar = navigationController?.navigationBar else  { return }
        
        self.view.backgroundColor = .ypWhiteDay
 
        navBar.topItem?.title = L10n.Tracker.title  //NSLocalizedString("tracker.title", comment: "") // "Трекеры"  // LOCAL: tracker.title
        navBar.largeTitleTextAttributes = [ .font: YFonts.fontYPBold34]
        navBar.prefersLargeTitles = true
        
        
        // Добавляем +
        let leftButton = UIBarButtonItem(image: UIImage(named: "AddTracker"), style: .plain, target: self, action: #selector(addNewTrackerButtonTap))
        leftButton.tintColor = .black
        navBar.topItem?.setLeftBarButton(leftButton, animated: false)
        navBar.topItem?.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
        // добавляем строку поиска
        let seachController = UISearchController()  //
        seachController.hidesNavigationBarDuringPresentation = false
        seachController.searchResultsUpdater = self
        self.navigationItem.searchController = seachController
        
        // добавляем DatePicker
        datePicker = UIDatePicker()
        guard let datePicker = datePicker  else { return }
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.didChangeDate), for: .valueChanged)
        let rightButton = UIBarButtonItem(customView: datePicker)
        navBar.topItem?.setRightBarButton(rightButton, animated: false)
    
        view.frame.size.height = 200
    }
    
    func showLogo(_ uiShow: Bool, whichLogo: LogoType = .noTrackers) {
        logoImageView?.isHidden = !uiShow
        logoImageView?.image = (whichLogo == .noTrackers) ? UIImage(named: "NoTrackers") : UIImage(named: "SearchError")
        logoLabel?.isHidden = !uiShow
        let noTrackersText = L10n.Tracker.logoText
        let noNotFoundText = L10n.Tracker.notFound 
        logoLabel?.text = (whichLogo == .noTrackers) ? noTrackersText : noNotFoundText  
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
    
    func setFilter(filter: Filter) {
        
        self.currentFilter = filter
        if(self.currentFilter == .today) {
            datePicker?.setDate(Date(), animated: true)
            self.didChangeDate(self)
            return
        }
    
        visibleTrackers = getVisibleTrackers(trackers: trackerStore.getTrackers())
        if visibleTrackers.count > 0 {
            showLogo(false)
            collectionView?.reloadData()
        }
        else {
            showLogo(true)
        }
    }
    
    
    func isTrackerCompleted(trackerID: UUID, date: Date) -> Bool {
        guard let currentDate = currentDate else { return false }
        return trackerRecordStore.isRecordExist(TrackerRecord(trackerID: trackerID, date: currentDate))
    }
    
    // функция возвращает массив терекеров у которых либо нет рассписания, либо он должен быть показан в выбранную дату (день недели совпадает)
    func getVisibleTrackers(trackers: [Tracker]) ->  [String : [Tracker]] {
        guard let calendar = NSCalendar(identifier: .ISO8601),
              let currentDate = currentDate else { return visibleTrackers }

        var visibleTrackers: [String : [Tracker]] = [:]
        let currentDay = calendar.component(.weekday, from: currentDate)
        
        // фильтр по дате датапикера [Tracker] -> [Tracker]
        let trackersOnDate = trackers.filter {
            if $0.trackerActiveDays.isEmpty { return true }
            if $0.trackerActiveDays.contains(currentDay) { return true }
            return false
        }
        
        // фильтр по фильтрам  [Tracker] -> [Tracker]
//        При выборе «Все трекеры» пользователь видит все трекеры на выбранный день;
//        При выборе «Трекеры на сегодня» ставится текущая дата и пользователь видит все трекеры на этот день;
//        При выборе «Завершенные» пользователь видит привычки, которые были выполнены пользователем в выбранный день;
//        При выборе «Не завершенные» пользователь видит невыполненные трекеры в выбранный день;
        var trackersAtFilters: [Tracker]  = []
        switch(currentFilter) {
        case .all:
            trackersAtFilters = trackersOnDate
        case .today: //  из-за странной логики обработка этого кейса
            trackersAtFilters = trackersOnDate
        case .completed:
            trackersAtFilters = trackerStore.getCompletedTrackersAtDay(onDate: currentDate)
        case .uncompleted:
            var completedTrackers = trackerStore.getCompletedTrackersAtDay(onDate: currentDate).map {$0.trackerID}
            trackersAtFilters = trackersOnDate.compactMap { !completedTrackers.contains($0.trackerID) ? $0 : nil }
        }
        
        // create visibleTrackers from  [Tracker] -> [String : [Tracker]]
        for tracker in trackersAtFilters {
            let category = tracker.isPinned ? impotantCategory : tracker.trackerCategoryName
            if visibleTrackers[category] == nil {
                    visibleTrackers[category] = []
                }
            visibleTrackers[category]?.append(tracker)
        }

        return visibleTrackers
    }
    
    func addTrackerRecord(trackerID: UUID) -> Bool {
        guard let currentDate = currentDate else { return false }
        return trackerRecordStore.addRecord(TrackerRecord(trackerID: trackerID, date: currentDate))
    }
    
    func removeTrackerRecord(trackerID: UUID, date: Date) -> Bool {
        guard let currentDate = currentDate else { return false }
        return trackerRecordStore.deleteRecord(TrackerRecord(trackerID: trackerID, date: currentDate))
    }
    
    // Обработка нажатия на кнопку Сохранить на форме создания трекера
    func addTracker(tracker: Tracker) {
        if trackerStore.addTracker(tracker) == false {
            Alert.alertInformation(viewController: self, text: L10n.Tracker.errorCreateTracker) //"tracker.error_create_tracker" 
        }
    }
    
    func updateTracker(tracker: Tracker) {
        if trackerStore.updateTracker(tracker) == false {
            Alert.alertInformation(viewController: self, text: L10n.Tracker.errorUpdateTracker) //"tracker.error_create_tracker"
        }
    }
    
    func deleteTracker(trackerID: UUID) {
        if trackerStore.deleteTracker(trackerID) == false {
            Alert.alertInformation(viewController: self, text: L10n.Tracker.errorEditTracker) //"tracker.error_create_tracker"
        }
    }
    
    // сколько дней выполнен трекер
    func getComletedDays(trackerID: UUID) -> Int {
        return trackerRecordStore.getTrackerComletedDays(trackerID: trackerID)
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
        
    @objc
    private func filterButtonPressed() {
        let viewControllerToPresent = SelectFilterViewController()
        viewControllerToPresent.selectFilterViewModel.trackersViewController = self
        viewControllerToPresent.selectFilterViewModel.selectedFilter = currentFilter
        
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true, completion: nil)
        
    }
    
    // выбрали новую дату
    @IBAction private func didChangeDate(_ sender: AnyObject) {
        guard let collectionView = collectionView else { return }
        guard let datePicker = datePicker else { return }

        // костыль для сброса фильтра
        if currentDate != datePicker.date.startOfDay() && currentFilter == .today {
            currentFilter = .all
        }
        
        currentDate =  datePicker.date.startOfDay() // as Date getCurrentDate(incomingDate: datePicker.date as Date)
        
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
       // noTrackersLabel.text = "Что будем отслеживать?"
        noTrackersLabel.font = YFonts.fontYPMedium12
        noTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(noTrackersLabel)
        noTrackersLabel.topAnchor.constraint(equalTo: noTrackersImageView.bottomAnchor).isActive = true
        noTrackersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        return noTrackersLabel
    }
    
    private func addFilterButton() -> UIButton {
        
        let filterButton = UIButton()
        
        filterButton.setTitle(L10n.Tracker.filters, for: .normal)
        filterButton.setTitleColor(.ypWhiteDay, for: .normal)
        filterButton.titleLabel?.font = YFonts.fontYPRegular17
        filterButton.backgroundColor = UIColor.ypBlue
        filterButton.layer.cornerRadius = 16
        filterButton.layer.masksToBounds = true
        filterButton.addTarget(self, action: #selector(self.filterButtonPressed), for: .touchUpInside)
        
        view.addSubview(filterButton)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true;
        filterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 115).isActive = true;
        filterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -114).isActive = true;
       // filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true;
        filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true;
        
        return filterButton
    }
}
