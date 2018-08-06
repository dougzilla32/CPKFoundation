import PackageDescription

let package = Package(
    name: "CPKFoundation",
    dependencies: [
        .Package(url: "https://github.com/PromiseKit/Foundation.git", majorVersion: 3, minor: 1),
        .Package(url: "https://github.com/dougzilla32/CancelForPromiseKit.git", majorVersion: 1, minor: 1)
    ],
    exclude: [
		"Tests" // currently SwiftPM is not savvy to having a single test…
    ]
)
