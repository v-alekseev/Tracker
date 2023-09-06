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
    private var createGroupViewModel = CreateGroupViewModel()

    
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
        label.placeholder = "Введите название категории"
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
        button.setTitle("Добавить категорию", for: .normal)
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
        
        self.navigationItem.title = "Новая категория"
        self.navigationController?.navigationBar.titleTextAttributes = [ .font: YFonts.fontYPMedium16]
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        view.backgroundColor = .ypWhiteDay
        
        setUpUI()
    }
    
    // MARK: Private functions
    
    @objc private func buttonCreateCategoryTapped() {
        guard let text = categoryNameTextView.text else { return }
        
        if createGroupViewModel.addCategory(name:  text) == false {
            Alert.alertInformation(viewController: self, text: "Ошибка создания категории") }

        dismiss(animated: true)
    }
    
    @objc private func labelTextChanged() {
        guard let text = categoryNameTextView.text else { return }
        
        createGroupButton.isEnabled = !text.isEmpty
        createGroupButton.backgroundColor = text.isEmpty ? .ypGray : .ypBlackDay
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
