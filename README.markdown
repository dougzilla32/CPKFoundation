# CancelForPromiseKit Foundation Extensions ![Build Status]

This project adds cancellable promises to the Swift Foundation framework.

We support iOS, tvOS, watchOS, macOS, Swift 3.0, 3.1, 3.2, 4.0 and 4.1.

## CococaPods

```ruby
pod "CancelForPromiseKit/Foundation", "~> 1.0"
```

The extensions are built into `CancelForPromiseKit.framework` thus nothing else is needed.

## Carthage

```ruby
github "CancelForPromiseKit/Foundation" ~> 1.0
```

The extensions are built into their own framework:

```swift
// swift
import PromiseKit
import CPKFoundation
```

```objc
// objc
@import PromiseKit;
@import CPKFoundation;
```

## SwiftPM

```swift
let package = Package(
    dependencies: [
        .Package(url: "https://github.com/CancelForPromiseKit/Foundation.git", majorVersion: 1)
    ]
)
```


[Build Status]: https://travis-ci.org/CancelForPromiseKit/Foundation.svg?branch=master
