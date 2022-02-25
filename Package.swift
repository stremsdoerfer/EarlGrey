// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EarlGrey2SPM",
    platforms: [
      .iOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "EarlGrey2SPM",
            targets: ["EarlGrey2SPM"]),
    ],
    dependencies: [
      .package(url: "https://github.com/stremsdoerfer/eDistantObject", .branch("master")),
//      .package(url: "https://github.com/stremsdoerfer/TestPackage", .branch("main")),
      .package(url: "https://github.com/hamcrest/OCHamcrest", .branch("main"))
//      .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .branch("master")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "EarlGrey2SPM",
            dependencies: [
              .product(name: "EDODeviceForwarder", package: "eDistantObject"),
              .product(name: "EDOMeasure", package: "eDistantObject"),
              .product(name: "EDODevice", package: "eDistantObject"),
              .product(name: "EDOService", package: "eDistantObject"),
              .product(name: "EDOChannel", package: "eDistantObject"),
              .product(name: "eDistantObject", package: "eDistantObject"),
              .product(name: "OCHamcrest", package: "OCHamcrest"),
            ]),
        .target(
            name: "AppFramework",
            dependencies: ["CommonLib", "UILib"]),
        .target(
            name: "CommonLib",
            dependencies: [
              .product(name: "EDOChannel", package: "eDistantObject"),
              .product(name: "EDOService", package: "eDistantObject"),
            ]),
        .target(
            name: "TestLib",
            dependencies: [
              .product(name: "EDOChannel", package: "eDistantObject"),
              .product(name: "EDOService", package: "eDistantObject"),
              "CommonLib"
            ]),
        .target(
            name: "UILib",
            dependencies: [
              "CommonLib"]),
    ]
)
