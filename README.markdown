# CancelForPromiseKit Foundation Extensions

[![Build Status](https://travis-ci.org/dougzilla32/CPKFoundation.svg?branch=master)](https://travis-ci.org/dougzilla32/CPKFoundation)

This project adds cancellable promises to [PromiseKit's Foundation extension].

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
import CancelForPromiseKit
import CPKFoundation
```

To build with Carthage on versions of Swift prior to 4.1, set the 'Carthage' flag in your target's Build settings at the following location. This is necessary to properly import the PMKFoundation module, which is only defined for Carthage:
    
    TARGETS -> [Your target name]:
        'Swift Compiler - Custom Flags' -> 'Active Compilation Conditions' -> 'Debug'
        'Swift Compiler - Custom Flags' -> 'Active Compilation Conditions' -> 'Release'

## SwiftPM

```swift
let package = Package(
    dependencies: [
        .Package(url: "https://github.com/CancelForPromiseKit/Foundation.git", majorVersion: 1)
    ]
)
```

[PromiseKit's Foundation extension]: https://github.com/PromiseKit/Foundation
