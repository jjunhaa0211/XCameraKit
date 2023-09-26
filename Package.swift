// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "XCameraKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "XCameraKit",
                 targets: ["XCameraKit"])
    ],
    targets: [
        .target(name: "XCameraKit",
                path: "XCameraKit/Classes")
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
