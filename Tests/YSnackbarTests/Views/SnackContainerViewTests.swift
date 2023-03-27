//
//  SnackContainerViewTests.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 19/09/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YSnackbar

// OK to have lots of test cases
// swiftlint:disable file_length
// swiftlint:disable type_body_length

final class SnackContainerViewTests: XCTestCase {
    func test_initWithCoder() throws {
        XCTAssertNil(SnackContainerView(coder: try makeCoder(for: UIView())))
    }

    func test_init_deliversTopAlignment() {
        XCTAssertEqual(makeSUT(alignment: .top).alignment, .top)
    }

    func test_init_deliversBottomAlignment() {
        XCTAssertEqual(makeSUT(alignment: .bottom).alignment, .bottom)
    }

    func test_init_deliversRearrangeAnimationDuration() {
        let sut = SnackContainerView(alignment: .top, appearance: .default)
        XCTAssertEqual(sut.rearrangeAnimationDuration, 0.4)
    }

    func test_addSnackOnTop_isAddedToWindow() {
        let sut = makeSUT(alignment: .top)
        let hostView = makeHostViews()[0]

        sut.addHostView(hostView) { }

        XCTAssertNotNil(hostView.window)
    }

    func test_addSnackOnBottom_isAddedToWindow() {
        let sut = makeSUT(alignment: .bottom)
        let hostView = makeHostViews()[0]

        sut.addHostView(hostView) { }

        XCTAssertNotNil(hostView.window)
    }

    func test_addSnackOnTop_isAddedToSnackbar() {
        let sut = makeSUT(alignment: .top)
        let hostViews = makeHostViews()

        sut.addHostView(hostViews[0]) { }

        XCTAssertTrue(sut.hostViews.contains(hostViews[0]))
    }

    func test_addSnackOnBottom_isAddedToSnackbar() {
        let sut = makeSUT(alignment: .bottom)
        let hostViews = makeHostViews()

        sut.addHostView(hostViews[0]) { }

        XCTAssertTrue(sut.hostViews.contains(hostViews[0]))
    }

    func test_addTwoSnacksOnTop_areAddedToSnackbar() {
        let sut = makeSUT(alignment: .top)
        let hostViews = makeHostViews()

        sut.addHostView(hostViews[0]) { }
        sut.addHostView(hostViews[1]) { }

        XCTAssertTrue(sut.hostViews.contains(hostViews[0]))
        XCTAssertTrue(sut.hostViews.contains(hostViews[1]))
    }

    func test_addTwoSnacksOnBottom_areAddedToSnackbar() {
        let sut = makeSUT(alignment: .bottom)
        let hostViews = makeHostViews()

        sut.addHostView(hostViews[0]) { }
        sut.addHostView(hostViews[1]) { }

        XCTAssertTrue(sut.hostViews.contains(hostViews[0]))
        XCTAssertTrue(sut.hostViews.contains(hostViews[1]))
    }

    func test_addMultipleSnacksOnTop_areAddedToSnackbarInOrder() {
        let sut = makeSUT(alignment: .top)
        let hostViews = makeHostViews()

        sut.addHostView(hostViews[0]) { }
        sut.addHostView(hostViews[1]) { }
        sut.addHostView(hostViews[2]) { }

        XCTAssertEqual(sut.hostViews, [hostViews[0], hostViews[1], hostViews[2]])
    }

    func test_addMultipleSnacksOnBottom_areAddedToSnackbarInOrder() {
        let sut = makeSUT(alignment: .bottom)
        let hostViews = makeHostViews()

        sut.addHostView(hostViews[0]) { }
        sut.addHostView(hostViews[1]) { }
        sut.addHostView(hostViews[2]) { }

        XCTAssertEqual(sut.hostViews, [hostViews[2], hostViews[1], hostViews[0]])
    }

    func test_addSnackWithReducedMotion_beginsOnScreenButInvisible() {
        let sut = makeSUT(alignment: .top, isReduceMotionEnabled: true)
        let hostView = makeHostViews()[0]

        sut.addHostViewWithoutAnimation(hostView)

        XCTAssertEqual(hostView.alpha, 0)
        XCTAssertGreaterThanOrEqual(hostView.frame.minY, 0)
        XCTAssertGreaterThan(hostView.frame.maxY, 0)
    }

    func test_addSnackWithReducedMotion_beginsOffScreenButNotInvisible() {
        let sut = makeSUT(alignment: .top, isReduceMotionEnabled: false)
        let hostView = makeHostViews()[0]

        sut.addHostViewWithoutAnimation(hostView)

        XCTAssertEqual(hostView.alpha, 1)
        XCTAssertLessThan(hostView.frame.minY, 0)
        XCTAssertLessThan(hostView.frame.maxY, 0)
    }

