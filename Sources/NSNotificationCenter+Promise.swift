import Foundation
import PromiseKit
#if !CPKCocoaPods
import CancelForPromiseKit
#endif

/**
 To import the cancellable `NSNotificationCenter` category:
 
 use_frameworks!
 pod "CancelForPromiseKit/Foundation"
 
 Or cancellable `NSNotificationCenter` is one of the categories imported by the umbrella pod:
 
 use_frameworks!
 pod "CancelForPromiseKit"
 
 And then in your sources:
 
 import PromiseKit
 import CancelForPromiseKit
 */
extension NotificationCenter {
    /// Observe the named notification once
    public func observeCC(once name: Notification.Name, object: Any? = nil, cancel: CancelContext? = nil) -> Promise<Notification> {
        let (promise, resolver) = Promise<Notification>.pending()
#if !os(Linux)
        let id = addObserver(forName: name, object: object, queue: nil, using: resolver.fulfill)
#else
        let id = addObserver(forName: name, object: object, queue: nil, usingBlock: resolver.fulfill)
#endif
        
        let cancelContext = cancel ?? CancelContext()
        cancelContext.append(task: ObserverTask { self.removeObserver(id) }, reject: resolver.reject)
        promise.cancelContext = cancelContext

        let _ = promise.ensureCC { self.removeObserver(id) }
        return promise
    }
}

class ObserverTask: CancellableTask {
    let cancelBlock: () -> Void
    
    init(cancelBlock: @escaping () -> Void) {
        self.cancelBlock = cancelBlock
    }
    
    func cancel() {
        cancelBlock()
        isCancelled = true
    }
    
    var isCancelled = false
}
