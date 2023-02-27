//
//  SnackbarManager+Appearance.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 16/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit

extension SnackbarManager {
    /// Control animation duration and spacing
    public final class Appearance {
        /// Animation duration on adding a snack. Default is `0.4`
        public let addAnimationDuration: TimeInterval
        /// Animation duration on removing a snack. Default is `0.4`
        public let removeAnimationDuration: TimeInterval
        /// Spacing between snacks. Default is `16.0`
        public let snackSpacing: CGFloat
        /// Distance the content is inset from the superview. Default is `NSDirectionalEdgeInsets(all: 16.0)`
        public let contentInset: NSDirectionalEdgeInsets
        /// Maximum width of a snack view. Default is `428.0`
        public let maxSnackWidth: CGFloat

        /// Initializes a snackbar manager's appearance
        /// - Parameters:
        ///   - addAnimationDuration: animation duration on adding a snack. Default is `0.4`
        ///   - removeAnimationDuration: animation duration on removing a snack. Default is `0.4`
        ///   - snackSpacing: spacing between snacks. Default is `16.0`
        ///   - contentInset: distance the content is inset from the superview
        ///     Default is `NSDirectionalEdgeInsets(all: 16.0)`
        ///   - maxSnackWidth: maximum width of a snack view. Default is `428.0`
        public init(
            addAnimationDuration: TimeInterval = 0.4,
            removeAnimationDuration: TimeInterval = 0.4,
            snackSpacing: CGFloat = 16.0,
            contentInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(all: 16.0),
            maxSnackWidth: CGFloat = 428.0
        ) {
            self.addAnimationDuration = addAnimationDuration
            self.removeAnimationDuration = removeAnimationDuration
            self.snackSpacing = snackSpacing
            self.contentInset = contentInset
            self.maxSnackWidth = maxSnackWidth
        }
    }
}
