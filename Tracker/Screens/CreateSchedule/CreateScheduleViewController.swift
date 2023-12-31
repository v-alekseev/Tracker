//
//  CreateScheduleViewController.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 12.08.2023.
//



import Foundation
import UIKit

final class CreateScheduleViewController: UIViewController {
    
    
    // MARK: - Public Properties
    weak var scheduleDays: ScheduleDays?
    var createTrackerViewController: CreateTrackerViewController?
    
    // MARK: - Private Properties
    private var readyButton: UIButton?
    private var scheduleTable: UITableView?
    
    // MARK: - UIViewController(*)
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypWhiteDay
        self.navigationItem.title = L10n.Schedule.title //  "Расписание" //"schedule.title"
        self.navigationController?.navigationBar.titleTextAttributes = [ .font: YFonts.fontYPMedium16]
        
        readyButton = addReadyButton()
        scheduleTable = addScheduleTable()
    }

    // MARK: - IBAction
    @IBAction private func readyButtonTapped(_ sender: UIButton) {
        guard let scheduleDays = scheduleDays else { return }
        
        for cellIndex in 0..<scheduleDays.weekDays.count {
            let cell = scheduleTable?.cellForRow(at: IndexPath(row: cellIndex, section: 0)) //as? CreateScheduleViewCell
            let cellSwitch = cell?.accessoryView as? UISwitch
            
            scheduleDays.weekDays[cellIndex].dayValue = (cellSwitch?.isOn) ?? false
        }
        
        createTrackerViewController?.updateSchedulerCelltext()
        dismiss(animated: true)
        return
    }
    
    // MARK: - Private Methods
    private func addScheduleTable() -> UITableView? {
        let table = UITableView()
        view.addSubview(table)
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.dataSource = self
        table.delegate = self
        table.layer.cornerRadius = 16
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16);
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        table.heightAnchor.constraint(equalToConstant: 75*7).isActive = true
        
        return table
    }
    
    private func addReadyButton() -> UIButton? {
        // первая кнопка
        let readyButton = UIButton()
        view.addSubview(readyButton)
        readyButton.setTitle(L10n.Schedule.buttonCreate, for: .normal) // "schedule.buttonCreate" //"Готово"
        readyButton.setTitleColor(.ypWhiteDay, for: .normal)
        readyButton.titleLabel?.font = YFonts.fontYPMedium16
        readyButton.layer.cornerRadius = 19
        readyButton.backgroundColor = .ypBlackDay
        readyButton.addTarget(self, action: #selector(self.readyButtonTapped), for: .touchUpInside)
        readyButton.translatesAutoresizingMaskIntoConstraints =  false
        
        readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        readyButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        return readyButton
    }
}

extension CreateScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let scheduleDays = scheduleDays else { return 0 }
        return scheduleDays.weekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  UITableViewCell()
        
        if let reusedCell =  tableView.dequeueReusableCell(withIdentifier: "cell") { //as? CreateScheduleViewCell  {
            cell = reusedCell
        }
        guard let scheduleDays = scheduleDays else { return cell}
        
        cell.backgroundColor = .ypBackground
        let switchCell = UISwitch()
        switchCell.onTintColor = .ypBlue
        cell.accessoryView = switchCell
        cell.selectionStyle = .none
        
        cell.textLabel?.text = Locale.current.calendar.weekdaySymbols[scheduleDays.weekDays[indexPath.row].dayIndex]
        switchCell.setOn(scheduleDays.weekDays[indexPath.row].dayValue, animated: true)
        
        return cell
    }
}

extension CreateScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

