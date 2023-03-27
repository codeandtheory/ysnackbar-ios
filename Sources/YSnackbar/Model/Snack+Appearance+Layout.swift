//
//  Snack+Appearance+Layout.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 07/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit

extension Snack.Appearance {
    /// A collection of layout properties for the `SnackView`.
    public struct Layout: Equatable {
        /// The custom distance the content is inset from the `SnackView`.
        /// Default is `NSDirectionalEdgeInsets(all: 16.0)`.
        public let contentInset: NSDirectionalEdgeInsets
        /// The vertical spacing between title label and message label. Default is `8.0`.
        public let labelSpacing: CGFloat
        /// The horizontal spacing between icon and label. Default is `16.0`.
        public let iconToLabelSpacing: CGFloat
        /// Corner radius of `SnackView`. Default is `8.0`.
        public let cornerRadius: CGFloat
        /// Size for the optional icon.
        public let iconSize: CGSize

        /// Initializes a `Layout`.
        /// - Parameters:
        ///   - contentInset: custom distance the content is inset from the `SnackView`.
        ///     Default is `NSDirectionalEdgeInsets(all: 16.0)`
        ///   - labelSpacing: vertical spacing between title label and message label. Default is `8.0`
        ///   - iconToLabelSpacing: horizontal spacing between icon and label. Default is `16.0`
        ///   - cornerRadius: corner radius of `SnackView`. Default is `8.0`
        ///   - iconSize: size for the optional icon
        public init(
            contentInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(all: 16.0),
            labelSpacing: CGFloat = 8.0,
            iconToLabelSpacing: CGFloat = 16,
            cornerRadius: CGFloat = 4.0,
            iconSize: CGSize = CGSize(width: 32, height: 32)
        ) {
            self.contentInset = contentInset
            self.labelSpacing = labelSpacing
            self.iconToLabelSpacing = iconToLabelSpacing
            self.cornerRadius = cornerRadius
            self.iconSize = iconSize
        }
    }
}
