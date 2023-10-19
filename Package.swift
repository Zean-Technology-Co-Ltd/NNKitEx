// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NNKitEx",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "NNKitEx",
            targets: ["NNKitEx"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", .upToNextMajor(from: "5.17.0")),
        .package(url: "https://github.com/Zean-Technology-Co-Ltd/FoundationEx.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "NNKitEx",
            dependencies: [
              "SDWebImage",
              "FoundationEx"
            ]),
//        .target(
//          name: "FoundationEx",
//          dependencies: [
//            "RxSwift",
//            .product(name: "RxCocoa", package: "RxSwift")
//          ]),
        .testTarget(
            name: "NNKitExTests",
            dependencies: [
                "NNKitEx"
            ]),
    ]
)