    func test_removeSnackWithReducedMotion_fadesOutSnack() {
        let sut = makeSUT(alignment: .top, isReduceMotionEnabled: true)
        let hostView = makeHostViews()[0]

        sut.addHostViews([hostView])

        sut.snackViewToBeRemoved = hostView
        sut.removeHostView(at: 0)

        XCTAssertEqual(hostView.alpha, 0)
    }

    func test_removeSnackWithoutReducedMotion_doesNotFadeOutSnack() {
        let sut = makeSUT(alignment: .top, isReduceMotionEnabled: false)
        let hostView = makeHostViews()[0]

        sut.addHostViews([hostView])

        sut.snackViewToBeRemoved = hostView
        sut.removeHostView(at: 0)

        XCTAssertNotEqual(hostView.alpha, 0)
    }

    func test_removeSnackAtZerothIndexFromTop_removesSnackFromSnackbar() {
        let sut = makeSUT(alignment: .top)
        let hostViews = makeHostViews()

        sut.addHostViews(hostViews)

        sut.snackViewToBeRemoved = hostViews[0]
        sut.removeHostView(at: 0)

        let filteredSnackViews = sut.hostViews.compactMap { $0 }
        XCTAssertEqual(filteredSnackViews, [hostViews[1], hostViews[2]])
        XCTAssertNil(hostViews[0].window)
    }

    func test_removeSnackAtFirstIndexFromTop_removesSnackFromSnackbar() {
        let sut = makeSUT(alignment: .top)
        let hostViews = makeHostViews()

        sut.addHostViews(hostViews)

        sut.snackViewToBeRemoved = hostViews[1]
        sut.removeHostView(at: 1)

        let filteredSnackViews = sut.hostViews.compactMap { $0 }
        XCTAssertEqual(filteredSnackViews, [hostViews[0], hostViews[2]])
        XCTAssertNil(hostViews[1].window)
    }

    func test_removeSnackAtSecondIndexFromTop_removesSnackFromSnackbar() {
        let sut = makeSUT(alignment: .top)
        let hostViews = makeHostViews()

        sut.addHostViews(hostViews)

        sut.snackViewToBeRemoved = hostViews[2]
        sut.removeHostView(at: 2)

        let filteredSnackViews = sut.hostViews.compactMap { $0 }
        XCTAssertEqual(filteredSnackViews, [hostViews[0], hostViews[1]])
        XCTAssertNil(hostViews[2].window)
    }

    func test_removeSnackAtZerothIndexFromBottom_removesSnackFromSnackbar() {
        let sut = makeSUT(alignment: .bottom)
        let hostViews = makeHostViews()

        sut.addHostViews(hostViews)

        sut.snackViewToBeRemoved = hostViews[0]
        sut.removeHostView(at: 0)

        let filteredSnackViews = sut.hostViews.compactMap { $0 }
        XCTAssertEqual(filteredSnackViews, [hostViews[2], hostViews[1]])
        XCTAssertNil(hostViews[0].window)
    }

    func test_removeSnackAtFirstIndexFromBottom_removesSnackFromSnackbar() {
        let sut = makeSUT(alignment: .bottom)
        let hostViews = makeHostViews()

        sut.addHostViews(hostViews)

        sut.snackViewToBeRemoved = hostViews[1]
        sut.removeHostView(at: 1)

        let filteredSnackViews = sut.hostViews.compactMap { $0  }
        XCTAssertEqual(filteredSnackViews, [hostViews[2], hostViews[0]])
        XCTAssertNil(hostViews[1].window)
    }

    func test_removeSnackAtSecondIndexFromBottom_removesSnackFromSnackbar() {
        let sut = makeSUT(alignment: .bottom)
        let hostViews = makeHostViews()

        sut.addHostViews(hostViews)

        sut.snackViewToBeRemoved = hostViews[2]
        sut.removeHostView(at: 2)

        let filteredSnackViews = sut.hostViews.compactMap { $0 }
        XCTAssertEqual(filteredSnackViews, [hostViews[1], hostViews[0]])
        XCTAssertNil(hostViews[2].window)
    }

    func test_rearrangeFirstSnackViewFromTop_movesFirstItemToTheBottom() {
        let sut = makeSUT(alignment: .top, isReduceMotionEnabled: false)
        let hostViews = makeHostViews()

        sut.addHostViews(hostViews)

        _ = sut.rearrangeHostView(at: 0) { }

        let filteredSnackViews = sut.hostViews.compactMap { $0 }
        XCTAssertEqual(filteredSnackViews, [hostViews[1], hostViews[2], hostViews[0]])
    }

