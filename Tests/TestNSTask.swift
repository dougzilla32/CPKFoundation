import CPKFoundation
import Foundation
import CancellablePromiseKit
import XCTest

#if os(macOS)

class NSTaskTests: XCTestCase {
    func test1() {
        let ex = expectation(description: "")
        let task = Process()
        task.launchPath = "/usr/bin/man"
        task.arguments = ["ls"]
        
        let context = CancelContext.makeContext()
        task.launch(.promise, cancel: context).done { stdout, _ in
            let stdout = String(data: stdout.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)
            XCTAssertEqual(stdout, "bar\n")
        }.catch(policy: .allErrors) { error in
            error.isCancelled ? ex.fulfill() : XCTFail()
        }
        context.cancelAll()
        waitForExpectations(timeout: 3)
    }

    func test2() {
        let ex = expectation(description: "")
        let dir = "/usr/bin"

        let task = Process()
        task.launchPath = "/bin/ls"
        task.arguments = ["-l", dir]

        let context = CancelContext.makeContext()
        task.launch(.promise, cancel: context).done { _ in
            XCTFail()
        }.catch(policy: .allErrors) { error in
            error.isCancelled ? ex.fulfill() : XCTFail("unexpected error \(error)")
        }
        context.cancelAll()
        waitForExpectations(timeout: 3)
    }
}

#endif
