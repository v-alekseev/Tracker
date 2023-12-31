//
//  EditGroupViewController.swift
//  Tracker
//
//  Created by Vitaly on 05.09.2023.
//

import Foundation
import UIKit

final class EditCategoryViewController: UIViewController {
    // MARK: - Private Properties
    //
    private let editCategoryViewModel = EditCategoryViewModel()
    
    // MARK: - UIViewController(*)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = L10n.EditCategoryScreen.title //"Редактирование категории" // "editCategoryScreen.title"
        self.navigationController?.navigationBar.titleTextAttributes = [ .font: YFonts.fontYPMedium16]
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        view.backgroundColor = .ypWhiteDay
        view.addTapGestureToHideKeyboard()
        
        editCategoryViewModel.$newCategoryName.bind { [weak self]  in
            guard let self = self else { return }
            self.createGroupButton.isEnabled = !self.editCategoryViewModel.newCategoryName.isEmpty
            self.createGroupButton.backgroundColor = self.editCategoryViewModel.newCategoryName.isEmpty ? .ypGray : .ypBlackDay
        }
        
        editCategoryViewModel.$isRenameSuccsesed.bind { [weak self]  in
            guard let self = self else { return }
            if(editCategoryViewModel.isRenameSuccsesed == false) {
                Alert.alertInformation(viewController: self, text: L10n.EditCategoryScreen.errorEdit) {[weak self] _ in
                    self?.dismiss(animated: true)
                    return
                }
            } else {
                self.dismiss(animated: true)
            }
        }
        setUpUI()
    }
    
    // MARK: - Initializers
    //
    init(currentCategory: String) {
        editCategoryViewModel.currentCategoryName = currentCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(L10n.Base.error)
    }
    
    // MARK: - UI elements
    lazy private var categoryNameTextView: UITextField = {
        let label = UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.placeholder = L10n.EditCategoryScreen.placeholder
        label.clearsOnBeginEditing = true
        label.keyboardType = .default
        label.clearButtonMode = .whileEditing
        label.textColor = .ypBlackDay
        label.font = YFonts.fontYPRegular17
        label.backgroundColor = .clear
        label.text = editCategoryViewModel.currentCategoryName
        
        label.addTarget(self, action: #selector(self.labelTextChanged), for: .editingChanged)
        
        return label
    }()
    
    lazy var createGroupButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(L10n.EditCategoryScreen.buttonAdd, for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.titleLabel?.font = YFonts.fontYPMedium16
        button.addTarget(self, action: #selector(buttonCreateCategoryTapped), for: .touchUpInside)
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.isEnabled = false
        
        return button
    }()
    
    let textBackgroundView: UIView = {
        let textBackgroundView = UIView()
        textBackgroundView.backgroundColor = .ypBackground
        textBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        textBackgroundView.layer.cornerRadius = 16
        return textBackgroundView
    }()
    
    // MARK: - IBAction
    //
    @objc private func buttonCreateCategoryTapped() {
        editCategoryViewModel.renameCategory()
    }
    
    @objc private func labelTextChanged() {
        guard let text = categoryNameTextView.text else { return }
        editCategoryViewModel.newCategoryName = text
    }
    // MARK: - Public Methods
    //
    
    // MARK: - Private Methods
    //
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