    func test_rearrangeFirstSnackViewFromTopWithReducedMotion_movesFirstItemToTheBottom() {
        let sut = makeSUT(alignment: .top, isReduceMotionEnabled: true)
        let hostViews = makeHostViews()

        sut.addHostViews(hostViews)

        _ = sut.rearrangeHostView(at: 0) { }

        let filteredSnackViews = sut.hostViews.compactMap { $0 }
        XCTAssertEqual(filteredSnackViews, [hostViews[1], hostViews[2], hostViews[0]])
    }

    func test_rearrangeFirstSnackViewFromBottom_movesFirstItemToTheTop() {
        let sut = makeSUT(alignment: .bottom)
        let hostViews = makeHostViews()

        sut.addHostViews(hostViews)

        _ = sut.rearrangeHostView(at: 0) { }

        let filteredSnackViews = sut.hostViews.compactMap { $0 }
        XCTAssertEqual(filteredSnackViews, [hostViews[0], hostViews[2], hostViews[1]])
    }

    func test_rearrangeSecondSnackViewFromTop_movesSecondItemToTheBottom() {
        let sut = makeSUT(alignment: .top)
        let hostViews = makeHostViews()

        sut.addHostViews(hostViews)

        _ = sut.rearrangeHostView(at: 1) { }

        let filteredSnackViews = sut.hostViews.compactMap { $0 }
        XCTAssertEqual(filteredSnackViews, [hostViews[0], hostViews[2], hostViews[1]])
    }

    func test_rearrangeSecondSnackViewFromBottom_movesSecondItemToTheTop() {
        let sut = makeSUT(alignment: .bottom)
        let hostViews = makeHostViews()

        sut.addHostViews(hostViews)

        _ = sut.rearrangeHostView(at: 1) { }

        let filteredSnackViews = sut.hostViews.compactMap { $0 }
        XCTAssertEqual(filteredSnackViews, [hostViews[1], hostViews[2], hostViews[0]])
    }

    func test_rearrangeLastSnackViewFromBottom_doesNotChangeSnackPosition() {
        let sut = makeSUT(alignment: .bottom)
        let hostViews = makeHostViews()

        sut.addHostViews(hostViews)

        _ = sut.rearrangeHostView(at: 2) { }

        let filteredSnackViews = sut.hostViews.compactMap { $0 }
        XCTAssertEqual(filteredSnackViews, [hostViews[2], hostViews[1], hostViews[0]])
    }

    func test_rearrangeLastSnackViewFromTop_doesNotChangeSnackPosition() {
        let sut = makeSUT(alignment: .top)
        let hostViews = makeHostViews()

        sut.addHostViews(hostViews)

        _ = sut.rearrangeHostView(at: 2) { }

        let filteredSnackViews = sut.hostViews.compactMap { $0 }
        XCTAssertEqual(filteredSnackViews, [hostViews[0], hostViews[1], hostViews[2]])
    }

    func test_sut_isRemovedFromWindowOnRemovingLastSnackFromTheTop() {
        let sut = makeSUT(alignment: .top)
        let hostView1 = makeHostViews()[0]
        let hostView2 = makeHostViews()[1]

        sut.addHostViews([hostView1, hostView2])
        XCTAssertNotNil(sut.window)

        sut.snackViewToBeRemoved = hostView1
        sut.removeHostView(at: 0)
        XCTAssertNotNil(sut.window)

        sut.snackViewToBeRemoved = hostView2
        sut.removeHostView(at: 0)
        XCTAssertNil(sut.window)
    }

    func test_sut_isRemovedFromWindowOnRemovingLastSnackFromTheBottom() {
        let sut = makeSUT(alignment: .bottom)
        let hostView1 = makeHostViews()[0]
        let hostView2 = makeHostViews()[1]
        let hostView3 = makeHostViews()[2]

        sut.addHostViews([hostView1, hostView2, hostView3])
        XCTAssertNotNil(sut.window)

        sut.snackViewToBeRemoved = hostView2
        sut.removeHostView(at: 1)
        XCTAssertNotNil(sut.window)

        sut.snackViewToBeRemoved = hostView1
        sut.removeHostView(at: 0)
        XCTAssertNotNil(sut.window)

        sut.snackViewToBeRemoved = hostView3
        sut.removeHostView(at: 0)
        XCTAssertNil(sut.window)
    }

    func test_pointWithoutHostViews_deliversFalse() {
        XCTAssertFalse(makeSUT(alignment: .top).point(inside: .zero, with: nil))
    }

