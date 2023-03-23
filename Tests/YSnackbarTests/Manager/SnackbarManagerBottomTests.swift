//
//  SnackbarManagerBottomTests.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 08/10/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YSnackbar

final class SnackbarManagerBottomTests: XCTestCase {
    func test_addWithDefaultAlignmentAsBottom_sharedBottomDeliversSnack() {
        resetSUT()

        SnackbarManager.defaultAlignment = .bottom

        XCTAssertTrue(SnackbarManager.sharedTop.snacks.isEmpty)
        XCTAssertTrue(SnackbarManager.sharedBottom.snacks.isEmpty)

        let snack = Snack(message: "")
        SnackbarManager.add(snack: snack)

        XCTAssertEqual(SnackbarManager.sharedBottom.snacks, [snack])
        XCTAssertTrue(SnackbarManager.sharedTop.snacks.isEmpty)
    }

    func test_removeWithDefaultAlignmentAsBottom_sharedBottomRemovesSnack() {
        resetSUT()

        SnackbarManager.defaultAlignment = .bottom

        XCTAssertTrue(SnackbarManager.sharedTop.snacks.isEmpty)
        XCTAssertTrue(SnackbarManager.sharedBottom.snacks.isEmpty)

        let snack = Snack(message: "")
        SnackbarManager.add(snack: snack)

        XCTAssertTrue(SnackbarManager.sharedTop.snacks.isEmpty)
        XCTAssertEqual(SnackbarManager.sharedBottom.snacks, [snack])

        SnackbarManager.remove(snack: snack)

        XCTAssertTrue(SnackbarManager.sharedTop.snacks.isEmpty)
        XCTAssertTrue(SnackbarManager.sharedBottom.snacks.isEmpty)
    }

    func test_addMultipleSnacksWithTopAndBottomAlignment_sharedTopAndSharedBottomDeliversSnack() {
        resetSUT()

        XCTAssertTrue(SnackbarManager.sharedTop.snacks.isEmpty)
        XCTAssertTrue(SnackbarManager.sharedBottom.snacks.isEmpty)

        let snack1 = Snack(alignment: .top, message: "")
        SnackbarManager.add(snack: snack1)

        let snack2 = Snack(alignment: .bottom, message: "")
        SnackbarManager.add(snack: snack2)

        XCTAssertEqual(SnackbarManager.sharedTop.snacks, [snack1])
        XCTAssertEqual(SnackbarManager.sharedBottom.snacks, [snack2])
    }

    func test_addSnackOnBottom_deliversOneSnack() {
        let sut = makeSUT()
        let snack1 = Snack(message: "No network")

        sut.add(snack: snack1)
        sut.didRemoveContainerView()

        XCTAssertEqual(sut.snacks, [snack1])
    }

    func test_addTwoSnacksOnBottom_deliverTwoSnacks() {
        let sut = makeSUT()
        let snack1 = Snack(message: "No network")
        let snack2 = Snack(message: "Network reachable")

        sut.add(snack: snack1)
        sut.add(snack: snack2)
        sut.didRemoveContainerView()

        XCTAssertEqual(sut.snacks, [snack1, snack2])
    }

    func test_addDuplicateSnackAtBottom_removesDuplicateSnacksAndAppendsNewSnack() {
        let sut = makeSUT()
        let snack1 = Snack(message: "No network")
        let snack2 = Snack(message: "Network reachable")
        let snack3 = Snack(message: "Connection established")

        sut.add(snack: snack1)
        sut.add(snack: snack2)
        sut.add(snack: snack3)
        sut.didRemoveContainerView()

        XCTAssertEqual(sut.snacks, [snack1, snack2, snack3])

        let snack4 = Snack(message: "Connection established")
        sut.add(snack: snack4)

        XCTAssertEqual(sut.snacks, [snack1, snack2, snack4])
    }

    func test_addDuplicateSnackOnBottom_addsTimerToSnackTimerDict() throws {
        let sut = makeSUT(loadContainerView: true)
        let snack1 = Snack(message: "No network")
        let snack2 = Snack(message: "Network reachable")
        let snack3 = Snack(message: "Connection established")

        sut.add(snack: snack1)
        sut.add(snack: snack2)
        sut.add(snack: snack3)

        let snack4 = Snack(message: "No network")
        sut.add(snack: snack4)

        let timer = try XCTUnwrap( sut.snackTimerDict[snack4])
        XCTAssertNotNil(timer)
    }

