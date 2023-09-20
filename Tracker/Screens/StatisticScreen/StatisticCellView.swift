//
//  StatisticCellView.swift
//  Tracker
//
//  Created by Vitaly on 18.09.2023.
//

import Foundation
import UIKit

final class StatisticCellView: UIView {
    var value: String {
        get {
            labelUP.text ?? ""
        }
        set {
            labelUP.text = newValue
        }
    }
    var label: String {
        get {
            labelDown.text ?? ""
        }
        set {
            labelDown.text = newValue
        }
    }
    
    private let labelUP = UILabel()
    private let labelDown = UILabel()
    
    init() {
        
        super.init(frame: .zero)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16
        self.backgroundColor = .ypWhiteDay
        self.translatesAutoresizingMaskIntoConstraints = false
        
        labelUP.numberOfLines = 1
        labelUP.text = ""
        labelUP.textAlignment = .left
        labelUP.font = YFonts.fontYPBold34
        labelUP.textAlignment = .center
        labelUP.textColor = .ypBlackDay
        labelUP.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(labelUP)
        NSLayoutConstraint.activate([
            labelUP.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            labelUP.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
        ])
        
        labelDown.numberOfLines = 1
        labelDown.text = ""
        labelDown.textAlignment = .left
        labelDown.font = YFonts.fontYPMedium12
        labelDown.textAlignment = .center
        labelDown.textColor = .ypBlackDay
        labelDown.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(labelDown)
        NSLayoutConstraint.activate([
            labelDown.topAnchor.constraint(equalTo: labelUP.bottomAnchor, constant: 7),
            labelDown.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.locations = [0, 0.5, 1]
        gradient.colors = [
            UIColor(named: "ColorGradient3")!.cgColor,
            UIColor(named: "ColorGradient2")!.cgColor,
            UIColor(named: "ColorGradient1")!.cgColor,
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 16
        gradient.masksToBounds = true
        
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(roundedRect:  gradient.bounds, cornerRadius: 16).cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = 1
        gradient.mask = mask
        
        self.layer.addSublayer(gradient)
    }
}
