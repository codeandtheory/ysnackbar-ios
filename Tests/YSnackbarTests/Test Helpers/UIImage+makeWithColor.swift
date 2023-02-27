//
//  UIImage+makeWithColor.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 07/09/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit

extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))

        return renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 1, height: 1)
            ctx.cgContext.setFillColor(color.cgColor)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
        }
    }
}
