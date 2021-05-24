//
//  RasmussenInvariantTests.swift
//  SwiftyKnotsTests
//
//  Created by Taketo Sano on 2019/06/05.
//

import XCTest
import SwmCore
import SwmKnots
@testable import SwmKhovanov

class RasmussenInvariantTests: XCTestCase {
    
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    let s = RasmussenInvariant(_:)

    func testUnknot() {
        let K = Link.unknot
        XCTAssertEqual(s(K), 0)
    }
    
    func testUnknot_RM1() {
        let K = Link(pdCode: [1,2,2,1])
        XCTAssertEqual(s(K), 0)
    }
    
    func testUnknot_RM2() {
        let K = Link(pdCode: [1,4,2,1], [2,4,3,3])
        XCTAssertEqual(s(K), 0)
    }
    
    func test3_1_Z() {
        let K = Link.load("3_1")!
        XCTAssertEqual(s(K), -2)
    }
    
    func test4_1_Z() {
        let K = Link.load("4_1")!
        XCTAssertEqual(s(K), 0)
    }
    
    func test5_1_Z() {
        let K = Link.load("5_1")!
        XCTAssertEqual(s(K), -4)
    }
}
