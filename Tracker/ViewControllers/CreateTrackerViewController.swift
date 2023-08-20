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
    let tmpColors = [UIColor.ypColorselection1,
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

    // MARK: - Public Properties
    var isEvent = false // Если true, то создаем трекер(привычку) и нужна дата на экране. Иначе создаем нерегулрное событие без кнопки расписание
    var trackersViewController: TrackersViewController?

    // MARK: - Private Properties
    private var label: UITextField?
    private var labelView: UIView?
    private var cancelButton: UIButton?
    private var createButton: UIButton?
    private var tableView: UITableView?
    private var tableItems = ["Категория", "Расписание"]
    private var scheduleDays = ScheduleDays()

    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypWhiteDay
        if isEvent {
            tableItems = ["Категория"]
        }

        self.navigationItem.title = isEvent ? "Новое нерегулярное событие" : "Новая привычка"
        self.navigationController?.navigationBar.titleTextAttributes = [ .font: YFonts.fontYPMedium16]
        
        (labelView, label) = addTrackerNameFied()
        tableView = addCategoryAndSchedule()
        cancelButton = addCancelButton()
        createButton = addCreateButton()
    }

    // MARK: - Public Methods
    
    func updateSchedulerCelltext() {
        let cellIndex = 1
        
        guard let tableView = tableView else { return }
        let cell = tableView.cellForRow(at: IndexPath(row: cellIndex, section: 0))
        
        guard let cell = cell else {return}
        setupCell(cell: cell, cellIndex: cellIndex)
    }

    // MARK: - IBAction
    
    @IBAction private func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
        return
    }
    
    @IBAction private func createButtonPressed(_ sender: UIButton) {
        guard let label = label else { return }
        // TODO сюда проверку что все поля выбраны алерт надо поставить

        let emojies = ["🍄", "🥦","❤️"]
        
        let newTracker = Tracker(trackerID: UUID(), trackerName: label.text ?? "Без названия",
                                 trackerEmodji: emojies[Int.random(in: 0..<emojies.count)],
                                 trackerColor: tmpColors[Int.random(in: 0..<tmpColors.count)],
                                 trackerScheduleDays: scheduleDays.getActiveDayInScheduleDays())

        // TODO снять заглушку с категорий в 15м спринте
        trackersViewController?.addTracker(tracker: newTracker, trackerCategory: testCategory)
        trackersViewController?.dismiss(animated: true)
        
        return
    }


    // MARK: - Private Methods

    private func presentCreateScheduleViewController() {
        
        let createScheduleViewController = CreateScheduleViewController()
        createScheduleViewController.scheduleDays = scheduleDays
        createScheduleViewController.createTrackerViewController = self
        
        let navigationController = UINavigationController(rootViewController: createScheduleViewController)
        navigationController.modalPresentationStyle = .pageSheet
        self.present(navigationController, animated: true)
    }
    
    private func addTrackerNameFied() -> (UIView?, UITextField?) {
        
        let textBackgroundView = UIView()
        view.addSubview(textBackgroundView)
        
        textBackgroundView.backgroundColor = .ypBackground
        textBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        textBackgroundView.layer.cornerRadius = 16
        textBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        textBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        textBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        textBackgroundView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        let label = UITextField()
        textBackgroundView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.placeholder = "Введите название трекера"
        label.clearsOnBeginEditing = true
        label.keyboardType = .default
        label.clearButtonMode = .whileEditing
        label.textColor = .ypBlackDay
        label.font = YFonts.fontYPMedium17
        label.backgroundColor = .clear
        label.topAnchor.constraint(equalTo: textBackgroundView.topAnchor, constant: 27).isActive = true
        label.leadingAnchor.constraint(equalTo: textBackgroundView.leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: textBackgroundView.trailingAnchor, constant: -16).isActive = true
        
        return (textBackgroundView, label)
    }

    private func addCategoryAndSchedule()-> UITableView? {
        guard let labelView = labelView else { return nil }
        
        let table = UITableView()
        view.addSubview(table)
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.dataSource = self
        table.delegate = self
        table.layer.cornerRadius = 16
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16);
        table.translatesAutoresizingMaskIntoConstraints = false
    
        table.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 27).isActive = true
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        table.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        return table
    }
    
    private func addCancelButton() -> UIButton? {
        
        let cancelButton = UIButton()
        view.addSubview(cancelButton)
        
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.titleLabel?.font = YFonts.fontYPMedium16
        cancelButton.layer.cornerRadius = 19
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.backgroundColor = .ypWhiteDay
        cancelButton.addTarget(self, action: #selector(self.cancelButtonPressed), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints =  false

        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 166).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        return cancelButton
    }
    
    private func addCreateButton() -> UIButton? {
        
        guard let cancelButton = cancelButton else { return nil}
        
        let createButton = UIButton()
        view.addSubview(createButton)
        
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.ypWhiteDay, for: .normal)
        createButton.titleLabel?.font = YFonts.fontYPMedium16
        createButton.layer.cornerRadius = 19
        createButton.backgroundColor = .ypGray
        createButton.addTarget(self, action: #selector(self.createButtonPressed), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints =  false

        createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor,constant: 8).isActive = true
        createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
        createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor).isActive = true
        
        return createButton
    }

    
    private func setupCell(cell: UITableViewCell, cellIndex: Int) {
        
        let firstCellLine = tableItems[cellIndex]
        let secondCellLine = (cellIndex == 0) ? "\n\(testCategory)" : scheduleDays.getScheduleAsTextWithNewLine()
        
        let cellText = NSMutableAttributedString(string: firstCellLine, attributes: [ NSAttributedString.Key.foregroundColor: UIColor.ypBlackDay])
        let secondCellLineAttrString = NSAttributedString(string: secondCellLine, attributes: [ NSAttributedString.Key.foregroundColor: UIColor.ypGray] )
        cellText.append(secondCellLineAttrString)
        
        cell.textLabel?.attributedText = cellText
        cell.textLabel?.font = YFonts.fontYPMedium17
        cell.textLabel?.numberOfLines = 2
        cell.backgroundColor = .ypBackground
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
    }
    
}

extension CreateTrackerViewController: UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  UITableViewCell()
        
        if let reusedCell =  tableView.dequeueReusableCell(withIdentifier: "cell")  {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        setupCell(cell: cell, cellIndex: indexPath.row)

        return cell
    }
}

extension CreateTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
          presentCreateScheduleViewController()
        }
    }

}
