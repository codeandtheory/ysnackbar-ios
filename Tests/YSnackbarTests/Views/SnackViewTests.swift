//
//  SnackViewTests.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 07/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YSnackbar

final class SnackViewTests: XCTestCase {
    func test_initWithCoder() throws {
        let sut = SnackView(coder: try makeCoder(for: UIView()))
        XCTAssertNil(sut)
    }

    func test_init_deliversSnackViewWithTheGivenSnack() {
        let sut = makeSUT(snack: Snack(message: "Network failed"))
        XCTAssertEqual(sut.snack.message, "Network failed")
    }

    func test_label_numberOfLines() {
        let sut = makeSUT()
        XCTAssertEqual(sut.titleLabel.numberOfLines, 1)
        XCTAssertEqual(sut.messageLabel.numberOfLines, 0)
    }

    func test_imageView_contentMode() {
        let sut = makeSUT()
        XCTAssertEqual(sut.iconImageView.contentMode, .scaleAspectFit)
    }

    func test_imageView_isHiddenForSnackWithoutImage() {
        let snack = Snack(title: "Connectivity", message: "Cannot connect to network", icon: nil)
        let sut = makeSUT(snack: snack)

        sut.layoutIfNeeded()

        XCTAssertTrue(sut.iconImageView.isHidden)
    }

    func test_imageView_isNotHiddenForSnackWithImage() {
        let snack = Snack(
            title: "Connectivity",
            message: "Cannot connect to network",
            icon: UIImage.make(withColor: .red)
        )
        let sut = makeSUT(snack: snack)

        sut.layoutIfNeeded()

        XCTAssertFalse(sut.iconImageView.isHidden)
    }

    func test_titleLabel_isHiddenForSnackWithoutTitle() {
        let snack = Snack(title: nil, message: "Cannot connect to network", icon: nil)
        let sut = makeSUT(snack: snack)

        sut.layoutIfNeeded()

        XCTAssertTrue(sut.titleLabel.isHidden)
    }

    func test_titleLabel_isNotHiddenForSnackWithTitle() {
        let snack = Snack(title: "Connectivity", message: "Cannot connect to network", icon: nil)
        let sut = makeSUT(snack: snack)

        sut.layoutIfNeeded()

        XCTAssertFalse(sut.titleLabel.isHidden)
    }

    func test_updateSnack_deliversUpdatedSnack() {
        let snack = makeSnack(
            title: "Connectivity",
            message: "Cannot connect to network",
            reuseIdentifier: "yml.com.snackbar1",
            icon: UIImage.make(withColor: .red),
            duration: 5,
            appearance: .default
        )

        let sut = makeSUT(snack: snack)

        XCTAssertEqual(sut.snack.title, snack.title)
        XCTAssertEqual(sut.snack.message, snack.message)
        XCTAssertEqual(sut.snack.reuseIdentifier, snack.reuseIdentifier)
        XCTAssertEqual(sut.snack.icon, snack.icon)
        XCTAssertEqual(sut.snack.duration, snack.duration)
        XCTAssertEqual(sut.snack.appearance, snack.appearance)

        let newAppearance = Snack.Appearance(
            title: (textColor: .red, typography: .systemLabel),
            message: (textColor: .red, typography: .systemLabel),
            backgroundColor: .blue,
            elevation: makeElevation(),
            layout: makeFixedLayout()
        )

        let newSnack = makeSnack(
            title: "Restored",
            message: "Your network is reachable",
            reuseIdentifier: "yml.com.snackbar2",
            icon: UIImage.make(withColor: .blue),
            duration: 5,
            appearance: newAppearance
        )

        sut.update(newSnack)

        XCTAssertEqual(sut.snack.title, newSnack.title)
        XCTAssertEqual(sut.snack.message, newSnack.message)
        XCTAssertEqual(sut.snack.reuseIdentifier, newSnack.reuseIdentifier)
        XCTAssertEqual(sut.snack.icon, newSnack.icon)
        XCTAssertEqual(sut.snack.duration, newSnack.duration)
        XCTAssertEqual(sut.snack.appearance, newSnack.appearance)
    }
}

private extension SnackViewTests {
    func makeSUT(
        snack: Snack = Snack(message: "Your request failed"),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SnackView {
        let sut = SnackView(snack: snack)
        sut.frame = CGRect(x: .zero, y: .zero, width: 300, height: 100)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }

    func makeCoder(for view: UIView) throws -> NSCoder {
        let data = try NSKeyedArchiver.archivedData(withRootObject: view, requiringSecureCoding: false)
        return try NSKeyedUnarchiver(forReadingFrom: data)
    }

    func makeSnack(
        title: String?,
        message: String,
        reuseIdentifier: String?,
        icon: UIImage?,
        duration: TimeInterval,
        appearance: Snack.Appearance
    ) -> Snack {
        Snack(
            title: title,
            message: message,
            reuseIdentifier: reuseIdentifier,
            icon: icon,
            duration: duration,
            appearance: appearance
        )
    }

    func makeFixedLayout() -> Snack.Appearance.Layout {
        Snack.Appearance.Layout(
            contentInset: NSDirectionalEdgeInsets(all: 8.0),
            labelSpacing: 16.0,
            iconToLabelSpacing: 16.0,
            cornerRadius: 6.0,
            iconSize: CGSize(width: 5, height: 5)
        )
    }
}

// Test Helper
extension Snack.Appearance: Equatable {
    public static func == (lhs: Snack.Appearance, rhs: Snack.Appearance) -> Bool {
        (lhs.title.textColor == rhs.title.textColor) &&
        (lhs.title.typography.fontFamily.familyName == rhs.title.typography.fontFamily.familyName) &&
        (lhs.title.typography.fontSize == rhs.title.typography.fontSize) &&
        (lhs.title.typography.fontWeight == rhs.title.typography.fontWeight) &&
        (lhs.message.textColor == rhs.message.textColor) &&
        (lhs.message.typography.fontFamily.familyName == rhs.message.typography.fontFamily.familyName) &&
        (lhs.message.typography.fontSize == rhs.message.typography.fontSize) &&
        (lhs.message.typography.fontWeight == rhs.message.typography.fontWeight) &&
        (lhs.backgroundColor == rhs.backgroundColor) &&
        (lhs.elevation == rhs.elevation) &&
        (lhs.layout == rhs.layout)
    }
}
