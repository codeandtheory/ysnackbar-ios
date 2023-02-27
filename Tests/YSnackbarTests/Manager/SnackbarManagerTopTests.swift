//
//  SnackbarManagerTopTests.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 19/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YSnackbar

final class SnackbarManagerTopTests: XCTestCase {
    func test_addWithDefaultAlignmentAsTop_sharedTopDeliversSnack() {
        resetSUT()

        SnackbarManager.defaultAlignment = .top

        XCTAssertTrue(SnackbarManager.sharedTop.snacks.isEmpty)
        XCTAssertTrue(SnackbarManager.sharedBottom.snacks.isEmpty)

        let snack = Snack(message: "")
        SnackbarManager.add(snack: snack)

        XCTAssertEqual(SnackbarManager.sharedTop.snacks, [snack])
        XCTAssertEqual(SnackbarManager.sharedBottom.snacks, [])
    }

    func test_addWithoutDefaultAlignment_sharedTopDeliversSnack() {
        resetSUT()

        XCTAssertTrue(SnackbarManager.sharedTop.snacks.isEmpty)
        XCTAssertTrue(SnackbarManager.sharedBottom.snacks.isEmpty)

        let snack = Snack(message: "")
        SnackbarManager.add(snack: snack)

        XCTAssertEqual(SnackbarManager.sharedTop.snacks, [snack])
        XCTAssertTrue(SnackbarManager.sharedBottom.snacks.isEmpty)
    }

    func test_removeWithDefaultAlignmentAsTop_sharedTopRemovesSnack() {
        resetSUT()

        SnackbarManager.defaultAlignment = .top

        XCTAssertTrue(SnackbarManager.sharedTop.snacks.isEmpty)
        XCTAssertTrue(SnackbarManager.sharedBottom.snacks.isEmpty)

        let snack = Snack(message: "")
        SnackbarManager.add(snack: snack)

        XCTAssertEqual(SnackbarManager.sharedTop.snacks, [snack])
        XCTAssertTrue(SnackbarManager.sharedBottom.snacks.isEmpty)

        SnackbarManager.remove(snack: snack)

        XCTAssertTrue(SnackbarManager.sharedTop.snacks.isEmpty)
        XCTAssertTrue(SnackbarManager.sharedBottom.snacks.isEmpty)
    }

    func test_removeWithoutDefaultAlignment_sharedTopRemovesSnack() {
        resetSUT()

        XCTAssertTrue(SnackbarManager.sharedTop.snacks.isEmpty)
        XCTAssertTrue(SnackbarManager.sharedBottom.snacks.isEmpty)

        let snack = Snack(message: "")
        SnackbarManager.add(snack: snack)

        XCTAssertEqual(SnackbarManager.sharedTop.snacks, [snack])
        XCTAssertTrue(SnackbarManager.sharedBottom.snacks.isEmpty)

        SnackbarManager.remove(snack: snack)

        XCTAssertTrue(SnackbarManager.sharedTop.snacks.isEmpty)
        XCTAssertTrue(SnackbarManager.sharedBottom.snacks.isEmpty)
    }
    
    func test_addSnackOnTop_deliversOneSnack() {
        let sut = makeSUT()
        let snack1 = Snack(message: "No network")

        sut.add(snack: snack1)
        sut.didRemoveContainerView()

        XCTAssertEqual(sut.snacks, [snack1])
    }

    func test_addTwoSnacksOnTop_deliverTwoSnacks() {
        let sut = makeSUT()
        let snack1 = Snack(message: "No network")
        let snack2 = Snack(message: "Network reachable")

        sut.add(snack: snack1)
        sut.add(snack: snack2)
        sut.didRemoveContainerView()

        XCTAssertEqual(sut.snacks, [snack1, snack2])
    }

    func test_addDuplicateSnackOnTop_removesDuplicateSnacksAndAppendsNewSnack() {
        let sut = makeSUT()
        let snack1 = Snack(message: "No network")
        let snack2 = Snack(message: "Network reachable")
        let snack3 = Snack(message: "Connection established")

        sut.add(snack: snack1)
        sut.add(snack: snack2)
        sut.add(snack: snack3)
        sut.didRemoveContainerView()

        XCTAssertEqual(sut.snacks, [snack1, snack2, snack3])

        let snack4 = Snack(message: "No network")
        sut.add(snack: snack4)

        XCTAssertEqual(sut.snacks, [snack2, snack3, snack4])
    }

