//
//  Snack+Hashable.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 09/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import Foundation

extension Snack: Hashable {
    /// :nodoc:
    public func hash(into hasher: inout Hasher) {
        if let reuseIdentifier = reuseIdentifier {
            hasher.combine(reuseIdentifier)
        } else {
            hasher.combine(message)

            if let title = title { hasher.combine(title) }
        }
    }
}
