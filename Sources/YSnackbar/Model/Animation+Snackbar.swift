//
//  Animation+Snackbar.swift
//  YSnackbar
//
//  Created by Mark Pospesel on 3/31/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit
import YCoreUI

/// Default animation properties for snackbar operations
public extension Animation {
    /// Default animation for adding a snack (spring)
    static let defaultAdd = Animation(duration: 0.4, curve: .spring(damping: 0.6, velocity: 0.4))

    /// Default animation for rearranging snacks (ease in, ease out)
    static let defaultRearrange = Animation()

    /// Default animation for removing a snack (ease out)
    static let defaultRemove = Animation(curve: .regular(options: .curveEaseOut))
}
