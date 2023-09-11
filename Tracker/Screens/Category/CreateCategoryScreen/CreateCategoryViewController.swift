//
//  CreateCategoryViewController.swift
//  Tracker
//
//  Created by Vitaly on 31.08.2023.
//

import Foundation
import UIKit


final class CreateGroupViewController: UIViewController {

    // MARK: public properties
    private let createGroupViewModel = CreateGroupViewModel()

    
    // MARK: - UI elemants
    
    
    let textBackgroundView: UIView = {
        let textBackgroundView = UIView()
        textBackgroundView.backgroundColor = .ypBackground
        textBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        textBackgroundView.layer.cornerRadius = 16
        return textBackgroundView
    }()
    
    lazy private var categoryNameTextView: UITextField = {
        let label = UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.placeholder = L10n.CreateCategoryScreen.placeholder //"Введите название категории" // "createCategoryScreen.placeholder"
        label.clearsOnBeginEditing = true
        label.keyboardType = .default
        label.clearButtonMode = .whileEditing
        label.textColor = .ypBlackDay
        label.font = YFonts.fontYPRegular17
        label.backgroundColor = .clear
        
        label.addTarget(self, action: #selector(self.labelTextChanged), for: .editingChanged)
        
        return label
    }()
    
    lazy var createGroupButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(L10n.CreateCategoryScreen.buttonAdd, for: .normal) // "Добавить категорию"
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.titleLabel?.font = YFonts.fontYPMedium16
        button.addTarget(self, action: #selector(buttonCreateCategoryTapped), for: .touchUpInside)
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - UIViewController(*)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = L10n.CreateCategoryScreen.title //"Новая категория" //
        self.navigationController?.navigationBar.titleTextAttributes = [ .font: YFonts.fontYPMedium16]
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        view.backgroundColor = .ypWhiteDay
        
        setUpUI()
        
        createGroupViewModel.$categoryName.bind { [weak self]  in
            guard let self = self else { return }
            createGroupButton.isEnabled = !createGroupViewModel.categoryName.isEmpty
            createGroupButton.backgroundColor = createGroupViewModel.categoryName.isEmpty ? .ypGray : .ypBlackDay
        }
        
        
        createGroupViewModel.$isAddCategorySuccsesed.bind { [weak self]  in
            guard let self = self else { return }
            if(createGroupViewModel.isAddCategorySuccsesed == false) {
                Alert.alertInformation(viewController: self, text: "Ошибка создания категории")  {[weak self] _ in
                    self?.dismiss(animated: true)
                    return
                }
            } else {
                self.dismiss(animated: true)
            }
        }
    }
    
    // MARK: Private functions
    
    @objc private func buttonCreateCategoryTapped() {
        guard let text = categoryNameTextView.text else { return }
        
        createGroupViewModel.addCategory(name:  text)
    }
    
    @objc private func labelTextChanged() {
        guard let text = categoryNameTextView.text else { return }
        
        createGroupViewModel.categoryName = text

    }
    
    private func setUpUI() {
        
        view.addSubview(textBackgroundView)
        NSLayoutConstraint.activate([
            textBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textBackgroundView.heightAnchor.constraint(equalToConstant: 75),
            textBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -32)
        ])
        
        textBackgroundView.addSubview(categoryNameTextView)
        NSLayoutConstraint.activate([
            categoryNameTextView.topAnchor.constraint(equalTo: textBackgroundView.topAnchor, constant: 27),
            categoryNameTextView.leadingAnchor.constraint(equalTo: textBackgroundView.leadingAnchor, constant: 16),
            categoryNameTextView.trailingAnchor.constraint(equalTo: textBackgroundView.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(createGroupButton)
        NSLayoutConstraint.activate([
            createGroupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createGroupButton.heightAnchor.constraint(equalToConstant: 60),
            createGroupButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createGroupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createGroupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
}
