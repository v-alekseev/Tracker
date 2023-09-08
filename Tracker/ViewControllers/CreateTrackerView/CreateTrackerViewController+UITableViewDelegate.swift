//
//  CreateTrackerViewController+UITableViewDelegate.swift
//  Tracker
//
//  Created by Vitaly on 05.09.2023.
//

import Foundation
import UIKit

extension CreateTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            presentCreateScheduleViewController()
        }
        else
        {
            presentSelectGroupViewController()
        }
    }
}
