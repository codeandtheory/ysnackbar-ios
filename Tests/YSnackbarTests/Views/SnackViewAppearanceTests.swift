//
//  SnackViewAppearanceTests.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 07/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
import YMatterType
@testable import YSnackbar

final class SnackViewAppearanceTests: XCTestCase {
    func test_init_propertiesDefaultValue() {
        let sut = SnackView.Appearance()
        XCTAssertEqual(sut.title.textColor, .label)
        XCTAssertEqual(sut.title.typography.fontFamily.familyName, Typography.systemFamily.familyName)
        XCTAssertEqual(sut.title.typography.fontSize, UIFont.labelFontSize)
        XCTAssertEqual(sut.title.typography.fontWeight, .bold)

        XCTAssertEqual(sut.message.textColor, .label)
        XCTAssertEqual(sut.message.typography.fontFamily.familyName, Typography.systemFamily.familyName)
        XCTAssertEqual(sut.message.typography.fontSize, UIFont.labelFontSize)
        XCTAssertEqual(sut.message.typography.fontWeight, .regular)

        XCTAssertEqual(sut.elevation, makeElevation())
        XCTAssertEqual(sut.layout, SnackView.Appearance.Layout())
        
        let sutRgba = sut.backgroundColor.rgbaComponents
        let systemRgba = UIColor.systemBackground.rgbaComponents
        let tertiarySystemRgba = UIColor.tertiarySystemBackground.rgbaComponents
        
        XCTAssertTrue(systemRgba.red == sutRgba.red || tertiarySystemRgba.red == sutRgba.red)
        XCTAssertTrue(systemRgba.green == sutRgba.green || tertiarySystemRgba.green == sutRgba.green)
        XCTAssertTrue(systemRgba.blue == sutRgba.blue || tertiarySystemRgba.blue == sutRgba.blue)
        XCTAssertTrue(systemRgba.alpha == sutRgba.alpha || tertiarySystemRgba.alpha == sutRgba.alpha)
    }
    
    func test_colorBasedOnTraitCollection_deliversTertiarySystemBackgroundColorOnDarkMode() {
        let trait = UITraitCollection(userInterfaceStyle: .dark)
        
        XCTAssertEqual(SnackView.Appearance.colorBasedOnTraitCollection(trait), .tertiarySystemBackground)
    }
    
    func test_colorBasedOnTraitCollection_deliversSystemBackgroundColorOnLightMode() {
        let trait = UITraitCollection(userInterfaceStyle: .light)
        
        XCTAssertEqual(SnackView.Appearance.colorBasedOnTraitCollection(trait), .systemBackground)
    }
}
