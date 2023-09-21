//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 10.08.2023.
//

import Foundation
import UIKit

final class CreateTrackerViewController: UIViewController {
    // MARK: - Constants
    let cellColors = [UIColor.ypColorselection1,
                      UIColor.ypColorselection2,
                      UIColor.ypColorselection3,
                      UIColor.ypColorselection4,
                      UIColor.ypColorselection5,
                      UIColor.ypColorselection6,
                      UIColor.ypColorselection7,
                      UIColor.ypColorselection8,
                      UIColor.ypColorselection9,
                      UIColor.ypColorselection10,
                      UIColor.ypColorselection11,
                      UIColor.ypColorselection12,
                      UIColor.ypColorselection13,
                      UIColor.ypColorselection14,
                      UIColor.ypColorselection15,
                      UIColor.ypColorselection16,
                      UIColor.ypColorselection17,
                      UIColor.ypColorselection18,
    ]
    let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    let emojiCellId = "EmojiCell"
    let colorCellId = "ColorCell"
    
    // MARK: - Public Properties
    
    var trackersViewController: TrackersViewController?
    
    private (set) var tableItems = [L10n.CreateTracker.Category.buttonName]
    
    // MARK: - IBOutlet
    
    // MARK: - Private Properties
    // TODO: убрать isEvent в  конструктор тоже
    var isEvent = false // Если true, то создаем трекер(привычку) и нужна дата на экране. Иначе создаем нерегулрное событие без кнопки расписание
    private var isEdit = false // Если true, то это режим редактирования трекера
    
    private var tracker: Tracker?
    
    private var labelCompletedDays: UILabel?
    private var label: UITextField?
    private var labelView: UIView?
    private var tableView: UITableView?
    private var emojiLabel: UILabel?
    private var emojiCollectionsView: UICollectionView?
    private var colorLabel: UILabel?
    private var colorCollectionsView: UICollectionView?
    
    private var cancelButton: UIButton?
    private var createButton: UIButton?
    
    
    private let scheduleDays = ScheduleDays()
    private var emojiViewControllerDelegate: EmojiViewControllerDelegate?
    private var colorViewControllerDelegate: ColorViewControllerDelegate?
    
    private let scrollView = UIScrollView()
    
    private var categoryName: String = "" {
        didSet {
            let cellIndex = 0 // категория в первой строке таблицы у нас
            guard let tableView = tableView else { return }
            let cell = tableView.cellForRow(at: IndexPath(row: cellIndex, section: 0))
            
            guard let cell = cell else {return}
            setupCell(cell: cell, cellIndex: cellIndex)
            
            changeFieldValueEvent()
        }
    }
    
    convenience init() {
        self.init( isEdit: false, tracker: Tracker())
    }
    
    init( isEdit: Bool, tracker: Tracker) {
        super.init(nibName: nil, bundle: nil)
        self.isEdit = isEdit
        self.tracker = tracker
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let tracker = tracker else { return }
        
        view.backgroundColor = .ypWhiteDay
        
        if !isEvent { // добавим возможность выбора рассписания в трекер
            tableItems.append(L10n.CreateTracker.Scheduler.buttonName)
        }
        
        let createTracerTitle = isEvent ? L10n.CreateTracker.Scheduler.title : L10n.CreateTracker.title
        let editTracerTitle = isEvent ? L10n.EditTracker.Scheduler.title : L10n.EditTracker.title
        
        self.navigationItem.title = isEdit ? editTracerTitle : createTracerTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ .font: YFonts.fontYPMedium16]
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        if isEdit {
            labelCompletedDays = addLabelCompletedDays()
        }
        (labelView, label) = addTrackerNameFied()
        tableView = addCategoryAndSchedule()
        
        emojiLabel = addEmojiTextLabel()
        emojiViewControllerDelegate  = EmojiViewControllerDelegate(createTrackerViewController: self)
        emojiCollectionsView = addEmojiCollectionsView()
        
        colorLabel = addColorTextLabel()
        colorViewControllerDelegate = ColorViewControllerDelegate(createTrackerViewController: self)
        colorCollectionsView = addColorCollectionsView()
        
