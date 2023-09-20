//
//  SelectFilterViewController.swift
//  Tracker
//
//  Created by Vitaly on 15.09.2023.
//

import Foundation


//
//  SelectGroupViewController.swift
//  Tracker
//
//  Created by Vitaly on 31.08.2023.
//

import Foundation
import UIKit

final class SelectFilterViewController: UIViewController {
    // MARK: - Public Properties
    //
    var selectFilterViewModel = SelectFilterViewModel()
    
    // MARK: - UI elemants
    private var groupsTable:  UITableView = {
        let table = UITableView()
        
        table.layer.cornerRadius = SelectCategoryDesign.tableConerRadius
        table.layer.masksToBounds = true
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()

    // MARK: - UIViewController(*)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title =  L10n.Tracker.filters //"Категория" //"categoryScreen.title"
        self.navigationController?.navigationBar.titleTextAttributes = [ .font: YFonts.fontYPMedium16]
        
        view.backgroundColor = .ypWhiteDay
        
        groupsTable.dataSource = self
        groupsTable.delegate = self
        groupsTable.register(SelectGroupTableViewCell.self, forCellReuseIdentifier: SelectGroupTableViewCell.cellID)
        
        setupUI()
        
        selectFilterViewModel.selectFilterViewController = self
        selectFilterViewModel.$isShouldControllerClose.bind { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    // MARK: - Public Methods
    //
    func alert(text: String) {
        Alert.alertInformation(viewController: self, text: text)
    }

    // MARK: Private functions
    private func setupUI() {
        view.addSubview(groupsTable)
        NSLayoutConstraint.activate([
            groupsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            groupsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            groupsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            groupsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
}

extension SelectFilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Filter.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  SelectGroupTableViewCell()
        
        if let reusedCell =  tableView.dequeueReusableCell(withIdentifier: SelectGroupTableViewCell.cellID) as? SelectGroupTableViewCell {
            cell = reusedCell
        }

        cell.textLabel?.text = selectFilterViewModel.filters[ Filter.allCases[indexPath.row]]
        
        cell.markSelected(indexPath: indexPath.row, selectedIndex: selectFilterViewModel.selectionIndex)
        cell.setupSeparator(tableViewWidth: tableView.frame.width, indexPath: indexPath.row, categoriesCount: Filter.allCases.count)
        cell.setConerRadius(indexPath: indexPath.row, categoriesCount: Filter.allCases.count)

        return cell
    }
}

extension SelectFilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SelectCategoryDesign.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectFilterViewModel.didSelectRow(index: indexPath.row)
    }
    
}
