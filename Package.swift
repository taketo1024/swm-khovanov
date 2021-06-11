// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swm-khovanov",
    products: [
        .library(
            name: "SwmKhovanov",
            targets: ["SwmKhovanov"]
        ),
    ],
    dependencies: [
        .package(
			url: "https://github.com/taketo1024/swm-core.git",
			from:"1.2.4"
//            path: "../swm-core/"
		),
        .package(
            url: "https://github.com/taketo1024/swm-knots.git",
            from: "1.1.0"
//            path: "../swm-knots/"
        ),
        .package(
            url: "https://github.com/taketo1024/swm-homology.git",
            from: "1.2.4"
//            path: "../swm-homology/"
        ),
    ],
    targets: [
        .target(
            name: "SwmKhovanov",
            dependencies: [
                .product(name: "SwmCore", package: "swm-core"),
                .product(name: "SwmKnots", package: "swm-knots"),
                .product(name: "SwmHomology", package: "swm-homology"),
			]
		),
        .testTarget(
            name: "SwmKhovanovTests",
            dependencies: ["SwmKhovanov"]
		),
    ]
)
