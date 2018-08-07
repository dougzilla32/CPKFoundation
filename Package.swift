// swift-tools-version:4.0
import PackageDescription

let pkg = Package(name: "CPKFoundation")
pkg.products = [
    .library(name: "CPKFoundation", targets: ["CPKFoundation"]),
]
pkg.dependencies = [
    .package(url: "https://github.com/dougzilla32/CancelForPromiseKit.git", from: "1.1.0"),
    .package(url: "https://github.com/PromiseKit/Foundation.git", from: "3.1.0")
//    .package(url: "https://github.com/AliSoftware/OHHTTPStubs", from: "6.0.0")
]

let cpkf: Target = .target(name: "CPKFoundation")
cpkf.path = "Sources"
cpkf.dependencies = ["CancelForPromiseKit", "PMKFoundation"]

pkg.swiftLanguageVersions = [3, 4]
pkg.targets = [
    cpkf
// Cannot run tests because OHHTTPStubs does not currently support SPM
//    .testTarget(name: "CPKNSTests", dependencies: ["CPKFoundation", "OHHTTPStubs"], path: "Tests"),
]
