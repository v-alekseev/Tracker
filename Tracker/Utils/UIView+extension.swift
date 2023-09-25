//
//  UIViewController+extension.swift
//  Tracker
//
//  Created by Vitaly on 05.09.2023.
//

import Foundation
import UIKit

extension UIView {

    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }

    var topSuperview: UIView? {
        var view = superview
        while view?.superview != nil {
            view = view!.superview
        }
        return view
    }
    
    @objc
    func dismissKeyboard() {
        print("[tr] dismissKeyboard")
        topSuperview?.endEditing(true)
    }
}
