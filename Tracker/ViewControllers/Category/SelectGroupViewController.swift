//
//  SelectGroupViewController.swift
//  Tracker
//
//  Created by Vitaly on 31.08.2023.
//

import Foundation
import UIKit

struct SelectCategoryDesign {
    static let tableConerRadius: CGFloat = 16
    static let buttonHeight: CGFloat = 60
    static let cellHeight: CGFloat = 75
    static let separatorIndenXLeft: CGFloat = 16
    static let separatorIndenXRight: CGFloat = 16
    static let separatorHeight: CGFloat = 1
}


final class SelectGroupViewController: UIViewController {
    // MARK: - Public Properties
    //
    var createTrackerViewController: CreateTrackerViewController?
    var selectGroupViewModel = SelectGroupViewModel()
    
    // MARK: - UI elemants
    private var groupsTable:  UITableView = {
        let table = UITableView()
        
        table.layer.cornerRadius = SelectCategoryDesign.tableConerRadius
        table.layer.masksToBounds = true
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    private lazy var noCategoryImageView: UIImageView  = {
        let noCategoryImageView =  UIImageView(image: UIImage(named: "NoTrackers"))
        noCategoryImageView.translatesAutoresizingMaskIntoConstraints = false
        return noCategoryImageView
    }()
    
    private lazy var noCategoryLabel: UILabel = {
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
    
    private lazy var createCategoryButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.titleLabel?.font = YFonts.fontYPMedium16
        button.addTarget(self, action: #selector(buttonCreateNewCategoryTapped), for: .touchUpInside)
        button.backgroundColor = .ypBlackDay
        button.layer.cornerRadius = SelectCategoryDesign.tableConerRadius
        button.layer.masksToBounds = true
        
        return button
    }()
    
    
    @objc private func buttonCreateNewCategoryTapped() {
        selectGroupViewModel.showCreateNewCategoryScreen()
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
            self?.groupsTable.reloadData()
        }
        
        selectGroupViewModel.selectGroupViewController = self
        
        showLogo(true)
    }
    // MARK: - Public Methods
    //
    
    func setCurrentCategory(name: String) {
        selectGroupViewModel.selectedCategory = name
    }
    
    func alert(text: String) {
        Alert.alertInformation(viewController: self, text: text)
    }

    // MARK: Private functions
    private func showLogo(_ uiShow: Bool) {
        noCategoryImageView.isHidden = !uiShow
        noCategoryLabel.isHidden = !uiShow
    }
    
    private func setUpUI() {
        view.addSubview(createCategoryButton)
        NSLayoutConstraint.activate([
            createCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createCategoryButton.heightAnchor.constraint(equalToConstant: SelectCategoryDesign.buttonHeight),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
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
            groupsTable.bottomAnchor.constraint(equalTo: createCategoryButton.topAnchor, constant: -24)
        ])
    }
}




