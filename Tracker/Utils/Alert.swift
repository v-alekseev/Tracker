//
//  Alert.swift
//  Tracker
//
//  Created by Vitaly on 17.08.2023.
//

import Foundation
import UIKit

final class Alert {
    static func alertInformation(viewController: UIViewController, text: String, hadler: ((UIAlertAction) -> Void)? = nil ) {
        let  headerString = NSLocalizedString("alert.header", comment: "")
        let  buttonString = NSLocalizedString("alert.button", comment: "")
        
        let alert = UIAlertController(title: headerString, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonString, style: .default, handler: hadler))
        viewController.present(alert, animated: true)
    }
}
