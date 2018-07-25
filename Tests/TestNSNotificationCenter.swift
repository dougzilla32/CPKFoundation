import CPKFoundation
import Foundation
import CancelForPromiseKit
import XCTest

class NSNotificationCenterTests: XCTestCase {
    func testCancel() {
        let ex = expectation(description: "")
        let userInfo = ["a": 1]

        NotificationCenter.default.observeCC(once: CPKTestNotification).done { _ in
            XCTFail()
        }.catch(policy: .allErrors) {
            $0.isCancelled ? ex.fulfill() : XCTFail()
        }.cancel()

        NotificationCenter.default.post(name: CPKTestNotification, object: nil, userInfo: userInfo)

        waitForExpectations(timeout: 1)
    }
}

private let CPKTestNotification = Notification.Name("CPKTestNotification")
