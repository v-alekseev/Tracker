//
//  TrackerSnapshotTests.swift
//  TrackerSnapshotTests
//
//  Created by Vitaly on 16.09.2023.
//

import XCTest

import SnapshotTesting
@testable import Tracker

final class TrackerSnapshotTests: XCTestCase {

    func testTrackerViewControllerDark() {
        let vc = TrackersViewController()
        
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
        
    }
    func testTrackerViewControllerLight() {
        let vc = TrackersViewController()
        
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
        
    }
    

}
