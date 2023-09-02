//
//  SelectGroupViewController.swift
//  Tracker
//
//  Created by Vitaly on 31.08.2023.
//

import Foundation
import UIKit


final class SelectGroupViewController: UIViewController {
    
    
    // MARK: Constans
    private let cellID = "cell"
    // MARK: public properties
    var createTrackerViewController: CreateTrackerViewController?
    
    var selectGroupViewModel = SelectGroupViewModel()
    
    // MARK: - UI elemants
    //private var createNewGroupButton = UIButton()
    private var groupsTable:  UITableView = {
        let table = UITableView()

        table.layer.cornerRadius = 16
        table.layer.masksToBounds = true
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16);
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
        print("buttonCreateNewCategoryTapped")
        let createGroupViewController = CreateGroupViewController(isUpdateAction: false)
        
        createGroupViewController.selectGroupViewModel = self.selectGroupViewModel

//        self.navigationItem.setHidesBackButton(true, animated: true)
//        self.navigationController?.pushViewController(createGroupViewController, animated: true)
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
        groupsTable.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        //groupsTable.backgroundColor = .red

        setUpUI()
        
        selectGroupViewModel.$categories.bind { [weak self]  in
            print("observable $categories changed")
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
 
        //collectionView?.isHidden = uiShow
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
            //groupsTable.heightAnchor.constraint(equalToConstant: CGFloat( 75 * tableItems.count)),
           // groupsTable.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -32)
        ])
        
    }
    
}



extension SelectGroupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectGroupViewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  UITableViewCell()
        
        if let reusedCell =  tableView.dequeueReusableCell(withIdentifier: cellID)  {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        
        cell.textLabel?.text = selectGroupViewModel.categories[indexPath.row];
        
        cell.textLabel?.font = YFonts.fontYPRegular17
        cell.backgroundColor = .ypBackground
        if(indexPath.row == selectGroupViewModel.categories.firstIndex(of: selectGroupViewModel.selectedCategory)) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.selectionStyle = .none

        return cell
    }
}

extension SelectGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Categories pressed")
        
        guard let createTrackerViewController = createTrackerViewController else { return }
        createTrackerViewController.setCategoryName(name: selectGroupViewModel.categories[indexPath.row])
        
        //createTrackerViewController.updateGroupCelltext()
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                            contextMenuConfigurationForRowAt indexPath: IndexPath,
                            point: CGPoint) -> UIContextMenuConfiguration? {
        
        let menu = UIContextMenuConfiguration(identifier: nil,
                                              previewProvider: nil,
                                          actionProvider: { [weak self] suggestedActions in
            let duplicateAction = UIAction(title: NSLocalizedString("Редактировать", comment: ""), image: nil) { action in
                guard let self = self else { return }
                
                let categoryName = self.selectGroupViewModel.categories[indexPath.row]
                
                let createGroupViewController = CreateGroupViewController(isUpdateAction: true, currentCategory: categoryName)
                createGroupViewController.selectGroupViewModel = self.selectGroupViewModel
                
                let navigationController = UINavigationController(rootViewController: createGroupViewController)
                navigationController.modalPresentationStyle = .pageSheet
                self.present(navigationController, animated: true)
                }
            
            
            let deleteAction = UIAction(title: NSLocalizedString("Удалить", comment: ""), image: nil, attributes: .destructive) { action in

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
