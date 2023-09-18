//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Vitaly Alekseev on 09.08.2023.
//

import Foundation
import UIKit
enum StatisticParam {
    case bestPeriod
    case idealDaysCount
    case completedTrackersCount
    case completedTrackersCountAverage
}

final class StatisticViewController: UIViewController {
    
    
    private var noDataImageView: UIImageView  = {
        let noCategoryImageView =  UIImageView(image: UIImage(named: "NoData"))
        noCategoryImageView.translatesAutoresizingMaskIntoConstraints = false
        return noCategoryImageView
    }()
    
    private var noDataLabel: UILabel = {
        let noCategoryLabel = UILabel()
        noCategoryLabel.numberOfLines = 0
        noCategoryLabel.text = L10n.Statistic.label
        noCategoryLabel.font = YFonts.fontYPMedium12
        noCategoryLabel.textAlignment = .center
        noCategoryLabel.textColor = .ypBlackDay
        noCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        return noCategoryLabel
    }()
    
    
    private let view1BestPeriod = StatisticCellView()
    private let view2IdealDays = StatisticCellView()
    private let view3TrackersCompleted = StatisticCellView()
    private let view4Average = StatisticCellView()
    
    private let statisticViewPresenter = StatisticViewPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        
        statisticViewPresenter.statisticViewController = self
        
        self.navigationController?.navigationBar.topItem?.title = L10n.Statistic.title
        self.navigationController?.navigationBar.largeTitleTextAttributes = [ .font: YFonts.fontYPBold34]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setupCells()
        setupLogo()
        
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view1BestPeriod.addGradient()
        view2IdealDays.addGradient()
        view3TrackersCompleted.addGradient()
        view4Average.addGradient()
        
        statisticViewPresenter.updateStatistic()
    }
    
    func updateStatisticPraram(param: StatisticParam, value: String) {
        switch param {
        case .bestPeriod:
            view1BestPeriod.value = value
        case .idealDaysCount:
            view2IdealDays.value = value
        case .completedTrackersCount:
            view3TrackersCompleted.value = value
        case .completedTrackersCountAverage:
            view4Average.value = value
        }
    }
    
    func showLogo(_ uiShow: Bool) {
        noDataImageView.isHidden = !uiShow
        noDataLabel.isHidden = !uiShow
        
        
        view1BestPeriod.isHidden = uiShow
        view2IdealDays.isHidden = uiShow
        view3TrackersCompleted.isHidden = uiShow
        view4Average.isHidden = uiShow
    }
    
    private func setupCells() {
        
        //view1BestPeriod.value = "6"
        view1BestPeriod.label = L10n.Statistic.bestPeriod
        view.addSubview(view1BestPeriod)
        NSLayoutConstraint.activate([
            view1BestPeriod.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 77),
            view1BestPeriod.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            view1BestPeriod.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            view1BestPeriod.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        
        //view2IdealDays.value = "2"
        view2IdealDays.label =  L10n.Statistic.idealDays
        view.addSubview(view2IdealDays)
        NSLayoutConstraint.activate([
            view2IdealDays.topAnchor.constraint(equalTo: view1BestPeriod.bottomAnchor, constant: 12),
            view2IdealDays.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            view2IdealDays.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            view2IdealDays.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        
        view3TrackersCompleted.label =  L10n.Statistic.trackersCompleted
        view.addSubview(view3TrackersCompleted)
        NSLayoutConstraint.activate([
            view3TrackersCompleted.topAnchor.constraint(equalTo: view2IdealDays.bottomAnchor, constant: 12),
            view3TrackersCompleted.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            view3TrackersCompleted.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            view3TrackersCompleted.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        
        view4Average.label =  L10n.Statistic.average
        view.addSubview(view4Average)
        NSLayoutConstraint.activate([
            view4Average.topAnchor.constraint(equalTo: view3TrackersCompleted.bottomAnchor, constant: 12),
            view4Average.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            view4Average.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            view4Average.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func setupLogo() {
        view.addSubview(noDataImageView)
        NSLayoutConstraint.activate([
            noDataImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 345),
            noDataImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(noDataLabel)
        NSLayoutConstraint.activate([
            noDataLabel.topAnchor.constraint(equalTo: noDataImageView.bottomAnchor),
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
