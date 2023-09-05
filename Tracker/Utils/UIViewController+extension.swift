//
//  UIViewController+extension.swift
//  Tracker
//
//  Created by Vitaly on 05.09.2023.
//

import Foundation
import UIKit

// TODO: потом разберемся со скрытией клавиатуры. Так вот сразу не заработал код без глюков

//extension UIViewController {
//    func addTapGestureToHideKeyboard() {
//        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
//        view.addGestureRecognizer(tapGesture)
//    }
//}


//extension UIView {
//
//    func addTapGestureToHideKeyboard() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        addGestureRecognizer(tapGesture)
//    }
//
//    var topSuperview: UIView? {
//        var view = superview
//        while view?.superview != nil {
//            view = view!.superview
//        }
//        return view
//    }
//
//    @objc func dismissKeyboard() {
//        topSuperview?.endEditing(true)
//    }
//}
