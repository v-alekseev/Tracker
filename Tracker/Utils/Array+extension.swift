//
//  Array+extension.swift
//  Tracker
//
//  Created by Vitaly on 02.09.2023.
//

import Foundation

extension Array where Element: Hashable {
    var unique: [Element] {
        
        var seen: Set<Element> = []
        return self.filter { seen.insert($0).inserted }
    }
}
