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
    
    private let viewBestPeriod = StatisticCellView()
    private let viewIdealDays = StatisticCellView()
    private let viewTrackersCompleted = StatisticCellView()
    private let viewAverage = StatisticCellView()
    
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
        viewBestPeriod.addGradient()
        viewIdealDays.addGradient()
        viewTrackersCompleted.addGradient()
        viewAverage.addGradient()
        
        statisticViewPresenter.updateStatistic()
    }
    
    func updateStatisticPraram(param: StatisticParam, value: String) {
        switch param {
        case .bestPeriod:
            viewBestPeriod.value = value
        case .idealDaysCount:
            viewIdealDays.value = value
        case .completedTrackersCount:
            viewTrackersCompleted.value = value
        case .completedTrackersCountAverage:
            viewAverage.value = value
        }
    }
    
    func showLogo(_ uiShow: Bool) {
        noDataImageView.isHidden = !uiShow
        noDataLabel.isHidden = !uiShow
        
        
        viewBestPeriod.isHidden = uiShow
        viewIdealDays.isHidden = uiShow
        viewTrackersCompleted.isHidden = uiShow
        viewAverage.isHidden = uiShow
    }
    
    private func setupCells() {
        viewBestPeriod.label = L10n.Statistic.bestPeriod
        view.addSubview(viewBestPeriod)
        NSLayoutConstraint.activate([
            viewBestPeriod.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 77),
            viewBestPeriod.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewBestPeriod.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            viewBestPeriod.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        viewIdealDays.label =  L10n.Statistic.idealDays
        view.addSubview(viewIdealDays)
        NSLayoutConstraint.activate([
            viewIdealDays.topAnchor.constraint(equalTo: viewBestPeriod.bottomAnchor, constant: 12),
            viewIdealDays.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewIdealDays.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            viewIdealDays.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        viewTrackersCompleted.label =  L10n.Statistic.trackersCompleted
        view.addSubview(viewTrackersCompleted)
        NSLayoutConstraint.activate([
            viewTrackersCompleted.topAnchor.constraint(equalTo: viewIdealDays.bottomAnchor, constant: 12),
            viewTrackersCompleted.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewTrackersCompleted.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            viewTrackersCompleted.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        viewAverage.label =  L10n.Statistic.average
        view.addSubview(viewAverage)
        NSLayoutConstraint.activate([
            viewAverage.topAnchor.constraint(equalTo: viewTrackersCompleted.bottomAnchor, constant: 12),
            viewAverage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewAverage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            viewAverage.heightAnchor.constraint(equalToConstant: 90)
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
