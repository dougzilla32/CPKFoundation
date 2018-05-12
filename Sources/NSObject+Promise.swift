import Foundation
import PromiseKit
#if !CPKCocoaPods
import CancelForPromiseKit
#endif

/**
 To import the cancellable `NSObject` category:
 
 use_frameworks!
 pod "CancelForPromiseKit/Foundation"
 
 Or cancellable `NSObject` is one of the categories imported by the umbrella pod:
 
 use_frameworks!
 pod "CancelForPromiseKit"
 
 And then in your sources:
 
 import PromiseKit
 import CancelForPromiseKit
 */
extension NSObject {
    /**
     - Returns: A promise that resolves when the provided keyPath changes.
     - Warning: *Important* The promise must not outlive the object under observation.
     - SeeAlso: Apple’s KVO documentation.
     */
    public func observeCC(_: PMKNamespacer, keyPath: String, cancel: CancelContext? = nil) -> Promise<Any?> {
        return Promise(cancel: cancel ?? CancelContext()) { seal in
            KVOProxy(observee: self, keyPath: keyPath, resolve: seal.fulfill)
        }
    }
}

private class KVOProxy: NSObject {
    var retainCycle: KVOProxy?
    let fulfill: (Any?) -> Void
    
    @discardableResult
    init(observee: NSObject, keyPath: String, resolve: @escaping (Any?) -> Void) {
        fulfill = resolve
        super.init()
        observee.addObserver(self, forKeyPath: keyPath, options: NSKeyValueObservingOptions.new, context: pointer)
        retainCycle = self
    }
    
    fileprivate override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let change = change, context == pointer {
            defer { retainCycle = nil }
            fulfill(change[NSKeyValueChangeKey.newKey])
            if let object = object as? NSObject, let keyPath = keyPath {
                object.removeObserver(self, forKeyPath: keyPath)
            }
        }
    }
    
    private lazy var pointer: UnsafeMutableRawPointer = {
        return Unmanaged<KVOProxy>.passUnretained(self).toOpaque()
    }()
}
