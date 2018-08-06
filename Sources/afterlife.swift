import Foundation
import ObjectiveC
import PromiseKit

#if Carthage
import PMKFoundation
#else
#if swift(>=4.1)
#if canImport(PMKFoundation)
import PMKFoundation
#endif
#endif
#endif

#if !CPKCocoaPods
import CancelForPromiseKit
#endif

/**
 - Returns: A cancellable promise that resolves when the provided object deallocates, and can be unregistered and rejected by calling 'cancel'
 - Important: The promise is not guarenteed to resolve immediately when the provided object is deallocated. So you cannot write code that depends on exact timing.
 */
public func afterCC(life object: NSObject) -> CancellablePromise<Void> {
    var reaper = objc_getAssociatedObject(object, &cancellableHandle) as? CancellableGrimReaper
    if reaper == nil {
        reaper = CancellableGrimReaper()
        objc_setAssociatedObject(object, &cancellableHandle, reaper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        reaper!.promise.appendCancellableTask(task: CancellableReaperTask(object: object), reject: reaper!.resolver.reject)
    }
    return reaper!.promise
}

private var cancellableHandle: UInt8 = 0

private class CancellableGrimReaper: NSObject {
    let (promise, resolver) = CancellablePromise<Void>.pending()
    
    deinit {
        resolver.fulfill(())
    }
}

private class CancellableReaperTask: CancellableTask {
    weak var object: NSObject?
    
    var isCancelled = false

    init(object: NSObject) {
        self.object = object
    }
    
    func cancel() {
        if !isCancelled {
            if let obj = object {
                objc_setAssociatedObject(obj, &cancellableHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            isCancelled = true
        }
    }
}
