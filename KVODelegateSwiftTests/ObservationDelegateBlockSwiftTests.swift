//
//  SwiftTests.swift
//  KVODelegate
//
//  Created by Ian Gregory on 15-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

import XCTest
import KVODelegate

class ObservationDelegateBlockSwiftTests: XCTestCase {
    
    var kvoDelegate = KVOObservationDelegate()
    var person = Person()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        kvoDelegate.stopObservingAllKeyPaths()
        
        super.tearDown()
    }
    
    func testNoParamsBlock_isCalledAndStopsWhenTold() {
        let expect = expectation(description: "Block called")
        
        kvoDelegate.startObserving(keyPath: "age", on: person, using: {
            expect.fulfill()
        });
        person.age = 1
        
        kvoDelegate.stopObserving(keyPath: "age", on: person)
        person.age = 2
        // expect should not overfulfill
        
        waitForExpectations(timeout: 0.05, handler: nil)
    }
    
    func testNoParamsBlockWithOptions_isCalled() {
        let expect = expectation(description: "Block called")
        
        kvoDelegate.startObserving(keyPath: "age", on: person, using: {
            expect.fulfill()
        }, options: [])
        
        person.age = 1
        
        waitForExpectations(timeout: 0.05, handler: nil)
    }
    
    func testKeyPathBlock_providesKeyPath() {
        let expect = expectation(description: "Block called")
        
        kvoDelegate.startObserving(keyPath: "age", on: person, using: { (keyPath: String) in
            XCTAssertEqual("age", keyPath)
            
            expect.fulfill()
        }, options: [])
        
        person.age = 1
        
        waitForExpectations(timeout: 0.05, handler: nil)
    }
    
    func testNewOldBlock_providesNewValueAndOldValue() {
        let expect = expectation(description: "Block called")
        
        kvoDelegate.startObserving(keyPath: "age", on: person, using: { (newValue: Any?, oldValue: Any?) in
            guard let newValue = newValue as? NSNumber,
                  let oldValue = oldValue as? NSNumber
            else { XCTFail(); return }
            
            XCTAssertEqual(1, newValue.uintValue)
            XCTAssertEqual(0, oldValue.uintValue)
            
            expect.fulfill()
        }, options: [NSKeyValueObservingOptions.new, .old])
        
        person.age = 1
        
        waitForExpectations(timeout: 0.05, handler: nil)
    }
    
    func testNewOldPriorBlock_providesNewValueOldValueAndIsPriorValue() {
        let expect = expectation(description: "Block called")
        expect.expectedFulfillmentCount = 2
        
        kvoDelegate.startObserving(keyPath: "age", on: person, using: { (newValue: Any?, oldValue: Any?, isPrior: Bool) in
            if isPrior {
                guard let oldValue = oldValue as? NSNumber else { XCTFail(); return }
                XCTAssertEqual(self.person.age, oldValue.uintValue)
            } else {
                guard let newValue = newValue as? NSNumber else { XCTFail(); return }
                XCTAssertEqual(self.person.age, newValue.uintValue)
            }
            
            expect.fulfill()
        }, options: [NSKeyValueObservingOptions.new, .old, .prior])
        
        person.age = 1
        
        waitForExpectations(timeout: 0.05, handler: nil)
    }
    
    func testKeyPathNewOldBlock_providesKeyPathNewValueAndOldValue() {
        let expect = expectation(description: "Block called")
        
        kvoDelegate.startObserving(keyPath: "age", on: person, using: { (keyPath: String, newValue: Any?, oldValue: Any?) in
            guard let newValue = newValue as? NSNumber,
                  let oldValue = oldValue as? NSNumber
            else { XCTFail(); return }
            
            XCTAssertEqual("age", keyPath)
            XCTAssertEqual(1, newValue.uintValue)
            XCTAssertEqual(0, oldValue.uintValue)
            
            expect.fulfill()
        }, options: [NSKeyValueObservingOptions.new, .old])
        
        person.age = 1
        
        waitForExpectations(timeout: 0.05, handler: nil)
    }
    
    func testKeyPathNewOldPriorBlock_providesKeyPathNewValueOldValueAndIsPriorValue() {
        let expect = expectation(description: "Block called")
        expect.expectedFulfillmentCount = 2
        
        kvoDelegate.startObserving(keyPath: "age", on: person, using: { (keyPath: String, newValue: Any?, oldValue: Any?, isPrior: Bool) in
            XCTAssertEqual("age", keyPath)
            if isPrior {
                guard let oldValue = oldValue as? NSNumber else { XCTFail(); return }
                XCTAssertEqual(self.person.age, oldValue.uintValue)
            } else {
                guard let newValue = newValue as? NSNumber else { XCTFail(); return }
                XCTAssertEqual(self.person.age, newValue.uintValue)
            }
            
            expect.fulfill()
        }, options: [NSKeyValueObservingOptions.new, .old, .prior])
        
        person.age = 1
        
        waitForExpectations(timeout: 0.05, handler: nil)
    }
    
    func testChangeDictionaryBlock_providesChangeDictionary() {
        let expect = expectation(description: "Block called")
        expect.expectedFulfillmentCount = 2
        
        kvoDelegate.startObserving(keyPath: "age", on: person, using: { (change: [NSKeyValueChangeKey : Any]) in
            if (change[NSKeyValueChangeKey.notificationIsPriorKey] as? NSNumber)?.boolValue ?? false {
                XCTAssertEqual(self.person.age, (change[NSKeyValueChangeKey.oldKey] as! NSNumber).uintValue)
            } else {
                XCTAssertEqual(self.person.age, (change[NSKeyValueChangeKey.newKey] as! NSNumber).uintValue)
            }
            
            expect.fulfill()
        }, options: [NSKeyValueObservingOptions.new, .old, .prior])
        
        person.age = 1
        
        waitForExpectations(timeout: 0.05, handler: nil)
    }

}