    func test_pointWithAllHostViewsUserInteractionDisabled_deliversFalse() {
        let sut = makeSUT(alignment: .top)
        let hostViews = makeHostViews()
        hostViews.forEach { $0.isUserInteractionEnabled = false }

        sut.addHostViews(hostViews)

        XCTAssertFalse(sut.point(inside: .zero, with: nil))
    }

    func test_pointInFirstHostView_deliversTrue() {
        let sut = makeSUT(alignment: .top)
        let hostViews = makeHostViews()
        sut.addHostViews(hostViews)

        XCTAssertTrue(sut.point(inside: CGPoint(x: 0, y: 0), with: nil))
    }

    func test_pointBetweenFirstAndSecondHostView_deliversFalse() {
        let sut = makeSUT(alignment: .top)
        let hostViews = makeHostViews()
        sut.addHostViews(hostViews)

        XCTAssertFalse(sut.point(inside: CGPoint(x: 0, y: 55), with: nil))
    }

    func test_pointInSecondHostView_deliversTrue() {
        let sut = makeSUT(alignment: .top)
        let hostViews = makeHostViews()
        sut.addHostViews(hostViews)

        XCTAssertTrue(sut.point(inside: CGPoint(x: 0, y: 71), with: nil))
    }

    func test_pointBetweenSecondAndThirdHostView_deliversFalse() {
        let sut = makeSUT(alignment: .top)
        let hostViews = makeHostViews()
        sut.addHostViews(hostViews)

        XCTAssertFalse(sut.point(inside: CGPoint(x: 0, y: 126), with: nil))
    }

    func test_pointInThirdHostView_deliversTrue() {
        let sut = makeSUT(alignment: .top)
        let hostViews = makeHostViews()
        sut.addHostViews(hostViews)

        XCTAssertTrue(sut.point(inside: CGPoint(x: 0, y: 142), with: nil))
    }

    func test_pointOutsideThirdHostView_deliversFalse() {
        let sut = makeSUT(alignment: .top)
        let hostViews = makeHostViews()
        sut.addHostViews(hostViews)

        XCTAssertFalse(sut.point(inside: CGPoint(x: 0, y: 198), with: nil))
    }
}

private extension SnackContainerViewTests {
    func makeSUT(
        alignment: Alignment,
        isReduceMotionEnabled: Bool? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SnackContainerViewSpy {
        let appearance = SnackbarManager.Appearance(addAnimationDuration: 0, removeAnimationDuration: 0)
        let sut = SnackContainerViewSpy(alignment: alignment, appearance: appearance)
        sut.reduceMotionOverride = isReduceMotionEnabled
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }

    func makeCoder(for view: UIView) throws -> NSCoder {
        let data = try NSKeyedArchiver.archivedData(withRootObject: view, requiringSecureCoding: false)
        return try NSKeyedUnarchiver(forReadingFrom: data)
    }

    func makeHostViews() -> [SnackHostView] {
        [
            SnackHostView(snackView: Snack(message: "No network").getSnackAssociatedView()),
            SnackHostView(snackView: Snack(message: "Network reachable").getSnackAssociatedView()),
            SnackHostView(snackView: Snack(message: "Network is flaky").getSnackAssociatedView())
        ]
    }
}

final class SnackContainerViewSpy: SnackContainerView {
    var snackViewToBeRemoved = UIView()

    override var rearrangeAnimationDuration: CGFloat { 0.0 }
    override var keyWindow: UIWindow? { UIWindow() }

    override func removeHostViewWithAnimation(
        _ hostView: SnackHostView,
        at index: Int,
        completion: @escaping (UIView) -> Void
    ) {
        super.removeHostViewWithAnimation(hostView, at: index, completion: completion)
        // Wait for the run loop to tick (complete animations)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01))
        completion(snackViewToBeRemoved)
    }

    override func addHostView(_ hostView: SnackHostView, completion: @escaping () -> Void) {
        super.addHostView(hostView, completion: completion)
        // Wait for the run loop to tick (complete animations)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01))
        completion()
    }

    override func rearrangeHostView(at index: Int, completion: @escaping () -> Void) -> SnackHostView {
        completion()
        let hostView = super.rearrangeHostView(at: index, completion: completion)
        // Wait for the run loop to tick (complete animations)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01))
        return hostView
    }

    func addHostViews(_ views: [SnackHostView]) {
        frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        keyWindow?.addSubview(self)
        layoutIfNeeded()

        views.forEach { addHostView($0) { } }
    }

    func addHostViewWithoutAnimation(_ view: SnackHostView) {
        frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        keyWindow?.addSubview(self)
        layoutIfNeeded()

        addHostViewWithInitialAppearance(view)
    }
}
