//
//  ObservationDelegateBlockObjCTests.m
//  ObservationDelegateBlockObjCTests
//
//  Created by Ian Gregory on 15-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

@import XCTest;
@import KVODelegate;

#import "Person.h"

@interface ObservationDelegateBlockObjCTests : XCTestCase

@property KVOObservationDelegate *kvoDelegate;
@property Person *person;

@end

@implementation ObservationDelegateBlockObjCTests

- (void)setUp {
    [super setUp];
    
    self.kvoDelegate = [KVOObservationDelegate new];
    self.person = [Person new];
}

- (void)tearDown {
    [self.kvoDelegate stopObservingAllKeyPaths];
    
    [super tearDown];
}

- (void)testNoParamsBlock_isCalledAndStopsWhenTold {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingBlock:^{
        [expect fulfill];
    }];
    self.person.age = 1;
    
    [self.kvoDelegate stopObservingKeyPath:@"age" on:self.person];
    self.person.age = 2;
    // expect should not overfulfill
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

- (void)testNoParamsBlockWithOptions_isCalled {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingBlock:^{
        [expect fulfill];
    } options:0];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

- (void)testKeyPathBlock_providesKeyPath {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingKeyPathBlock:^(NSString *keyPath){
        XCTAssertEqualObjects(@"age", keyPath);
        
        [expect fulfill];
    } options:0];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

- (void)testNewOldBlock_providesNewValueAndOldValue {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingNewOldBlock:^(NSNumber *newValue, NSNumber *oldValue) {
        XCTAssertNotNil(newValue);
        XCTAssertNotNil(oldValue);
        
        XCTAssertEqual(1, newValue.unsignedIntegerValue);
        XCTAssertEqual(0, oldValue.unsignedIntegerValue);
        
        [expect fulfill];
    } options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

- (void)testNewOldPriorBlock_providesNewValueOldValueAndIsPriorValue {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    expect.expectedFulfillmentCount = 2;
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingNewOldPriorBlock:^(NSNumber *newValue, NSNumber *oldValue, BOOL isPrior) {
        if (isPrior) {
            XCTAssertEqual(self.person.age, [oldValue unsignedIntegerValue]);
        } else {
            XCTAssertEqual(self.person.age, [newValue unsignedIntegerValue]);
        }
        
        [expect fulfill];
    } options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

- (void)testKeyPathNewOldBlock_providesKeyPathNewValueAndOldValue {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingKeyPathNewOldBlock:^(NSString *keyPath, NSNumber *newValue, NSNumber *oldValue) {
        XCTAssertEqualObjects(@"age", keyPath);
        XCTAssertNotNil(newValue);
        XCTAssertNotNil(oldValue);
        
        XCTAssertEqual(1, newValue.unsignedIntegerValue);
        XCTAssertEqual(0, oldValue.unsignedIntegerValue);
        
        [expect fulfill];
    } options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

- (void)testKeyPathNewOldPriorBlock_providesKeyPathNewValueOldValueAndIsPriorValue {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    expect.expectedFulfillmentCount = 2;
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingKeyPathNewOldPriorBlock:^(NSString *keyPath, NSNumber *newValue, NSNumber *oldValue, BOOL isPrior) {
        XCTAssertEqualObjects(@"age", keyPath);
        if (isPrior) {
            XCTAssertEqual(self.person.age, [oldValue unsignedIntegerValue]);
        } else {
            XCTAssertEqual(self.person.age, [newValue unsignedIntegerValue]);
        }
        
        [expect fulfill];
    } options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

- (void)testChangeDictionaryBlock_providesChangeDictionary {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    expect.expectedFulfillmentCount = 2;
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingChangeDictionaryBlock:^(NSDictionary<NSKeyValueChangeKey,id> *change) {
        XCTAssertNotNil(change);
        if ([change[NSKeyValueChangeNotificationIsPriorKey] boolValue]) {
            XCTAssertEqual(self.person.age, [change[NSKeyValueChangeOldKey] unsignedIntegerValue]);
        } else {
            XCTAssertEqual(self.person.age, [change[NSKeyValueChangeNewKey] unsignedIntegerValue]);
        }
        
        [expect fulfill];
    } options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

- (void)testChangeDictionaryBlock_providesAmendedChangeDictionaryByDefault {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingChangeDictionaryBlock:^(NSDictionary<NSKeyValueChangeKey,id> *change) {
        XCTAssertNotNil(change);
        
        XCTAssertEqual(self.person, change[kKVOKeyValueChangeKeyObject]);
        XCTAssertEqual(@"age", change[kKVOKeyValueChangeKeyKeyPath]);
        
        [expect fulfill];
    } options:0];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

- (void)testChangeDictionaryBlock_providesUnamendedChangeDictionaryIfInstructedTo {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    expect.expectedFulfillmentCount = 2;
    
    self.kvoDelegate.vendsUnmodifiedChangeDictionaries = YES;
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingChangeDictionaryBlock:^(NSDictionary<NSKeyValueChangeKey,id> *change) {
        XCTAssertNotNil(change);
        
        if (self.person.age == 0) {
            XCTAssertNotNil(change[NSKeyValueChangeNotificationIsPriorKey]);
        }
        
        XCTAssertNil(change[kKVOKeyValueChangeKeyObject]);
        XCTAssertNil(change[kKVOKeyValueChangeKeyKeyPath]);
        
        [expect fulfill];
    } options:NSKeyValueObservingOptionPrior];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

- (void)testNSNullNewValueOrOldValue_isConvertedToNil {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    expect.expectedFulfillmentCount = 3;
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingNewOldPriorBlock:^(NSNumber *newValue, NSNumber *oldValue, BOOL isPrior) {
        if (isPrior) {
            // There is never a new value for a prior notification
            XCTAssertNil(newValue);
        } else if (self.person.age == 0) /* initial */ {
            // There is never an old value for an initial notification
            XCTAssertNil(oldValue);
        }
        
        [expect fulfill];
    } options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior|NSKeyValueObservingOptionInitial];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

@end