        cancelButton = addCancelButton()
        createButton = addCreateButton()
        
        changeFieldValueEvent()  // задизайблим кнопку Создать
        
        if isEdit { // заполним поля экрана из трекере
            label?.text = tracker.trackerName
            categoryName = tracker.trackerCategoryName
            scheduleDays.setActiveDays(tracker: tracker)
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let emojiCollectionsView = emojiCollectionsView,
              let colorCollectionsView = colorCollectionsView,
              let tracker = tracker else { return }
        
        let emojiIndex = !isEdit ? 0 : (emojis.firstIndex(of: tracker.trackerEmodji) ?? 0)
        selectItemInCollection(collection: emojiCollectionsView, index: emojiIndex)
        
        let colorIndex = !isEdit ? 0 : (cellColors.firstIndex(where: {$0.toHex == tracker.trackerColor.toHex}) ?? 0)
        selectItemInCollection(collection: colorCollectionsView, index: colorIndex)
    }
    
    // MARK: - Public Methods
    
    
    func getCountColors() -> Int {
        return cellColors.count
    }
    
    func getCountEmojis() -> Int {
        return emojis.count
    }
    
    func updateSchedulerCelltext() {
        let cellIndex = 1
        
        guard let tableView = tableView else { return }
        let cell = tableView.cellForRow(at: IndexPath(row: cellIndex, section: 0))
        
        guard let cell = cell else {return}
        setupCell(cell: cell, cellIndex: cellIndex)
    }
    
    func changeFieldValueEvent() {
        guard let label = label,
              let trackerName = label.text,
              trackerName != "",
              categoryName != "",
              (getSelectedEmoji() != nil),
              (getSelectedColor() != nil)
        else {
            // выключаем кнопку
            createButton?.backgroundColor = .ypGray
            createButton?.isEnabled = false
            return
        }
        
        // включаем кнопку
        createButton?.backgroundColor = .ypBlackDay
        createButton?.isEnabled = true
    }
    
    func setCategoryName(name: String) {
        categoryName = name
    }
    
    func presentCreateScheduleViewController() {
        
        let createScheduleViewController = CreateScheduleViewController()
        createScheduleViewController.scheduleDays = scheduleDays
        
        createScheduleViewController.createTrackerViewController = self
        
        let navigationController = UINavigationController(rootViewController: createScheduleViewController)
        navigationController.modalPresentationStyle = .pageSheet
        self.present(navigationController, animated: true)
    }
    
    func presentSelectGroupViewController() {
        
        let selectGroupViewController = SelectGroupViewController()
        selectGroupViewController.setCurrentCategory(name: categoryName)
        selectGroupViewController.selectGroupViewModel.initViewModel(createTrackerViewController: self)
        
        let navigationController = UINavigationController(rootViewController: selectGroupViewController)
        navigationController.modalPresentationStyle = .pageSheet
        self.present(navigationController, animated: true)
    }
    
    func setupCell(cell: UITableViewCell, cellIndex: Int) {
        
        let firstCellLine = tableItems[cellIndex]
        let secondCellLine = (cellIndex == 0) ? getCategoryeAsTextWithNewLine() : scheduleDays.getScheduleAsTextWithNewLine()
        
        let cellText = NSMutableAttributedString(string: firstCellLine, attributes: [ NSAttributedString.Key.foregroundColor: UIColor.ypBlackDay])
        let secondCellLineAttrString = NSAttributedString(string: secondCellLine, attributes: [ NSAttributedString.Key.foregroundColor: UIColor.ypGray] )
        cellText.append(secondCellLineAttrString)
        
        cell.textLabel?.attributedText = cellText
        
        cell.textLabel?.font = YFonts.fontYPRegular17
        cell.textLabel?.numberOfLines = 2
        cell.backgroundColor = .ypBackground
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
    }
    
    // MARK: - IBAction
    @IBAction private func labelTextChanged(_ sender: UIButton) {
        self.changeFieldValueEvent()
        return
    }
    
