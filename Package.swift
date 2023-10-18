// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
/** 安装三方依赖库
 * （1）swift package update
 * （2）swift package generate-xcodeproj
 */

import PackageDescription

let package = Package(
    name: "NNKitEx",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NNKitEx",
            targets: ["NNKitEx"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", .upToNextMajor(from: "5.17.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.5.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NNKitEx",
            dependencies: [
              "SDWebImage",
              "RxSwift",
              .product(name: "RxCocoa", package: "RxSwift"),
              "FoundationEx"
            ]),
        .target(
          name: "FoundationEx",
          dependencies: [
            "RxSwift",
            .product(name: "RxCocoa", package: "RxSwift")
          ]),
        .testTarget(
            name: "NNKitExTests",
            dependencies: ["NNKitEx"]),
    ]
)
