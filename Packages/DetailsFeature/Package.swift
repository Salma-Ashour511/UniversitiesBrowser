// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DetailsFeature",
    platforms: [.iOS(
        "15.1"
    )],
    products: [
        .library(
            name: "DetailsFeature",
            targets: ["DetailsFeature"]
        )
    ],
    dependencies: [
        .package(
            path: "../DomainKit"
        ),
        .package(
            path: "../CommonUI"
        )
    ],
    targets: [
        .target(
            name: "DetailsFeature",
            dependencies: [
                "DomainKit",
                "CommonUI"
            ]
        ),
        .testTarget(
            name: "DetailsFeatureTests",
            dependencies: ["DetailsFeature"]
        )
    ]
)
