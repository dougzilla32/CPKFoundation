import Foundation
import PromiseKit
#if !CPKCocoaPods
import CancellablePromiseKit
#endif

#if os(macOS)

extension Process: CancellableTask {
    public func cancel() {
        interrupt()
    }
    
    public var isCancelled: Bool {
        get {
            return !isRunning
        }
    }
}

/**
 To import the `Process` category:

    use_frameworks!
    pod "CancellablePromiseKit/Foundation"

 Or, `Process` is one of the categories imported by the umbrella pod:

    use_frameworks!
    pod "CancellablePromiseKit"
 
 And then in your sources:

    import PromiseKit
 */
extension Process {
    /**
     Launches the receiver and resolves when it exits.
     
         let proc = Process()
         proc.launchPath = "/bin/ls"
         proc.arguments = ["/bin"]
         proc.launch(.promise).compactMap { std in
             String(data: std.out.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)
         }.then { stdout in
             print(str)
         }
     */
    public func launch(_: PMKNamespacer, cancel: CancelContext) -> Promise<(out: Pipe, err: Pipe)> {
        let (stdout, stderr) = (Pipe(), Pipe())
        
        do {
            standardOutput = stdout
            standardError = stderr

            #if swift(>=4.0)
                if #available(OSX 10.13, *) {
                    try run()
                } else if let path = launchPath, FileManager.default.isExecutableFile(atPath: path) {
                    launch()
                } else {
                    throw PMKError.notExecutable(launchPath)
                }
            #else
                guard let path = launchPath, FileManager.default.isExecutableFile(atPath: path) else {
                    throw PMKError.notExecutable(launchPath)
                }
                launch()
            #endif
        } catch {
            return Promise(error: error)
        }

        var q: DispatchQueue {
            if #available(macOS 10.10, iOS 8.0, tvOS 9.0, watchOS 2.0, *) {
                return DispatchQueue.global(qos: .default)
            } else {
                return DispatchQueue.global(priority: .default)
            }
        }

        return Promise(cancel: cancel, task: self) { seal in
            q.async {
                self.waitUntilExit()

                guard self.terminationReason == .exit, self.terminationStatus == 0 else {
                    return seal.reject(PMKError.execution(self))
                }
                seal.fulfill((stdout, stderr))
            }
        }
    }
}

#endif
