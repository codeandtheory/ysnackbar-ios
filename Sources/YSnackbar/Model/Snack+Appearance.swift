//
//  Snack+Appearance.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 07/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit
import YMatterType
import YCoreUI

extension Snack {
    /// A collection of properties to set the appearance of the `SnackView`.
    open class Appearance {
        /// A tuple consisting of `textColor` and `typography` for the title label.
        /// Default is `(.label, .systemLabel.bold)`.
        public let title: (textColor: UIColor, typography: Typography)
        /// A tuple consisting of `textColor` and `typography` for the message label.
        /// Default is `(.label, .systemLabel)`.
        public let message: (textColor: UIColor, typography: Typography)
        /// Background color. Default is `Appearance.snackBackgroundColor`.
        public let backgroundColor: UIColor
        /// Border color. Default is `.label`.
        public let borderColor: UIColor
        /// Border width. Default is `0`.
        public let borderWidth: CGFloat
        /// Elevation (also known as box shadow). Default is `Appearance.elevation`.
        public let elevation: Elevation
        /// Layout properties such as spacing between views, corner radius. Default is `Layout()`.
        public let layout: Layout

        /// Default appearance
        public static let `default` = Appearance()

        /// Initializes a `Appearance`.
        /// - Parameters:
        ///   - title: tuple consisting of `textColor` and `typography` for the title label.
        ///     Default is `(.label, .systemLabel.bold)`.
        ///   - message: tuple consisting of `textColor` and `typography` for the message label.
        ///     Default is `(.label, .systemLabel)`.
        ///   - backgroundColor: background color. Default is `Appearance.snackBackgroundColor`.
        ///   - borderColor: border color
        ///   - borderWidth: border width
        ///   - elevation: elevation (box shadow). Default is `Appearance.elevation`.
        ///   - layout: layout properties such as spacing between views, corner radius. Default is `Layout()`.
        public init(
            title: (textColor: UIColor, typography: Typography) =  (.label, .systemLabel.bold),
            message: (textColor: UIColor, typography: Typography) = (.label, .systemLabel),
            backgroundColor: UIColor = Appearance.snackBackgroundColor,
            borderColor: UIColor = .label,
            borderWidth: CGFloat = 0,
            elevation: Elevation = Appearance.elevation,
            layout: Layout = Layout()
        ) {
            self.title = title
            self.message = message
            self.backgroundColor = backgroundColor
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.elevation = elevation
            self.layout = layout
        }
    }
}

extension Snack.Appearance {
    /// Snack view default background color
    public static let snackBackgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .dark: return .tertiarySystemBackground
        default:    return .systemBackground
        }
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
