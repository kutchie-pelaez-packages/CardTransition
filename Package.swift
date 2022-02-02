// swift-tools-version:5.3.0

import PackageDescription

let package = Package(
    name: "CardTransition",
    platforms: [
        .iOS("15")
    ],
    products: [
        .library(
            name: "CardTransition",
            targets: [
                "CardTransition"
            ]
        )
    ],
    dependencies: [
        .package(name: "Core", url: "https://github.com/kutchie-pelaez-packages/Core.git", .branch("master")),
        .package(name: "CoreUI", url: "https://github.com/kutchie-pelaez-packages/CoreUI.git", .branch("master")),
        .package(name: "DeviceKit", url: "https://github.com/kutchie-pelaez-packages/DeviceKit.git", .branch("master")),
        .package(name: "SnapKit", url: "https://github.com/kutchie-pelaez-packages/SnapKit.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "CardTransition",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "CoreUI", package: "CoreUI"),
                .product(name: "DeviceKit", package: "DeviceKit"),
                .product(name: "SnapKit", package: "SnapKit")
            ],
            path: "Sources"
        )
    ]
)