    func test_addDuplicateSnackOnTop_addsTimerToSnackTimerDict() throws {
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

    func test_removeFirstSnackFromTop_removesFirstSnack() {
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

    func test_removeSecondSnackFromTop_removesSecondSnack() {
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

    func test_removeThirdSnackFromTop_removesThirdSnack() {
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

    func test_containerView_isNotNilOnAddingSnackAtTheTop() {
        let sut = makeSUT()

        XCTAssertNil(sut.containerView)

        sut.add(snack: Snack(message: ""))

        XCTAssertNotNil(sut.containerView)
    }

    func test_addSnackAtTheTop_doesNotRemoveItselfIfTheSnackDurationisZero() {
        let sut = makeSUT(loadContainerView: true)

        let snack = Snack(message: "", duration: .zero)
        XCTAssertTrue(sut.snacks.isEmpty)

        sut.add(snack: snack)

        XCTAssertEqual(sut.snacks, [snack])
    }

    func test_addSnackAtTheTop_doesNotRemoveItselfIfTheSnackDurationisNan() {
        let sut = makeSUT(loadContainerView: true)

        let snack = Snack(message: "", duration: .nan)
        XCTAssertTrue(sut.snacks.isEmpty)

        sut.add(snack: snack)

        XCTAssertEqual(sut.snacks, [snack])
    }

    func test_addSnackAtTheTop_removesSnackAtTheEndOfSnackDuration() {
        let sut = makeSUT(loadContainerView: true)
        sut.startTimer = true
        
        let snack = Snack(message: "", duration: 1)
        XCTAssertTrue(sut.snacks.isEmpty)

        sut.add(snack: snack)
    
        XCTAssertTrue(sut.snacks.isEmpty)
    }

    func test_snackTimerDict_snackTimerDictIsNonEmptyOnAddingSnack() {
        let sut = makeSUT(loadContainerView: true)

        XCTAssertTrue(sut.snackTimerDict.isEmpty)

        let snack = Snack(message: "", duration: 1)
        sut.add(snack: snack)

        XCTAssertFalse(sut.snackTimerDict.isEmpty)
    }

    func test_invalidateTimerIfNeeded_snackTimerDictIsEmptyForTheGivenSnack() {
        let sut = makeSUT(loadContainerView: true)

        let snack = Snack(message: "", duration: 1)
        sut.add(snack: snack)

        XCTAssertFalse(sut.snackTimerDict.isEmpty)

        sut.invalidateTimerIfNeeded(for: snack)

        XCTAssertTrue(sut.snackTimerDict.isEmpty)
    }

    func test_defaultAppearanceOnAddingSnackAtTheTop() {
        let sut = makeSUT()

        sut.add(snack: Snack(message: ""))

        XCTAssertEqual(sut.appearance.addAnimationDuration, 0.4)
        XCTAssertEqual(sut.appearance.removeAnimationDuration, 0.4)
        XCTAssertEqual(sut.appearance.contentInset, NSDirectionalEdgeInsets(all: 16.0))
        XCTAssertEqual(sut.appearance.snackSpacing, 16.0)
        XCTAssertEqual(sut.appearance.maxSnackWidth, 428.0)
    }

    func test_newAppearanceOnAddingSnackAtTheTop() {
        let sut = makeSUT()

        sut.appearance = SnackbarManager.Appearance(
            addAnimationDuration: 0.7,
            removeAnimationDuration: 0.7,
            snackSpacing: 24.0,
            contentInset: NSDirectionalEdgeInsets(all: 24.0)
        )

        sut.add(snack: Snack(message: ""))

        XCTAssertEqual(sut.appearance.addAnimationDuration, 0.7)
        XCTAssertEqual(sut.appearance.removeAnimationDuration, 0.7)
        XCTAssertEqual(sut.appearance.contentInset, NSDirectionalEdgeInsets(all: 24.0))
        XCTAssertEqual(sut.appearance.snackSpacing, 24.0)
    }
}

extension SnackbarManagerTopTests {
    func makeSUT(loadContainerView: Bool = false) -> SnackbarManager.SnackbarManagerSpy {
        let sut =  SnackbarManager.SnackbarManagerSpy(alignment: .top)

        sut.removeAllSnack()

        if loadContainerView {
            let containerView = SnackContainerViewSpy(alignment: .top, appearance: SnackbarManager.Appearance())
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
