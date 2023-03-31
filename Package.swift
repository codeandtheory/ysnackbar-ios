// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "YSnackbar",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "YSnackbar",
            targets: ["YSnackbar"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/yml-org/YCoreUI.git",
            from: "1.6.0"
        ),
        .package(
            url: "https://github.com/yml-org/YMatterType.git",
            from: "1.6.0"
        )
    ],
    targets: [
        .target(
            name: "YSnackbar",
            dependencies: ["YCoreUI", "YMatterType"]
        ),
        .testTarget(
            name: "YSnackbarTests",
            dependencies: ["YSnackbar"]
        )
    ]
)
