// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PersistenceKit",
    platforms: [.iOS(
        "15.1"
    )],
    products: [
        .library(
            name: "PersistenceKit",
            targets: ["PersistenceKit"]
        )
    ],
    dependencies: [
        .package(
            path: "../DomainKit"
        ),
        .package(
            url: "https://github.com/groue/GRDB.swift.git",
            from: "7.7.1"
        )
    ],
    targets: [
        .target(
            name: "PersistenceKit",
            dependencies: [
                "DomainKit",
                .product(
                    name: "GRDB",
                    package: "GRDB.swift"
                )
            ]
        ),
        .testTarget(
            name: "PersistenceKitTests",
            dependencies: ["PersistenceKit"]
        )
    ]
)
