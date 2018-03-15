//
//  ObservationDelegateSelectorObjCTests.m
//  KVODelegateObjCTests
//
//  Created by Ian Gregory on 12-03-2018.
//  Copyright © 2018 ThatsJustCheesy. All rights reserved.
//

@import XCTest;
@import KVODelegate;

#import "Person.h"

@interface ObservationDelegateSelectorObjCTests : XCTestCase

@property KVOObservationDelegate<ObservationDelegateSelectorObjCTests*> *kvoDelegate;
@property Person *person;

@property XCTestExpectation *expect;

@end

@implementation ObservationDelegateSelectorObjCTests

- (void)setUp {
    [super setUp];
    
    self.kvoDelegate = [KVOObservationDelegate<ObservationDelegateSelectorObjCTests*> delegateWithOwner:self];
    self.person = [Person new];
}

- (void)tearDown {
    [self.kvoDelegate stopObservingAllKeyPaths];
    
    [super tearDown];
}

- (void)testNoParamsSelector_isCalledAndStopsWhenTold {
    self.expect = [self expectationWithDescription:@"Selector called"];
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person callingSelector:@selector(noParamsSelector_isCalledAndStopsWhenTold)];
    self.person.age = 1;
    
    [self.kvoDelegate stopObservingKeyPath:@"age" on:self.person];
    self.person.age = 2;
    // self.expect should not overfulfill
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}
- (void)noParamsSelector_isCalledAndStopsWhenTold {
    [self.expect fulfill];
}

- (void)testNoParamsSelectorWithOptions_isCalled {
    self.expect = [self expectationWithDescription:@"Selector called"];
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person callingSelector:@selector(noParamsSelectorWithOptions_isCalled) options:0];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}
- (void)noParamsSelectorWithOptions_isCalled {
    [self.expect fulfill];
}

- (void)testKeyPathSelector_isCalledWithKeyPath {
    self.expect = [self expectationWithDescription:@"Selector called"];
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person callingKeyPathSelector:@selector(keyPathSelector_isCalledWithKeyPath:) options:0];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}
- (void)keyPathSelector_isCalledWithKeyPath:(NSString *)keyPath {
    XCTAssertEqualObjects(@"age", keyPath);
    
    [self.expect fulfill];
}

- (void)testNewOldSelector_isCalledWithNewValueAndOldValue {
    self.expect = [self expectationWithDescription:@"Selector called"];
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person callingNewOldSelector:@selector(newOldSelector_isCalledWithNewValue:oldValue:) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}
- (void)newOldSelector_isCalledWithNewValue:(NSNumber *)newValue oldValue:(NSNumber *)oldValue {
    XCTAssertNotNil(newValue);
    XCTAssertNotNil(oldValue);
    
    XCTAssertEqual(1, newValue.unsignedIntegerValue);
    XCTAssertEqual(0, oldValue.unsignedIntegerValue);
    
    [self.expect fulfill];
}

- (void)testNewOldPriorSelector_isCalledWithNewValueOldValueAndIsPriorValue {
    self.expect = [self expectationWithDescription:@"Selector called"];
    self.expect.expectedFulfillmentCount = 2;
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person callingNewOldPriorSelector:@selector(newOldPriorSelector_isCalledWithNewValue:oldValue:isPriorValue:) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}
- (void)newOldPriorSelector_isCalledWithNewValue:(NSNumber *)newValue oldValue:(NSNumber *)oldValue isPriorValue:(BOOL)isPrior {
    if (isPrior) {
        XCTAssertEqual(self.person.age, [oldValue unsignedIntegerValue]);
    } else {
        XCTAssertEqual(self.person.age, [newValue unsignedIntegerValue]);
    }
    
    [self.expect fulfill];
}

- (void)testKeyPathNewOldSelector_isCalledWithKeyPathNewValueAndOldValue {
    self.expect = [self expectationWithDescription:@"Selector called"];
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person callingKeyPathNewOldSelector:@selector(keyPathNewOldSelector_isCalledWithKeyPath:newValue:oldValue:) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}
- (void)keyPathNewOldSelector_isCalledWithKeyPath:(NSString *)keyPath newValue:(NSNumber *)newValue oldValue:(NSNumber *)oldValue {
    XCTAssertEqualObjects(@"age", keyPath);
    XCTAssertNotNil(newValue);
    XCTAssertNotNil(oldValue);
    
    XCTAssertEqual(1, newValue.unsignedIntegerValue);
    XCTAssertEqual(0, oldValue.unsignedIntegerValue);
    
    [self.expect fulfill];
}

- (void)testKeyPathNewOldPriorSelector_isCalledWithKeyPathNewValueOldValueAndIsPriorValue {
    self.expect = [self expectationWithDescription:@"Selector called"];
    self.expect.expectedFulfillmentCount = 2;
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person callingKeyPathNewOldPriorSelector:@selector(keyPathNewOldPriorSelector_isCalledWithKeyPath:newValue:oldValue:isPriorValue:) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}
- (void)keyPathNewOldPriorSelector_isCalledWithKeyPath:(NSString *)keyPath newValue:(NSNumber *)newValue oldValue:(NSNumber *)oldValue isPriorValue:(BOOL)isPrior {
    XCTAssertEqualObjects(@"age", keyPath);
    if (isPrior) {
        XCTAssertEqual(self.person.age, [oldValue unsignedIntegerValue]);
    } else {
        XCTAssertEqual(self.person.age, [newValue unsignedIntegerValue]);
    }
    
    [self.expect fulfill];
}

- (void)testChangeDictionarySelector_isCalledWithChangeDictionary {
    self.expect = [self expectationWithDescription:@"Selector called"];
    self.expect.expectedFulfillmentCount = 2;
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person callingChangeDictionarySelector:@selector(changeDictionarySelector_isCalledWithChangeDictionary:) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}
- (void)changeDictionarySelector_isCalledWithChangeDictionary:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    XCTAssertNotNil(change);
    if ([change[NSKeyValueChangeNotificationIsPriorKey] boolValue]) {
        XCTAssertEqual(self.person.age, [change[NSKeyValueChangeOldKey] unsignedIntegerValue]);
    } else {
        XCTAssertEqual(self.person.age, [change[NSKeyValueChangeNewKey] unsignedIntegerValue]);
    }
    
    [self.expect fulfill];
}

@end
