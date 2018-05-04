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
            do {
                throw error
            } catch is PromiseCancelledError {
                ex.fulfill()
            } catch {
                XCTFail()
            }
        }
        context.cancelAll()
        waitForExpectations(timeout: 3)
    }

    func test2() {
        let ex = expectation(description: "")
        let dir = "/usr/bin"

        let task = Process()
        task.launchPath = "/bin/ls"
        task.arguments = [dir]

        let context = CancelContext.makeContext()
        task.launch(.promise, cancel: context).done { _ in
            XCTFail()
        }.catch(policy: .allErrors) { err in
            do {
                throw err
            } catch Process.PMKError.execution(let proc) {
                let expectedStderrData = "ls: \(dir): No such file or directory\n".data(using: .utf8, allowLossyConversion: false)!
                let stdout = (proc.standardOutput as! Pipe).fileHandleForReading.readDataToEndOfFile()
                let stderr = (proc.standardError as! Pipe).fileHandleForReading.readDataToEndOfFile()

                XCTAssertEqual(stderr, expectedStderrData)
                XCTAssertEqual(proc.terminationStatus, 1)
                XCTAssertEqual(stdout.count, 0)
                XCTFail()
            } catch is PromiseCancelledError {
                ex.fulfill()
            } catch {
                XCTFail()
            }
        }
        context.cancelAll()
        waitForExpectations(timeout: 3)
    }
}

#endif
