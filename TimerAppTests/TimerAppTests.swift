//
//  TimerAppTests.swift
//  TimerAppTests
//
//  Created by Michał Dunajski on 03/08/2021.
//

import XCTest
@testable import TimerApp

class TimerAppTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_if_textLabel_has_always_5_signs() throws {
        let circle = CounterView()
        for iter in 1...1200 {
        circle.timerSeconds = Double(iter/100)
        XCTAssertEqual(circle.timeLabel.text!.count, 5)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
