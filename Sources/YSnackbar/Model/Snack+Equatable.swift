//
//  Snack+Equatable.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 09/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import Foundation

extension Snack: Equatable {
    /// :nodoc:
    public static func == (lhs: Snack, rhs: Snack) -> Bool {
        if let lhsReuseIdentifier = lhs.reuseIdentifier,
           let rhsReuseIdentifier = rhs.reuseIdentifier {
            return lhsReuseIdentifier == rhsReuseIdentifier
        }

        return (lhs.title == rhs.title) && (lhs.message == rhs.message)
    }
}
