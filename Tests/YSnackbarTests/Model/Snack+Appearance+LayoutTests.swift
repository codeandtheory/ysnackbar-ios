//
//  Snack+Appearance+LayoutTests.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 07/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
import YSnackbar

final class SnackAppearanceLayoutTests: XCTestCase {
    func test_init_propertiesDefaultValue() {
        let sut = Snack.Appearance.Layout()
        XCTAssertEqual(sut.contentInset, NSDirectionalEdgeInsets(all: 16.0))
        XCTAssertEqual(sut.labelSpacing, 8.0)
        XCTAssertEqual(sut.iconToLabelSpacing, 16.0)
        XCTAssertEqual(sut.cornerRadius, 4.0)
    }
}