    @IBAction private func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
        return
    }
    
    @IBAction private func createButtonPressed(_ sender: UIButton) {
        guard let trackerName = label?.text,
              let selectedEmoji = getSelectedEmoji(),
              let selectedColor = getSelectedColor(),
              let trackersViewController = trackersViewController,
              let tracker = tracker else { return }
        
        // tracker создается в конструкторе. Или это трекер который надо редактировать или просто пустой, если у нас создание трекера
        let newTracker = Tracker(tracker: tracker,
                                 trackerName: trackerName,
                                 trackerEmodji: selectedEmoji,
                                 trackerColor: selectedColor,
                                 trackerScheduleDays: scheduleDays.getActiveDayInScheduleDays(),
                                 trackerCategoryName: categoryName,
                                 isPinned: tracker.isPinned)
        
        if isEdit {
            trackersViewController.updateTracker(tracker: newTracker)
        } else {
            trackersViewController.addTracker(tracker: newTracker)
        }
        dismiss(animated: true)
        
        return
    }
    
    
    
    // MARK: - Private Methods
    private func getSelectedEmoji() -> String? {
        guard let emojiCollectionsView = emojiCollectionsView,
              let indexPath = emojiCollectionsView.indexPathsForSelectedItems?.first else { return  nil }
        
        let cell = emojiCollectionsView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
        return cell?.titleLabel.text
    }
    
    private func getSelectedColor() -> UIColor? {
        guard let colorCollectionsView = colorCollectionsView,
              let indexPath = colorCollectionsView.indexPathsForSelectedItems?.first else { return  nil }
        
        let cell = colorCollectionsView.cellForItem(at: indexPath) as? ColorsCollectionViewCell
        return cell?.colorView.backgroundColor
    }
    
    private func selectItemInCollection(collection: UICollectionView, index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collection.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        collection.delegate?.collectionView?(collection, didSelectItemAt: indexPath)
    }
    
    private func addEmojiTextLabel() -> UILabel? {
        guard let tableView = tableView else { return nil }
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Emoji"
        label.textColor = .ypBlackDay
        label.font = YFonts.fontYPBold19
        label.backgroundColor = .clear
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28).isActive = true
        return label
    }
    
    
    private func addEmojiCollectionsView() -> UICollectionView? {
        guard let emojiLabel = emojiLabel else { return nil }
        
        let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        scrollView.addSubview(emojiCollectionView)
        
        emojiCollectionView.dataSource = emojiViewControllerDelegate
        emojiCollectionView.delegate = emojiViewControllerDelegate
        emojiCollectionView.isScrollEnabled = false
        
        emojiCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: emojiCellId)
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        emojiCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true;
        emojiCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true;
        emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor).isActive = true;
        emojiCollectionView.heightAnchor.constraint(equalToConstant: 204).isActive = true;
        emojiCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true;
        
        
        return emojiCollectionView
    }
    
    private func addColorTextLabel() -> UILabel? {
        guard let emojiCollectionsView = emojiCollectionsView else { return nil }
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Цвет"
        label.textColor = .ypBlackDay
        label.font = YFonts.fontYPBold19
        label.backgroundColor = .clear
        scrollView.addSubview(label)
        label.topAnchor.constraint(equalTo: emojiCollectionsView.bottomAnchor, constant: 16).isActive = true
        label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 28).isActive = true
        return label
    }
    
    private func addColorCollectionsView() -> UICollectionView? {
        guard let colorLabel = colorLabel else { return nil }
        
        let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        scrollView.addSubview(colorCollectionView)
        
        colorCollectionView.dataSource = colorViewControllerDelegate
        colorCollectionView.delegate = colorViewControllerDelegate
        colorCollectionView.isScrollEnabled = false
        
        colorCollectionView.allowsMultipleSelection = false
        colorCollectionView.register(ColorsCollectionViewCell.self, forCellWithReuseIdentifier: colorCellId)
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        colorCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true;
        colorCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true;
        colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor).isActive = true;
        colorCollectionView.heightAnchor.constraint(equalToConstant: 204).isActive = true;
        
        return colorCollectionView
    }
    
    private func addLabelCompletedDays() -> UILabel {
        let label = UILabel()
        
        label.font = YFonts.fontYPBold32
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(label)
        label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        label.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        var daysCompleted = 000
        if let trackersViewController = trackersViewController,
           let tracker = tracker {
            daysCompleted = trackersViewController.getComletedDays(trackerID: tracker.trackerID)
        }
        label.text = L10n.numberOfDays(daysCompleted)
        
        return label
        
    }
    
    private func addTrackerNameFied() -> (UIView?, UITextField?) {
        
        let textBackgroundView = UIView()
        textBackgroundView.backgroundColor = .ypBackground
        textBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        textBackgroundView.layer.cornerRadius = 16
        scrollView.addSubview(textBackgroundView)
        let offsetH = isEdit ? 102 : 24
        textBackgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: CGFloat(offsetH)).isActive = true
        textBackgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        textBackgroundView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        textBackgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor,constant: -32).isActive = true
        
        let label = UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.placeholder = L10n.CreateTracker.inputName
        label.clearsOnBeginEditing = true
        label.keyboardType = .default
        label.clearButtonMode = .whileEditing
        label.textColor = .ypBlackDay
        label.font = YFonts.fontYPRegular17
        label.backgroundColor = .clear
        label.addTarget(self, action: #selector(self.labelTextChanged), for: .editingChanged)
        textBackgroundView.addSubview(label)
        label.topAnchor.constraint(equalTo: textBackgroundView.topAnchor, constant: 27).isActive = true
        label.leadingAnchor.constraint(equalTo: textBackgroundView.leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: textBackgroundView.trailingAnchor, constant: -16).isActive = true
        
        return (textBackgroundView, label)
    }
    
    private func addCategoryAndSchedule()-> UITableView? {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        guard let labelView = labelView else { return nil }
        table.dataSource = self
        table.delegate = self
        table.layer.cornerRadius = 16
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16);
        table.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(table)
        table.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 27).isActive = true
        table.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        table.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        table.heightAnchor.constraint(equalToConstant: CGFloat( 75 * tableItems.count)).isActive = true
        table.widthAnchor.constraint(equalTo: scrollView.widthAnchor,constant: -32).isActive = true
        
        return table
    }
    
    private func addCancelButton() -> UIButton? {
        guard  let colorCollectionsView = colorCollectionsView else { return nil}
        let cancelButton = UIButton()
        cancelButton.setTitle(L10n.CreateTracker.buttonCancel, for: .normal)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.titleLabel?.font = YFonts.fontYPMedium16
        cancelButton.layer.cornerRadius = 19
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.backgroundColor = .ypWhiteDay
        cancelButton.addTarget(self, action: #selector(self.cancelButtonPressed), for: .touchUpInside)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints =  false
        
        scrollView.addSubview(cancelButton)
        cancelButton.topAnchor.constraint(equalTo: colorCollectionsView.bottomAnchor, constant: 16).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,constant: 20).isActive = true
        
        let buttonSize =  (view.frame.size.width - 20 - 8 - 20)/2
        cancelButton.widthAnchor.constraint(equalToConstant:  buttonSize).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        return cancelButton
    }
    
    private func addCreateButton() -> UIButton? {
        
        guard let cancelButton = cancelButton,
              let colorCollectionsView = colorCollectionsView else { return nil}
        
        let createButton = UIButton()
        let buttonText = isEdit ? L10n.CreateTracker.buttonSave : L10n.CreateTracker.buttonCreate
        createButton.setTitle(buttonText, for: .normal)
        createButton.setTitleColor(.ypWhiteDay, for: .normal)
        createButton.titleLabel?.font = YFonts.fontYPMedium16
        createButton.layer.cornerRadius = 19
        createButton.addTarget(self, action: #selector(self.createButtonPressed), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints =  false
        
        scrollView.addSubview(createButton)
        
        createButton.topAnchor.constraint(equalTo: colorCollectionsView.bottomAnchor, constant: 16).isActive = true
        createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor,constant: 8).isActive = true
        createButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,constant: -20).isActive = true
        createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor).isActive = true
        createButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor,constant: -20).isActive = true
        
        return createButton
    }
    
    
    func getCategoryeAsTextWithNewLine() -> String {
        
        return  categoryName == "" ? categoryName : ("\n" + categoryName)
    }
    
    
    
}