    func test_removeFirstSnackFromBottom_removesFirstSnack() {
        let sut = makeSUT()
        let snack1 = Snack(message: "No network")
        let snack2 = Snack(message: "Network reachable")
        let snack3 = Snack(message: "Connection established")

        sut.add(snack: snack1)
        sut.add(snack: snack2)
        sut.add(snack: snack3)
        sut.didRemoveContainerView()

        sut.remove(snack: snack1)

        XCTAssertEqual(sut.snacks, [snack2, snack3])
    }

    func test_removeSecondSnackFromBottom_removesSecondSnack() {
        let sut = makeSUT()
        let snack1 = Snack(message: "No network")
        let snack2 = Snack(message: "Network reachable")
        let snack3 = Snack(message: "Connection established")

        sut.add(snack: snack1)
        sut.add(snack: snack2)
        sut.add(snack: snack3)
        sut.didRemoveContainerView()

        sut.remove(snack: snack2)

        XCTAssertEqual(sut.snacks, [snack1, snack3])
    }
    
    func test_removeThirdSnackFromBottom_removesThirdSnack() {
        let sut = makeSUT()
        let snack1 = Snack(message: "No network")
        let snack2 = Snack(message: "Network reachable")
        let snack3 = Snack(message: "Connection established")

        sut.add(snack: snack1)
        sut.add(snack: snack2)
        sut.add(snack: snack3)
        sut.didRemoveContainerView()

        sut.remove(snack: snack3)

        XCTAssertEqual(sut.snacks, [snack1, snack2])
    }

    func test_containerView_isNotNilOnAddingSnackAtTheBottom() {
        let sut = makeSUT()

        XCTAssertNil(sut.containerView)

        sut.add(snack: Snack(message: ""))

        XCTAssertNotNil(sut.containerView)
    }

    func test_addSnackAtTheBottom_doesNotRemoveItselfIfTheSnackDurationisZero() {
        let sut = makeSUT(loadContainerView: true)

        let snack = Snack(message: "", duration: .zero)
        XCTAssertTrue(sut.snacks.isEmpty)

        sut.add(snack: snack)

        XCTAssertEqual(sut.snacks, [snack])
    }

    func test_addSnackAtTheBottom_doesNotRemoveItselfIfTheSnackDurationisNan() {
        let sut = makeSUT(loadContainerView: true)

        let snack = Snack(message: "", duration: .nan)
        XCTAssertTrue(sut.snacks.isEmpty)

        sut.add(snack: snack)

        XCTAssertEqual(sut.snacks, [snack])
    }

    func test_addSnackAtTheBottom_removesSnackAtTheEndOfSnackDuration() {
        let sut = makeSUT(loadContainerView: true)
        sut.startTimer = true

        let snack = Snack(message: "", duration: 1)
        XCTAssertTrue(sut.snacks.isEmpty)

        sut.add(snack: snack)

        XCTAssertTrue(sut.snacks.isEmpty)
    }

    func test_defaultAppearanceOnAddingSnackAtTheBottom() {
        let sut = makeSUT()

        sut.add(snack: Snack(message: ""))

        XCTAssertEqual(sut.appearance.addAnimationDuration, 0.4)
        XCTAssertEqual(sut.appearance.removeAnimationDuration, 0.4)
        XCTAssertEqual(sut.appearance.contentInset, NSDirectionalEdgeInsets(all: 16.0))
        XCTAssertEqual(sut.appearance.snackSpacing, 16.0)
        XCTAssertEqual(sut.appearance.maxSnackWidth, 428.0)
        XCTAssertEqual(sut.appearance, .default)
        XCTAssertEqual(sut.containerView?.appearance, .default)
    }

    func test_newAppearanceOnAddingSnackAtTheBottom() {
        let sut = makeSUT()
        let appearance = SnackbarManager.Appearance(
            addAnimationDuration: 0.7,
            removeAnimationDuration: 0.7,
            snackSpacing: 24.0,
            contentInset: NSDirectionalEdgeInsets(all: 24.0)
        )
        sut.appearance = appearance

        sut.add(snack: Snack(message: ""))

        XCTAssertEqual(sut.appearance, appearance)
        XCTAssertEqual(sut.containerView?.appearance, appearance)
    }
}

extension SnackbarManagerBottomTests {
    func makeSUT(loadContainerView: Bool = false) -> SnackbarManager.SnackbarManagerSpy {
        let sut =  SnackbarManager.SnackbarManagerSpy(alignment: .bottom)

        sut.removeAllSnack()

        if loadContainerView {
            let containerView = SnackContainerViewSpy(alignment: .bottom, appearance: .default)
            sut.updateContainerView(containerView)
        } else {
            sut.didRemoveContainerView()
        }

        return sut
    }

    func resetSUT() {
        addTeardownBlock { SnackbarManager.SnackbarManagerSpy.reset() }
    }
}
