//
//  SnackTests.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 30/08/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
import YMatterType
import YSnackbar

final class SnackTests: XCTestCase {
    func test_init_deliversSnack() {
        let sut = makeSUT(
            title: "Failed",
            message: "Your request failed.",
            reuseIdentifier: "com.snack.failed",
            icon: nil,
            duration: 1.0
        )

        XCTAssertEqual(sut.title, "Failed")
        XCTAssertEqual(sut.message, "Your request failed.")
        XCTAssertEqual(sut.reuseIdentifier, "com.snack.failed")
        XCTAssertNil(sut.icon)
        XCTAssertEqual(sut.duration, 1.0)
    }

    func test_initWithMessage_deliversSnack() {
        let sut = makeSUT(message: "Your request failed.")
        XCTAssertNil(sut.title)
        XCTAssertEqual(sut.message, "Your request failed.")
        XCTAssertNil(sut.reuseIdentifier)
        XCTAssertNil(sut.icon)
        XCTAssertEqual(sut.duration, 4)
    }

    func test_appearance_propertiesDefaultValue() {
        let appearance = makeSUT(message: "Your request failed.").appearance

        XCTAssertEqual(appearance.title.textColor, .label)
        XCTAssertEqual(appearance.title.typography.fontFamily.familyName, Typography.systemFamily.familyName)
        XCTAssertEqual(appearance.title.typography.fontSize, UIFont.labelFontSize)
        XCTAssertEqual(appearance.title.typography.fontWeight, .bold)

        XCTAssertEqual(appearance.message.textColor, .label)
        XCTAssertEqual(appearance.message.typography.fontFamily.familyName, Typography.systemFamily.familyName)
        XCTAssertEqual(appearance.message.typography.fontSize, UIFont.labelFontSize)
        XCTAssertEqual(appearance.message.typography.fontWeight, .regular)

        XCTAssertEqual(appearance.elevation, makeElevation())
        XCTAssertEqual(appearance.layout, SnackView.Appearance.Layout())
        
        let expectedRgba = appearance.backgroundColor.rgbaComponents
        let systemRgba = UIColor.systemBackground.rgbaComponents
        let tertiarySystemRgba = UIColor.tertiarySystemBackground.rgbaComponents
        
        XCTAssertTrue(systemRgba.red == expectedRgba.red || tertiarySystemRgba.red == expectedRgba.red)
        XCTAssertTrue(systemRgba.green == expectedRgba.green || tertiarySystemRgba.green == expectedRgba.green)
        XCTAssertTrue(systemRgba.blue == expectedRgba.blue || tertiarySystemRgba.blue == expectedRgba.blue)
        XCTAssertTrue(systemRgba.alpha == expectedRgba.alpha || tertiarySystemRgba.alpha == expectedRgba.alpha)
    }

    func test_getSnackAssociatedView_deliversSnackView() {
        XCTAssertTrue(makeSUT(message: "").getSnackAssociatedView() is SnackView)
    }
}

private extension SnackTests {
    func makeSUT(
        title: String?,
        message: String,
        reuseIdentifier: String?,
        icon: UIImage?,
        duration: TimeInterval,
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

        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }

    func makeSUT(message: String, file: StaticString = #filePath, line: UInt = #line) -> Snack {
        let sut = Snack(message: message)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
