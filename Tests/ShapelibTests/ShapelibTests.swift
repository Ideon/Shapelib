import XCTest
@testable import Shapelib

class ShapelibTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Shapelib().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
