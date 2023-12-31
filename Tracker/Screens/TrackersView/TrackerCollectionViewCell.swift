//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 12.08.2023.
//

import Foundation
import UIKit

class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    var trackersViewController: TrackersViewController?
    var trackerID: UUID?
    var titleLabel: UILabel?
    var daysCompletedLabel: UILabel?
    var completeButton: UIButton?
    var emojiLabel: UILabel?
    var cardTrackerView: UIView?
    var isPinned: Bool?
    
    var tracker: Tracker?
    
    // MARK: - Private Properties
    private var isPressed = false
    private var quantityManagementView: UIView?
    private let analyticsService = AnalyticsService()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cardTrackerView = addCardTrackerView()
        titleLabel = addCardTitle()
        emojiLabel = addEmoji()
        quantityManagementView = addQuantityManagementView()
        daysCompletedLabel = addDaysCompletedLabel()
        completeButton = addCompleteButton()
        
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError(L10n.Base.error)
    }
    
    // MARK: - IBAction
    // нажали кнопку +
    @IBAction private func completButtonTapped(_ sender: UIButton) {
        analyticsService.eventTracker()
        
        guard let trackersVC = trackersViewController,
              let trackerID = trackerID,
              let currentDate = trackersVC.currentDate else { return }
        
        
        if currentDate > Date() {
            let alertText = L10n.Tracker.createDateInTheFuture
            Alert.alertInformation(viewController: trackersVC, text: alertText)
            return
        }
        
        // проверка повторного нажатия
        let isCompleted = trackersVC.isTrackerCompleted(trackerID: trackerID, date: currentDate)
        if isCompleted == false {
            // записываем в TrackerRecord
            guard trackersVC.addTrackerRecord(trackerID: trackerID) else { return }
            //меняем картинку на галочку
            sender.setImage(imageTrackerCellCompleted, for: .normal)
        } else {
            // удаляем запись в TrackerRecod
            guard trackersVC.removeTrackerRecord(trackerID: trackerID, date: currentDate) else { return }
            //меняем картинку на галочку
            sender.setImage(imageTrackerCellPlus, for: .normal)
        }
        
        // обновляем счетчик выполненного трекера
        let daysCompleted: Int = trackersVC.getComletedDays(trackerID: trackerID)
        setDaysCompleted(daysCompleted: daysCompleted)
        return
    }
    
    public func setDaysCompleted(daysCompleted: Int) {
        daysCompletedLabel?.text = L10n.numberOfDays(daysCompleted)
    }
    
    // MARK: - Private Methods
    
    private func addCardTrackerView() -> UIView? {
        let cardTrackerView = UIView()
        cardTrackerView.layer.cornerRadius = 16
        contentView.addSubview(cardTrackerView)
        cardTrackerView.translatesAutoresizingMaskIntoConstraints = false
        cardTrackerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cardTrackerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cardTrackerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cardTrackerView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        return cardTrackerView
    }
    
    private func addCardTitle() -> UILabel? {
        guard let cardTrackerView = cardTrackerView else { return nil }
        
        let titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.font = YFonts.fontYPMedium12
        titleLabel.textColor = .ypWhite
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.bottomAnchor.constraint(equalTo: cardTrackerView.bottomAnchor, constant: -12).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: cardTrackerView.leadingAnchor, constant: 12).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        return titleLabel
    }
    
    private func addEmoji() -> UILabel? {
        guard let cardTrackerView = cardTrackerView else { return nil }
        
        let emojiLabel = UILabel()
        emojiLabel.layer.masksToBounds = true
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.backgroundColor = .ypWhite30
        emojiLabel.textAlignment = .center
        emojiLabel.font = YFonts.fontYPMedium12
        contentView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.topAnchor.constraint(equalTo: cardTrackerView.topAnchor, constant: 12).isActive = true
        emojiLabel.leadingAnchor.constraint(equalTo: cardTrackerView.leadingAnchor, constant: 12).isActive = true
        emojiLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        emojiLabel.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return emojiLabel
    }
    
    private func addQuantityManagementView() -> UIView? {
        guard let cardTrackerView = cardTrackerView else { return nil }
        
        let quantityManagementView = UIView()
        quantityManagementView.backgroundColor = .clear // .ypWhiteDay
        contentView.addSubview(quantityManagementView)
        quantityManagementView.translatesAutoresizingMaskIntoConstraints = false
        quantityManagementView.topAnchor.constraint(equalTo: cardTrackerView.bottomAnchor).isActive = true
        quantityManagementView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        quantityManagementView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        quantityManagementView.heightAnchor.constraint(equalToConstant: 58).isActive = true
        return quantityManagementView
    }
    
    private func addDaysCompletedLabel() -> UILabel? {
        guard let quantityManagementView = quantityManagementView else { return nil }
        
        let daysCompletedLabel = UILabel()
        daysCompletedLabel.backgroundColor = .clear
        daysCompletedLabel.font = YFonts.fontYPMedium12
        daysCompletedLabel.textColor = .ypBlackDay
        contentView.addSubview(daysCompletedLabel)
        daysCompletedLabel.translatesAutoresizingMaskIntoConstraints = false
        daysCompletedLabel.topAnchor.constraint(equalTo: quantityManagementView.topAnchor, constant: 16).isActive = true
        daysCompletedLabel.leadingAnchor.constraint(equalTo: quantityManagementView.leadingAnchor, constant: 12).isActive = true
        daysCompletedLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        daysCompletedLabel.widthAnchor.constraint(equalToConstant: 101).isActive = true
        return daysCompletedLabel
    }
    
    private func addCompleteButton() ->UIButton? {
        guard let quantityManagementView = quantityManagementView else { return nil }
        
        let completeButton = UIButton()
        completeButton.addTarget(self, action: #selector(self.completButtonTapped), for: .touchUpInside)
        contentView.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.topAnchor.constraint(equalTo: quantityManagementView.topAnchor, constant: 8).isActive = true
        completeButton.trailingAnchor.constraint(equalTo: quantityManagementView.trailingAnchor, constant: -12).isActive = true
        completeButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        completeButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        return completeButton
    }
    
}

