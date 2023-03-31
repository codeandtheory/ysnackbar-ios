//
//  Animation+SnackbarTests.swift
//  YSnackbar
//
//  Created by Mark Pospesel on 3/31/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
import YCoreUI
@testable import YSnackbar

final class AnimationSnackbarTests: XCTestCase {
    func test_defaultAdd() {
        // Given
        let sut = Animation.defaultAdd

        // Then
        XCTAssertEqual(sut.duration, 0.4)
        XCTAssertEqual(sut.delay, 0.0)
        XCTAssertEqual(sut.curve, .spring(damping: 0.6, velocity: 0.4))
    }

    func test_defaultRearrange() {
        // Given
        let sut = Animation.defaultRearrange

        // Then
        XCTAssertEqual(sut.duration, 0.3)
        XCTAssertEqual(sut.delay, 0.0)
        XCTAssertEqual(sut.curve, .regular(options: .curveEaseInOut))
    }

    func test_defaultRemove() {
        // Given
        let sut = Animation.defaultRemove

        // Then
        XCTAssertEqual(sut.duration, 0.3)
        XCTAssertEqual(sut.delay, 0.0)
        XCTAssertEqual(sut.curve, .regular(options: .curveEaseOut))
    }
}
