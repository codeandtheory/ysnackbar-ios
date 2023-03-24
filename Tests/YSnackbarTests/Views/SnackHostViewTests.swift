//
//  SnackHostViewTests.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 14/11/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YSnackbar

final class SnackHostViewTests: XCTestCase {
    func test_initWithCoder() throws {
        let sut = SnackHostView(coder: try makeCoder(for: UIView()))
        XCTAssertNil(sut)
    }

    func test_init_deliversSnack() {
        let snack = Snack(message: "")
        let sut = SnackHostView(snackView: snack.getSnackAssociatedView())

        XCTAssertEqual(sut.snack, snack)
    }

    func test_setTopConstraint_setsTopConstraint() {
        let sut = makeSUT()
        let constraint = NSLayoutConstraint()

        XCTAssertNil(sut.topConstraint)

        sut.setTopConstraint(constraint)
        
        XCTAssertNotNil(sut.topConstraint)
    }

    func test_setTopConstraintWithNil_setsTopConstraint() {
        let sut = makeSUT()

        XCTAssertNil(sut.topConstraint)

        sut.setTopConstraint(nil)

        XCTAssertNil(sut.topConstraint)
    }

    func test_deactivateTopConstraint_deactivatesTopConstraint() throws {
        let sut = makeSUT()
        let view1 = UIView()
        sut.addSubview(view1)

        let constraint = sut.constrain(.leadingAnchor, to: view1.leadingAnchor)
        sut.setTopConstraint(constraint)

        let topConstraint = try XCTUnwrap(sut.topConstraint)

        XCTAssertTrue(topConstraint.isActive)

        sut.deactivateTopConstraint()

        XCTAssertFalse(topConstraint.isActive)
    }

    func test_setBottomConstraint_setsBottomConstraint() {
        let sut = makeSUT()
        let constraint = NSLayoutConstraint()

        XCTAssertNil(sut.bottomConstraint)

        sut.setBottomConstraint(constraint)

        XCTAssertNotNil(sut.bottomConstraint)
    }

    func setBottomConstraintWithNil_setsBottomConstraint() {
        let sut = makeSUT()

        XCTAssertNil(sut.bottomConstraint)

        sut.setBottomConstraint(nil)

        XCTAssertNil(sut.bottomConstraint)
    }

    func test_deactivateBottomConstraint_deactivatesBottomConstraint() throws {
        let sut = makeSUT()
        let view1 = UIView()
        sut.addSubview(view1)

        let constraint = sut.constrain(.leadingAnchor, to: view1.leadingAnchor)
        sut.setBottomConstraint(constraint)

        let bottomConstraint = try XCTUnwrap(sut.bottomConstraint)

        XCTAssertTrue(bottomConstraint.isActive)

        sut.deactivateBottomConstraint()

        XCTAssertFalse(bottomConstraint.isActive)
    }

    func test_setNextHostView_setsNextHostView() {
        let sut = makeSUT()

        XCTAssertNil(sut.nextHostView)

        let nextHostView = SnackHostView(snackView: Snack(message: "").getSnackAssociatedView())

        sut.setNextHostView(nextHostView)

        XCTAssertNotNil(sut.nextHostView)
    }

    func test_setNextHostViewWithNil_setsNextHostView() {
        let sut = makeSUT()

        XCTAssertNil(sut.nextHostView)

        sut.setNextHostView(nil)

        XCTAssertNil(sut.nextHostView)
    }

    func test_setPreviousHostView_setsPreviousHostView() {
        let sut = makeSUT()

        XCTAssertNil(sut.previousHostView)

        let previousHostView = SnackHostView(snackView: Snack(message: "").getSnackAssociatedView())

        sut.setPreviousHostView(previousHostView)

        XCTAssertNotNil(sut.previousHostView)
    }

    func test_setPreviousHostViewWithNil_setsPreviousHostView() {
        let sut = makeSUT()

        XCTAssertNil(sut.previousHostView)

        sut.setPreviousHostView(nil)

        XCTAssertNil(sut.previousHostView)
    }

