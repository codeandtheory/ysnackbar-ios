//
//  SnackView+Appearance.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 07/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit
import YMatterType
import YCoreUI

extension SnackView {
    /// A collection of properties to set the appearance of the `SnackView`.
    public struct Appearance {
        /// A tuple consisting of `textColor` and `typography` for the title label.
        /// Default is `(.label, .systemLabel.bold)`.
        public let title: (textColor: UIColor, typography: Typography)
        /// A tuple consisting of `textColor` and `typography` for the message label.
        /// Default is `(.label, .systemLabel)`.
        public let message: (textColor: UIColor, typography: Typography)
        /// `SnackView`'s background color. Default is `Appearance.snackBackgroundColor`.
        public let backgroundColor: UIColor
        /// `SnackView`'s elevation. Default is `Appearance.elevation`.
        public let elevation: Elevation
        /// `SnackView`'s layout properties such as spacing between views, corner radius. Default is `Layout()`.
        public let layout: Layout

        /// Default appearance
        public static let `default` = Appearance()

        /// Initializes a `Appearance`.
        /// - Parameters:
        ///   - title: tuple consisting of `textColor` and `typography` for the title label.
        ///     Default is `(.label, .systemLabel.bold)`
        ///   - message: tuple consisting of `textColor` and `typography` for the message label.
        ///     Default is `(.label, .systemLabel)`
        ///   - backgroundColor: `SnackView`'s background color. Default is `Appearance.snackBackgroundColor`
        ///   - elevation: `SnackView`'s elevation. Default is `Appearance.elevation`
        ///   - layout: `SnackView`'s layout properties such as spacing between views, corner radius.
        ///     Default is `Layout()`
        public init(
            title: (textColor: UIColor, typography: Typography) =  (.label, .systemLabel.bold),
            message: (textColor: UIColor, typography: Typography) = (.label, .systemLabel),
            backgroundColor: UIColor = Appearance.snackBackgroundColor,
            elevation: Elevation = Appearance.elevation,
            layout: Layout = Layout()
        ) {
            self.title = title
            self.message = message
            self.backgroundColor = backgroundColor
            self.elevation = elevation
            self.layout = layout
        }
    }
}

extension SnackView.Appearance {
    /// Creates snack view's background color dynamically
    public static let snackBackgroundColor = UIColor(dynamicProvider: colorBasedOnTraitCollection)
    
    internal static func colorBasedOnTraitCollection(_ traitCollection: UITraitCollection) -> UIColor {
        traitCollection.userInterfaceStyle == .dark ? .tertiarySystemBackground : .systemBackground
    }
    
    /// Creates a default elevation.
    public static let elevation = Elevation(
        xOffset: 0,
        yOffset: 2.33,
        blur: 6.33,
        spread: -0.33,
        color: .black,
        opacity: 0.46
    )
}
