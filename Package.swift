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
        .library(
            name: "EarlGreyTestLib",
            targets: ["TestLib"]),
        .library(
            name: "EarlGreyAppFramework",
            targets: ["AppFramework"]),
        .library(
            name: "EarlGreyCommonLib",
            targets: ["CommonLib"]),
        .library(
            name: "EarlGreyUILib",
            targets: ["UILib"]),
    ],
    dependencies: [
      .package(url: "https://github.com/stremsdoerfer/eDistantObject", .branch("master")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
          name: "EarlGrey2SPM",
          dependencies: [
            "AppFramework",
            "CommonLib",
            "TestLib",
          ],
          cSettings: [
            .headerSearchPath("../CommonLib/include")
          ]
        ),
        .target(
            name: "AppFramework",
            dependencies: [
              .product(name: "EDOChannel", package: "eDistantObject"),
              .product(name: "EDOMeasure", package: "eDistantObject"),
              .product(name: "EDOService", package: "eDistantObject"),
              .product(name: "EDODevice", package: "eDistantObject"),
            ],
            publicHeadersPath: "include"),
        .target(
            name: "CommonLib",
            dependencies: [
              .product(name: "EDOChannel", package: "eDistantObject"),
              .product(name: "EDOMeasure", package: "eDistantObject"),
              .product(name: "EDOService", package: "eDistantObject"),
              .product(name: "EDODevice", package: "eDistantObject"),
            ],
            publicHeadersPath: "include"),
        .target(
            name: "TestLib",
            dependencies: [
              .product(name: "EDOChannel", package: "eDistantObject"),
              .product(name: "EDOMeasure", package: "eDistantObject"),
              .product(name: "EDOService", package: "eDistantObject"),
              .product(name: "EDODevice", package: "eDistantObject"),
            ],
            publicHeadersPath: "include"),
        .target(
            name: "UILib",
            dependencies: [],
            publicHeadersPath: "include"),
    ]
)
