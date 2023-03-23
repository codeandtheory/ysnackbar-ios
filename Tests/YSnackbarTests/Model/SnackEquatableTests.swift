//
//  SnackEquatableTests.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 12/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
import YSnackbar

final class SnackEquatableTests: XCTestCase {
    func test_snack_isNotEqualWhenFirstSnackReuseIdentifierIsNil() {
        let snack1 = makeSUT(title: nil, message: "No network 1", reuseIdentifier: nil)
        let snack2 = makeSUT(title: nil, message: "No network 2", reuseIdentifier: "yml.com.snackbar2")

        XCTAssertNotEqual(snack1, snack2)
    }

    func test_snack_isNotEqualWhenSecondSnackReuseIdentifierIsNil() {
        let snack1 = makeSUT(title: nil, message: "No network 1", reuseIdentifier: "yml.com.snackbar")
        let snack2 = makeSUT(title: nil, message: "No network 2", reuseIdentifier: nil)

        XCTAssertNotEqual(snack1, snack2)
    }

    func test_snack_isNotEqualWhenReuseIdentifiersAreNil() {
        let snack1 = makeSUT(title: nil, message: "No network 1", reuseIdentifier: nil)
        let snack2 = makeSUT(title: nil, message: "No network 2", reuseIdentifier: nil)

        XCTAssertNotEqual(snack1, snack2)
    }

    func test_snack_isNotEqualWhenReuseIdentifiersDoNotMatch() {
        let snack1 = makeSUT(title: nil, message: "No network 1", reuseIdentifier: "yml.com.snackbar1")
        let snack2 = makeSUT(title: nil, message: "No network 2", reuseIdentifier: "yml.com.snackbar2")

        XCTAssertNotEqual(snack1, snack2)
    }

    func test_snack_isEqualWhenReuseIdentifiersMatch() {
        let snack1 = makeSUT(title: nil, message: "No network 1", reuseIdentifier: "yml.com.snackbar")
        let snack2 = makeSUT(title: nil, message: "No network 2", reuseIdentifier: "yml.com.snackbar")

        XCTAssertEqual(snack1, snack2)
    }

    func test_snack_isNotEqualWhenTitlesMatchAndMessagesDoNotMatch() {
        let snack1 = makeSUT(title: "Connectivity", message: "No network 1", reuseIdentifier: nil)
        let snack2 = makeSUT(title: "Connectivity", message: "No network 2", reuseIdentifier: nil)

        XCTAssertNotEqual(snack1, snack2)
    }

    func test_snack_isNotEqualWhenMessagesMatchAndTitlesDoNotMatch() {
        let snack1 = makeSUT(title: "Connectivity 1", message: "No network", reuseIdentifier: nil)
        let snack2 = makeSUT(title: "Connectivity 2", message: "No network", reuseIdentifier: nil)

        XCTAssertNotEqual(snack1, snack2)
    }

    func test_snack_isNotEqualWhenMessagesMatchAndFirstSnackTitleIsNil() {
        let snack1 = makeSUT(title: nil, message: "No network", reuseIdentifier: nil)
        let snack2 = makeSUT(title: "Connectivity 2", message: "No network", reuseIdentifier: nil)

        XCTAssertNotEqual(snack1, snack2)
    }

    func test_snack_isNotEqualWhenMessagesMatchAndSecondSnackTitleIsNil() {
        let snack1 = makeSUT(title: "Connectivity 1", message: "No network", reuseIdentifier: nil)
        let snack2 = makeSUT(title: nil, message: "No network", reuseIdentifier: nil)

        XCTAssertNotEqual(snack1, snack2)
    }

    func test_snack_isEqualWhenMessagesMatchAndTitlesAreNil() {
        let snack1 = makeSUT(title: nil, message: "No network", reuseIdentifier: nil)
        let snack2 = makeSUT(title: nil, message: "No network", reuseIdentifier: nil)

        XCTAssertEqual(snack1, snack2)
    }

    func test_snack_isEqualWhenMessagesAndTitlesMatch() {
        let snack1 = makeSUT(title: "Connectivity", message: "No network", reuseIdentifier: nil)
        let snack2 = makeSUT(title: "Connectivity", message: "No network", reuseIdentifier: nil)

        XCTAssertEqual(snack1, snack2)
    }
}

private extension SnackEquatableTests {
    func makeSUT(
        title: String? = nil,
        message: String,
        reuseIdentifier: String? = nil,
        icon: UIImage? = nil,
        duration: TimeInterval = 4.0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Snack {
        let sut = Snack(
            title: title,
            message: message,
            reuseIdentifier: reuseIdentifier,
            icon: icon,
            duration: duration
        )

        trackForMemoryLeak(sut, file: file, line: line)

        return sut
    }
}
