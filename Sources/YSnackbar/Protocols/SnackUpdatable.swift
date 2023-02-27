//
//  SnackUpdatable.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 12/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit

/// `UIView` subclass type that has a snack which can be updated.
public protocol SnackUpdatable: UIView {
    /// Updates the snack view's model object.
    /// - Parameter snack: new snack object
    func update(_ snack: Snack)

    /// A snack data model for the `SnackView`.
    var snack: Snack { get }
}
