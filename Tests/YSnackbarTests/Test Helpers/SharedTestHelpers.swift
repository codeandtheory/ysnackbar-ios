//
//  SharedTestHelpers.swift
//  YSnackbar
//
//  Created by Karthik K Manoj on 19/12/22.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit
import YCoreUI

func makeElevation(
    xOffset: CGFloat = 0,
    yOffset: CGFloat = 2.33,
    blur: CGFloat = 6.33,
    spread: CGFloat = -0.33,
    color: UIColor = .black,
    opacity: Float = 0.46,
    useShadowPath: Bool = true
) -> Elevation {
    Elevation(
        xOffset: xOffset,
        yOffset: yOffset,
        blur: blur,
        spread: spread,
        color: color,
        opacity: opacity,
        useShadowPath: useShadowPath
    )
}
