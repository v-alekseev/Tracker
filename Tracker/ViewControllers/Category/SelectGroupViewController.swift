//
//  SelectGroupViewController.swift
//  Tracker
//
//  Created by Vitaly on 31.08.2023.
//

import Foundation
import UIKit


final class SelectGroupViewController: UIViewController {
    
    // MARK: public properties
    var i = 0
    var createTrackerViewController: CreateTrackerViewController?
    
    var selectGroupViewModel = SelectGroupViewModel()
    
    // MARK: - UI elemants
    //private var createNewGroupButton = UIButton()
    private var groupsTable:  UITableView = {
        let table = UITableView()
        
        //table.backgroundColor = .ypBlue
        table.layer.cornerRadius = 16
        table.layer.masksToBounds = true
        //table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16);
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    lazy private var noCategoryImageView: UIImageView  = {
        let noCategoryImageView =  UIImageView(image: UIImage(named: "NoTrackers"))
        noCategoryImageView.translatesAutoresizingMaskIntoConstraints = false
        return noCategoryImageView
    }()
    
    lazy private var noCategoryLabel: UILabel = {
        let noCategoryLabel = UILabel()
        noCategoryLabel.numberOfLines = 0
        noCategoryLabel.text = """
Привычки и события можно
объединить по смыслу
"""
        noCategoryLabel.font = YFonts.fontYPMedium12
        noCategoryLabel.textAlignment = .center
        noCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        return noCategoryLabel
    }()
    
    lazy var createGroupButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.titleLabel?.font = YFonts.fontYPMedium16
        button.addTarget(self, action: #selector(buttonCreateNewCategoryTapped), for: .touchUpInside)
        button.backgroundColor = .ypBlackDay
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        return button
    }()
    
    
    @objc func buttonCreateNewCategoryTapped() {
        print("CREATE")
        let createGroupViewController = CreateGroupViewController(isUpdateAction: false)
        
        createGroupViewController.selectGroupViewModel = self.selectGroupViewModel
        
        let navigationController = UINavigationController(rootViewController: createGroupViewController)
        navigationController.modalPresentationStyle = .pageSheet
        self.present(navigationController, animated: true)
    }
    
    func setCurrentCategory(name: String) {
        selectGroupViewModel.selectedCategory = name
    }
    
    // MARK: - UIViewController(*)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Категория"
        self.navigationController?.navigationBar.titleTextAttributes = [ .font: YFonts.fontYPMedium16]
        
        view.backgroundColor = .ypWhiteDay
        
        groupsTable.dataSource = self
        groupsTable.delegate = self
        groupsTable.register(SelectGroupTableViewCell.self, forCellReuseIdentifier: SelectGroupTableViewCell.cellID)
        
        setUpUI()
        
        selectGroupViewModel.$categories.bind { [weak self]  in
            print("groupsTable.reloadData() index =\(self!.i)")
            self!.i = self!.i + 1
            self?.groupsTable.reloadData()
        }
        
        selectGroupViewModel.selectGroupViewController = self
        
        showLogo(true)
    }
    
    // MARK: Private functions
    func alert(text: String) {
        Alert.alertInformation(viewController: self, text: text)
    }
    
    func showLogo(_ uiShow: Bool) {
        noCategoryImageView.isHidden = !uiShow
        noCategoryLabel.isHidden = !uiShow
    }
    
    private func setUpUI() {
        
        view.addSubview(createGroupButton)
        NSLayoutConstraint.activate([
            createGroupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createGroupButton.heightAnchor.constraint(equalToConstant: 60),
            createGroupButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createGroupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createGroupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        view.addSubview(noCategoryImageView)
        NSLayoutConstraint.activate([
            noCategoryImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 345),
            noCategoryImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(noCategoryLabel)
        NSLayoutConstraint.activate([
            noCategoryLabel.topAnchor.constraint(equalTo: noCategoryImageView.bottomAnchor),
            noCategoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(groupsTable)
        
        NSLayoutConstraint.activate([
            groupsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            groupsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            groupsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            groupsTable.bottomAnchor.constraint(equalTo: createGroupButton.topAnchor, constant: -24)
        ])
        
    }
    
}

extension SelectGroupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectGroupViewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cellForRowAt index = \(indexPath.row)")
        var cell =  SelectGroupTableViewCell()
        
        if let reusedCell =  tableView.dequeueReusableCell(withIdentifier: SelectGroupTableViewCell.cellID) as? SelectGroupTableViewCell {
            cell = reusedCell
        }
        
        cell.textLabel?.text = selectGroupViewModel.categories[indexPath.row];
        
        cell.textLabel?.font = YFonts.fontYPRegular17
        cell.backgroundColor = .ypBackground
        if(indexPath.row == selectGroupViewModel.categories.firstIndex(of: selectGroupViewModel.selectedCategory)) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    
         
        if indexPath.row == 0 { //это первая ячейка
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        if indexPath.row == selectGroupViewModel.categories.count - 1 {  // это последняя ячейка
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            cell.separator.isHidden = true
        }
        
//        cell.layer.borderWidth = 1
//        cell.layer.borderColor = UIColor.red.cgColor
//        cell.layer.masksToBounds = true
        
        cell.separator.frame.size = CGSize(width:  tableView.frame.width - 16 - 16, height: 1)
        cell.separator.frame.origin = CGPoint(x: 16, y: 75 - 1)
        
        print("Separator cell.bounds = \(cell.bounds),  cell.frame = \(cell.frame), seperaor.frame = \(cell.separator.frame), tableView.frame.width = \(tableView.frame.width)")
        
        
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension SelectGroupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let createTrackerViewController = createTrackerViewController else { return }
        createTrackerViewController.setCategoryName(name: selectGroupViewModel.categories[indexPath.row])
        
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        let menu = UIContextMenuConfiguration(identifier: nil,
                                              previewProvider: nil,
                                              actionProvider: { [weak self] suggestedActions in
            let duplicateAction = UIAction(title: NSLocalizedString("Редактировать", comment: ""), image: nil) { action in
                print("EDIT")
                guard let self = self else { return }
                
                let categoryName = self.selectGroupViewModel.categories[indexPath.row]
                
                let createGroupViewController = CreateGroupViewController(isUpdateAction: true, currentCategory: categoryName)
                createGroupViewController.selectGroupViewModel = self.selectGroupViewModel
                
                let navigationController = UINavigationController(rootViewController: createGroupViewController)
                navigationController.modalPresentationStyle = .pageSheet
                self.present(navigationController, animated: true)
            }
            
            let deleteAction = UIAction(title: NSLocalizedString("Удалить", comment: ""), image: nil, attributes: .destructive) { action in
                
                print("DELETE")
                guard let categoryName = self?.selectGroupViewModel.categories[indexPath.row] else { return }
                if self?.selectGroupViewModel.deleteCategory(name: categoryName) == false {
                    self?.alert(text: "Ошибка удаления категории. Пожалуйста, сначала удалите все трекеры в этой категории.")
                }
            }
            
            return UIMenu(title: "", children: [duplicateAction, deleteAction])
        })
        
        return menu
    }
    
}
