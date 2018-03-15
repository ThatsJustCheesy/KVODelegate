//
//  ObservationDelegateSelectorSwiftTests.swift
//  KVODelegateSwiftTests
//
//  Created by Ian Gregory on 14-03-2018.
//  Copyright © 2018 ThatsJustCheesy. All rights reserved.
//

import XCTest
import KVODelegate

class ObservationDelegateSelectorSwiftTests: XCTestCase {
    
    var kvoDelegate = KVOObservationDelegate()
    var person = Person()
    
    var expect: XCTestExpectation!

    override func setUp() {
        super.setUp()
        
        kvoDelegate = KVOObservationDelegate(owner: self)
    }
    
    override func tearDown() {
        kvoDelegate.stopObservingAllKeyPaths()
        
        super.tearDown()
    }
    
    func testNoParamsSelector_isCalledAndStopsWhenTold() {
        expect = expectation(description: "Selector called")
        
        kvoDelegate.startObserving(keyPath: "age", on: person, selector: #selector(noParamsSelector_isCalledAndStopsWhenTold))
        person.age = 1
        
        kvoDelegate.stopObserving(keyPath: "age", on: person)
        person.age = 2
        // expect should not overfulfill
        
        waitForExpectations(timeout: 0.05, handler: nil)
    }
    func noParamsSelector_isCalledAndStopsWhenTold() {
        expect.fulfill()
    }
    
    func testKeyPathSelector_isCalledWithKeyPath() {
        expect = expectation(description: "Selector called")
        
        kvoDelegate.startObserving(keyPath: "age", on: person, keyPathSelector: #selector(keyPathSelector_isCalled(keyPath:)), options: [])
        
        person.age = 1
        
        waitForExpectations(timeout: 0.05, handler: nil)
    }
    func keyPathSelector_isCalled(keyPath: String) {
        XCTAssertEqual("age", keyPath)
        
        expect.fulfill()
    }
    
    func testNewOldSelector_isCalledWithNewValueAndOldValue() {
        expect = expectation(description: "Selector called")
        
        kvoDelegate.startObserving(keyPath: "age", on: person, newOldSelector: #selector(newOldSelector_isCalled(newValue:oldValue:)), options: [.new, .old])
        
        person.age = 1
        
        waitForExpectations(timeout: 0.05, handler: nil)
    }
    func newOldSelector_isCalled(newValue: NSNumber?, oldValue: NSNumber?) {
        guard let newValue = newValue,
              let oldValue = oldValue
        else { XCTFail(); return }
        
        XCTAssertEqual(1, newValue.uintValue)
        XCTAssertEqual(0, oldValue.uintValue)
        
        expect.fulfill()
    }
    
    func testNewOldPriorSelector_isCalledWithNewValueOldValueAndIsPriorValue() {
        expect = expectation(description: "Selector called")
        expect.expectedFulfillmentCount = 2
        
        kvoDelegate.startObserving(keyPath: "age", on: person, newOldPriorSelector: #selector(newOldPriorSelector_isCalled(newValue:oldValue:isPrior:)), options: [.new, .old, .prior])
        
        person.age = 1
        
        waitForExpectations(timeout: 0.05, handler: nil)
    }
    func newOldPriorSelector_isCalled(newValue: NSNumber?, oldValue: NSNumber?, isPrior: Bool) {
        if isPrior {
            guard let oldValue = oldValue else { XCTFail(); return }
            XCTAssertEqual(self.person.age, oldValue.uintValue)
        } else {
            guard let newValue = newValue else { XCTFail(); return }
            XCTAssertEqual(self.person.age, newValue.uintValue)
        }
        
        expect.fulfill()
    }
    
    func testKeyPathNewOldSelector_isCalledWithKeyPathNewValueAndOldValue() {
        expect = expectation(description: "Selector called")
        
        kvoDelegate.startObserving(keyPath: "age", on: person, keyPathNewOldSelector: #selector(keyPathNewOldSelector_isCalled(keyPath:newValue:oldValue:)), options: [.new, .old])
        
        person.age = 1
        
        waitForExpectations(timeout: 0.05, handler: nil)
    }
    func keyPathNewOldSelector_isCalled(keyPath: String, newValue: NSNumber?, oldValue: NSNumber?) {
        guard let newValue = newValue,
              let oldValue = oldValue
        else { XCTFail(); return }
        
        XCTAssertEqual("age", keyPath)
        XCTAssertEqual(1, newValue.uintValue)
        XCTAssertEqual(0, oldValue.uintValue)
        
        expect.fulfill()
    }
    
    func testKeyPathNewOldPriorSelector_isCalledWithKeyPathNewValueOldValueAndIsPriorValue() {
        expect = expectation(description: "Selector called")
        expect.expectedFulfillmentCount = 2
        
        kvoDelegate.startObserving(keyPath: "age", on: person, keyPathNewOldPriorSelector: #selector(keyPathNewOldPriorSelector_isCalled(keyPath:newValue:oldValue:isPrior:)), options: [.new, .old, .prior])
        
        person.age = 1
        
        waitForExpectations(timeout: 0.05, handler: nil)
    }
    func keyPathNewOldPriorSelector_isCalled(keyPath: String, newValue: NSNumber?, oldValue: NSNumber?, isPrior: Bool) {
        XCTAssertEqual("age", keyPath)
        if isPrior {
            guard let oldValue = oldValue else { XCTFail(); return }
            XCTAssertEqual(self.person.age, oldValue.uintValue)
        } else {
            guard let newValue = newValue else { XCTFail(); return }
            XCTAssertEqual(self.person.age, newValue.uintValue)
        }
        
        expect.fulfill()
    }
    
}
