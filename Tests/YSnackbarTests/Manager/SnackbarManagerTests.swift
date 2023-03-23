//
//  SnackbarManagerTests.swift
//  YSnackbar
//
//  Created by Mark Pospesel on 3/22/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YSnackbar

final class SnackbarManagerTests: XCTestCase {
    func test_defaultAppearance() {
        XCTAssertEqual(SnackbarManager.appearance, .default)
        XCTAssertEqual(SnackbarManager.sharedTop.appearance, .default)
        XCTAssertEqual(SnackbarManager.sharedBottom.appearance, .default)
    }

    func test_setAppearance_changesTopAndBottomManagers() {
        defer { SnackbarManager.appearance = .default }
        let spacing = CGFloat(Int.random(in: 0..<16))
        let appearance = SnackbarManager.Appearance(snackSpacing: spacing)

        SnackbarManager.appearance.snackSpacing = spacing

        XCTAssertEqual(SnackbarManager.appearance, appearance)
        XCTAssertEqual(SnackbarManager.sharedTop.appearance, appearance)
        XCTAssertEqual(SnackbarManager.sharedBottom.appearance, appearance)
    }
}