    func test_updateShadow_doesNotSetShadowPathWhenUseShadowPathIsFalse() {
        let elevation = makeElevation(useShadowPath: false)
        let appearance = SnackView.Appearance(elevation: elevation)
        let sut = makeSUT(appearance: appearance)
        sut.bounds = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))

        sut.updateShadow()

        XCTAssertNil(sut.layer.shadowPath)
    }

    func test_updateShadow_setsShadowPathWhenUseShadowPathIsTrue() {
        let elevation = makeElevation(useShadowPath: true)
        let appearance = SnackView.Appearance(elevation: elevation)
        let sut = makeSUT(appearance: appearance)
        sut.bounds = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))

        sut.updateShadow()

        XCTAssertNotNil(sut.layer.shadowPath)
    }

    func test_update_updatesShadowPathOnDifferentCornerRadius() throws {
        let sut = SnackHostView(snackView: Snack(message: "").getSnackAssociatedView())
        sut.bounds = CGRect(origin: .zero, size: CGSize(width: 50, height: 50))
        sut.updateShadow()

        let shadowPath = try XCTUnwrap(sut.layer.shadowPath)

        let layout = SnackView.Appearance.Layout(cornerRadius: 16)
        let appearance = SnackView.Appearance(layout: layout)
        let newSnack = Snack(message: "", appearance: appearance)

        sut.update(newSnack)

        XCTAssertNotEqual(sut.layer.shadowPath, shadowPath)
    }

    func test_init_setsAppearance() {
        let sut = makeSUT()
        let elevation = sut.snack.appearance.elevation

        XCTAssertEqual(sut.subviews.first?.layer.cornerRadius, 4)
        XCTAssertEqual(sut.layer.shadowColor, UIColor.black.cgColor)
        XCTAssertEqual(sut.layer.shadowOpacity, 0.46)
        XCTAssertEqual(sut.layer.shadowOffset, CGSize(width: 0, height: 2.33))
        XCTAssertEqual(sut.layer.shadowRadius, elevation.blur / 2.5)
        XCTAssertNotNil(sut.layer.shadowPath)
    }

    func test_update_setsNewAppearance() {
        let sut = makeSUT()
        let elevation = sut.snack.appearance.elevation
        
        XCTAssertEqual(sut.subviews.first?.layer.cornerRadius, 4)
        XCTAssertEqual(sut.layer.shadowColor, UIColor.black.cgColor)
        XCTAssertEqual(sut.layer.shadowOpacity, 0.46)
        XCTAssertEqual(sut.layer.shadowOffset, CGSize(width: 0, height: 2.33))
        XCTAssertEqual(sut.layer.shadowRadius, elevation.blur / 2.5)
        
        let layout = SnackView.Appearance.Layout(cornerRadius: 16)
        let newElevation = makeElevation(xOffset: 2, yOffset: 2, blur: 36, spread: 0, color: .red, opacity: 1.0)
        
        let appearance = SnackView.Appearance(elevation: newElevation, layout: layout)
        let newSnack = Snack(message: "", appearance: appearance)
        
        sut.update(newSnack)

        XCTAssertEqual(sut.subviews.first?.layer.cornerRadius, 16)
        XCTAssertEqual(sut.layer.shadowColor, UIColor.red.cgColor)
        XCTAssertEqual(sut.layer.shadowOpacity, 1.0)
        XCTAssertEqual(sut.layer.shadowOffset, CGSize(width: 2, height: 2))
        XCTAssertEqual(sut.layer.shadowRadius, newElevation.blur / 2.5)
    }

    func test_changeColorSpace_updatesShadowColor() {
        // Given
        let elevation = makeElevation(color: .systemPurple)
        let appearance = SnackView.Appearance(elevation: elevation)
        let sut = makeSUT(appearance: appearance)
        let (parent, child) = makeNestedViewControllers(subview: sut)

        UITraitCollection.allColorSpaces.forEach {
            // When
            parent.setOverrideTraitCollection($0, forChild: child)
            sut.traitCollectionDidChange($0)

            // Then
            XCTAssertEqual(sut.layer.shadowColor, elevation.color.resolvedColor(with: $0).cgColor)
        }
    }

    func test_changeColorSpace_updatesBorderColor() {
        // Given
        let appearance = SnackView.Appearance(borderColor: .systemPink, borderWidth: 2)
        let sut = makeSUT(appearance: appearance)
        let (parent, child) = makeNestedViewControllers(subview: sut)

        UITraitCollection.allColorSpaces.forEach {
            // When
            parent.setOverrideTraitCollection($0, forChild: child)
            sut.traitCollectionDidChange($0)

            // Then
            XCTAssertEqual(sut.snackView.layer.borderColor, appearance.borderColor.resolvedColor(with: $0).cgColor)
            XCTAssertEqual(sut.snackView.layer.borderWidth, 2)
        }
    }

    func test_swipe_dismissesSnack() {
        // Given
        let sut = makeSUT()
        let snack = sut.snack
        SnackbarManager.add(snack: snack)
        XCTAssertTrue(SnackbarManager.sharedTop.snacks.contains(snack))

        // When
        sut.simulateSwipe()

        // Then
        XCTAssertFalse(SnackbarManager.sharedTop.snacks.contains(snack))
    }
}

private extension SnackHostViewTests {
    func makeSUT(
        appearance: SnackView.Appearance = .default,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SnackHostView {
        let snack = Snack(message: "", appearance: appearance)
        let sut = SnackHostView(snackView: snack.getSnackAssociatedView())
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }

    func makeCoder(for view: UIView) throws -> NSCoder {
        let data = try NSKeyedArchiver.archivedData(withRootObject: view, requiringSecureCoding: false)
        return try NSKeyedUnarchiver(forReadingFrom: data)
    }
    
    /// Create nested view controllers containing the view to be tested so that we can override traits
    func makeNestedViewControllers(
        subview: UIView,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (parent: UIViewController, child: UIViewController) {
        let parent = UIViewController()
        let child = UIViewController()
        parent.addChild(child)
        parent.view.addSubview(child.view)

        // constrain child controller view to parent
        child.view.constrainEdges()

        child.view.addSubview(subview)

        // constrain subview to child view center
        subview.constrainCenter()

        trackForMemoryLeak(parent, file: file, line: line)
        trackForMemoryLeak(child, file: file, line: line)

        return (parent, child)
    }
}
