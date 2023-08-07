//
//  Snack.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 29/08/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit

/// A model to represent a snack object.
open class Snack {
    /// Alignment for the snack view.  Default is `SnackbarManager.defaultAlignment`.
    public let alignment: Alignment
    /// Title for the snack view. This is optional and default is nil.
    public let title: String?
    /// Message for the snack view.
    public let message: String
    /// A string for identifying a snack. This is optional and default is nil.
    public let reuseIdentifier: String?
    /// An image object to represent icon for the snack view. This is optional and default is nil.
    public let icon: UIImage?
    /// The total duration for how long the snack to be displayed. Default is 4 seconds.
    public let duration: TimeInterval
    /// Appearance for the snack view such as background color, shadow etc. Default is `.default`.
    public let appearance: Snack.Appearance
    /// Voice over interaction require. Default is 'false'
    public let voRequiresInteraction: Bool

    /// Initializes a `Snack`.
    /// - Parameters:
    ///   - alignment: alignment for the snack view. Default is `SnackbarManager.defaultAlignment`
    ///   - title: title for the snack view. This is optional and default is nil
    ///   - message: message for the snack view
    ///   - reuseIdentifier: string for identifying a snack. This is optional and default is nil
    ///   - icon: image object to represent icon for the snack view. This is optional and default is nil
    ///   - duration: total duration for how long the snack to be displayed. Default is 4 seconds
    ///   - appearance: appearance for the snack view such as background color, shadow etc.
    ///     Default is `.default`.
    ///   - voRequiresInteraction: voice over interaction require. Default is 'false'
    public init(
        alignment: Alignment = SnackbarManager.defaultAlignment,
        title: String? = nil,
        message: String,
        reuseIdentifier: String? = nil,
        icon: UIImage? = nil,
        duration: TimeInterval = 4,
        appearance: Snack.Appearance = .default,
        voRequiresInteraction: Bool = false
    ) {
        self.alignment = alignment
        self.title = title
        self.message = message
        self.reuseIdentifier = reuseIdentifier
        self.icon = icon
        self.duration = duration
        self.appearance = appearance
        self.voRequiresInteraction = voRequiresInteraction
    }

    /// Returns `SnackUpdatable` for the associated `Snack`.
    open func getSnackAssociatedView() -> SnackUpdatable { SnackView(snack: self) }
}
