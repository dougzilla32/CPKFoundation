import PackageDescription

let package = Package(
    name: "CPKFoundation",
    dependencies: [
        .Package(url: "https://github.com/dougzilla32/CancellablePromiseKit", majorVersion: 1)
    ],
    exclude: [
		"Tests"  // currently SwiftPM is not savvy to having a single test…
    ]
)
