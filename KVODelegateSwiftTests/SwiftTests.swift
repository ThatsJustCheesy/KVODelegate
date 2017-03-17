//
//  SwiftTests.swift
//  KVODelegate
//
//  Created by Ian Gregory on 15-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

import XCTest
import KVODelegate

class Person: NSObject {
    dynamic var name = "", address = "", postalCode = ""
    dynamic var creditCardNumbers: [Int] = []
}

class KVODelegateTests: XCTestCase {
    
    var kvoDelegate = KVOObservationDelegate()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBasicObserving() {
        let a = Person()
        a.address = "123 Happy Street"
        
        let sema = DispatchSemaphore(value: 0)
        let timeout = DispatchTime.now() + DispatchTimeInterval.milliseconds(1000)
        var signalReceived: DispatchTimeoutResult
        
        kvoDelegate.startObserving(keyPath: "postalCode", on: a, using: {
            sema.signal()
        })
        a.postalCode = "A1B 2C3"
        signalReceived = sema.wait(timeout: timeout)
        XCTAssert(signalReceived == .success)
        
        kvoDelegate.stopObserving(keyPath: "postalCode", on: a)
        a.postalCode = "A1B 2C4"
        signalReceived = sema.wait(timeout: timeout)
        XCTAssert(signalReceived == .timedOut)
        
        kvoDelegate.startObserving(keyPath: "address", on: a, using: { (new, old) in
            XCTAssert(a.address.isEqual(new))
            if let new = new as? String, let old = old as? String {
                if new.contains(old.substring(from: old.index(old.startIndex, offsetBy: 4))) {
                    a.postalCode = "A1B 2D4"
                } else {
                    a.postalCode = "X7Y 8Z9"
                }
            }
            sema.signal()
        }, options: [.new, .old])
        a.address = "456 Happy Street"
        signalReceived = sema.wait(timeout: timeout)
        XCTAssert(signalReceived == .success)
        XCTAssert(a.postalCode == "A1B 2D4")
        a.address = "1 Cherry Lane"
        signalReceived = sema.wait(timeout: timeout)
        XCTAssert(signalReceived == .success)
        XCTAssert(a.postalCode == "X7Y 8Z9")
        
        kvoDelegate.stopObserving(keyPath: "address", on: a)
        
        kvoDelegate.stopObserving(allKeyPathsOn: a)
    }
    
}
