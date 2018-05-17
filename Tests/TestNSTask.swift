import CPKFoundation
import Foundation
import CancelForPromiseKit
import XCTest

#if os(macOS)

class NSTaskTests: XCTestCase {
    func test1() {
        let ex = expectation(description: "")
        let task = Process()
        task.launchPath = "/usr/bin/man"
        task.arguments = ["ls"]
        
        let context = CancelContext()
        task.launchCC(.promise, cancel: context).doneCC { stdout, _ in
            let stdout = String(data: stdout.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)
            XCTAssertEqual(stdout, "bar\n")
        }.catchCC(policy: .allErrors) { error in
            error.isCancelled ? ex.fulfill() : XCTFail("Error: \(error)")
        }
        context.cancel()
        waitForExpectations(timeout: 3)
    }

    func test2() {
        let ex = expectation(description: "")
        let dir = "/usr/bin"

        let task = Process()
        task.launchPath = "/bin/ls"
        task.arguments = ["-l", dir]

        let context = CancelContext()
        task.launchCC(.promise, cancel: context).doneCC { _ in
            XCTFail("failed to cancel process")
        }.catchCC(policy: .allErrors) { error in
            error.isCancelled ? ex.fulfill() : XCTFail("unexpected error \(error)")
        }
        context.cancel()
        waitForExpectations(timeout: 3)
    }
}

#endif
