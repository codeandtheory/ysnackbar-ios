//
//  Snack+AppearanceTests.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 07/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
import YMatterType
@testable import YSnackbar

final class SnackAppearanceTests: XCTestCase {
    func test_init_propertiesDefaultValue() {
        let sut = makeSUT()
        XCTAssertEqual(sut.title.textColor, .label)
        XCTAssertEqual(sut.title.typography.fontFamily.familyName, Typography.systemFamily.familyName)
        XCTAssertEqual(sut.title.typography.fontSize, UIFont.labelFontSize)
        XCTAssertEqual(sut.title.typography.fontWeight, .bold)

        XCTAssertEqual(sut.message.textColor, .label)
        XCTAssertEqual(sut.message.typography.fontFamily.familyName, Typography.systemFamily.familyName)
        XCTAssertEqual(sut.message.typography.fontSize, UIFont.labelFontSize)
        XCTAssertEqual(sut.message.typography.fontWeight, .regular)

        XCTAssertEqual(sut.borderColor, .label)
        XCTAssertEqual(sut.borderWidth, 0)
        XCTAssertEqual(sut.elevation, makeElevation())
        XCTAssertEqual(sut.layout, Snack.Appearance.Layout())
        
        let sutRgba = sut.backgroundColor.rgbaComponents
        let systemRgba = UIColor.systemBackground.rgbaComponents
        let tertiarySystemRgba = UIColor.tertiarySystemBackground.rgbaComponents
        
        XCTAssertTrue(systemRgba.red == sutRgba.red || tertiarySystemRgba.red == sutRgba.red)
        XCTAssertTrue(systemRgba.green == sutRgba.green || tertiarySystemRgba.green == sutRgba.green)
        XCTAssertTrue(systemRgba.blue == sutRgba.blue || tertiarySystemRgba.blue == sutRgba.blue)
        XCTAssertTrue(systemRgba.alpha == sutRgba.alpha || tertiarySystemRgba.alpha == sutRgba.alpha)
    }
    
    func test_snackbarBackgroundColor_deliversTertiarySystemBackgroundColorOnDarkMode() {
        let trait = UITraitCollection(userInterfaceStyle: .dark)
        
        XCTAssertEqual(
            Snack.Appearance.snackBackgroundColor.resolvedColor(with: trait),
            .tertiarySystemBackground.resolvedColor(with: trait)
        )
    }
    
    func test_snackbarBackgroundColor_deliversSystemBackgroundColorOnLightMode() {
        let trait = UITraitCollection(userInterfaceStyle: .light)
        
        XCTAssertEqual(
            Snack.Appearance.snackBackgroundColor.resolvedColor(with: trait),
            .systemBackground.resolvedColor(with: trait)
        )
    }
}

extension SnackAppearanceTests {
    func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Snack.Appearance {
        let sut = Snack.Appearance()
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
}
