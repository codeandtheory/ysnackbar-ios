//
//  SnackbarManager+Appearance.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 16/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit
import YCoreUI

extension SnackbarManager {
    /// Control animation duration and spacing
    public struct Appearance: Equatable {
        /// Animation for adding a snack. Default = `.defaultAdd`.
        public var addAnimation: Animation
        /// Animation for rearranging snacks. Default = `.defaultRearrange`.
        public var rearrangeAnimation: Animation
        /// Animation for removing a snack. Default = `.defaultRemove`.
        public var removeAnimation: Animation
        /// Spacing between snacks. Default is `16.0`.
        public var snackSpacing: CGFloat
        /// Distance the content is inset from the superview. Default is `NSDirectionalEdgeInsets(all: 16.0)`.
        public var contentInset: NSDirectionalEdgeInsets
        /// Maximum width of a snack view. Default is `428.0`.
        public var maxSnackWidth: CGFloat

        /// Default appearance
        public static let `default` = Appearance()

        /// Initializes a snackbar manager's appearance
        /// - Parameters:
        ///   - addAnimation: animation for adding a snack. Default is `.defaultAdd`,
        ///   - rearrangeAnimation: animation for rearranging snacks. Default is `.defaultRearrange`.
        ///   - removeAnimation: animation for removing a snack. Default is `.defaultRemove`.
        ///   - snackSpacing: spacing between snacks. Default is `16.0`
        ///   - contentInset: distance the content is inset from the superview
        ///     Default is `NSDirectionalEdgeInsets(all: 16.0)`
        ///   - maxSnackWidth: maximum width of a snack view. Default is `428.0`
        public init(
            addAnimation: Animation = .defaultAdd,
            rearrangeAnimation: Animation = .defaultRearrange,
            removeAnimation: Animation = .defaultRemove,
            snackSpacing: CGFloat = 16.0,
            contentInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(all: 16.0),
            maxSnackWidth: CGFloat = 428.0
        ) {
            self.addAnimation = addAnimation
            self.rearrangeAnimation = rearrangeAnimation
            self.removeAnimation = removeAnimation
            self.snackSpacing = snackSpacing
            self.contentInset = contentInset
            self.maxSnackWidth = maxSnackWidth
        }
    }
}
