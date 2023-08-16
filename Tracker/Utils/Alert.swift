//
//  Alert.swift
//  Tracker
//
//  Created by Vitaly on 17.08.2023.
//

import Foundation
import UIKit

final class Alert {
    static func alertInformation(viewController: UIViewController, text: String) {
        let alert = UIAlertController(title: "Привет!", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Хорошо", style: .default))
        viewController.present(alert, animated: true)
    }
}
//"Отметить выполнение привычки в будущем никак нельзя)"
