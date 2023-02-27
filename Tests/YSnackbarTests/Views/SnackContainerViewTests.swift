//
//  SnackContainerViewTests.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 19/09/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YSnackbar

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
        let sut = makeSUT(alignment: .top)
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

        sut.addHostViews([hostView1, hostView2])
        XCTAssertNotNil(sut.window)

        sut.snackViewToBeRemoved = hostView1
        sut.removeHostView(at: 0)
        XCTAssertNotNil(sut.window)

        sut.snackViewToBeRemoved = hostView2
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
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SnackContainerViewSpy {
        let sut = SnackContainerViewSpy(alignment: alignment, appearance: SnackbarManager.Appearance())
        trackForMemoryLeaks(sut, file: file, line: line)
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

    override var keyWindow: UIWindow? { UIWindow() }

    override func removeHostViewWithAnimation(
        _ hostView: SnackHostView,
        at index: Int,
        completion: @escaping (UIView) -> Void
    ) {
        super.removeHostViewWithAnimation(hostView, at: index, completion: completion)
        completion(snackViewToBeRemoved)
    }

    override func addHostView(_ hostView: SnackHostView, completion: @escaping () -> Void) {
        super.addHostView(hostView, completion: completion)
        completion()
    }

    override func rearrangeHostView(at index: Int, completion: @escaping () -> Void) -> SnackHostView {
        completion()
        return super.rearrangeHostView(at: index, completion: completion)
    }

    func addHostViews(_ views: [SnackHostView]) {
        frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        keyWindow?.addSubview(self)
        layoutIfNeeded()

        views.forEach { addHostView($0) { } }
    }
}
