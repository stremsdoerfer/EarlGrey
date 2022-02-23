// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EarlGrey",
    platforms: [
      .iOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "EarlGrey",
            targets: ["EarlGrey"]),
    ],
    dependencies: [
      .package(url: "https://github.com/stremsdoerfer/eDistantObject", .branch("master")),
      .package(url: "https://github.com/hamcrest/OCHamcrest", from: "9.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "EarlGreySPM",
            dependencies: []),
        .target(
            name: "EarlGrey",
            dependencies: ["OCHamcrest"]),
    ]
)
