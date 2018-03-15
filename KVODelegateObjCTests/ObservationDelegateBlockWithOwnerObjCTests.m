//
//  ObservationDelegateBlockWithOwnerObjCTests.m
//  KVODelegateObjCTests
//
//  Created by Ian Gregory on 12-03-2018.
//  Copyright © 2018 ThatsJustCheesy. All rights reserved.
//

@import XCTest;
@import KVODelegate;

#import "Person.h"

@interface ObservationDelegateBlockWithOwnerObjCTests : XCTestCase

@property KVOObservationDelegate<ObservationDelegateBlockWithOwnerObjCTests*> *kvoDelegate;
@property Person *person;

@end

@implementation ObservationDelegateBlockWithOwnerObjCTests

- (void)setUp {
    [super setUp];
    
    self.kvoDelegate = [KVOObservationDelegate<ObservationDelegateBlockWithOwnerObjCTests*> delegateWithOwner:self];
    self.person = [Person new];
}

- (void)tearDown {
    [self.kvoDelegate stopObservingAllKeyPaths];
    
    [super tearDown];
}

- (void)testObservationDelegate_usesWeakReference {
    KVOObservationDelegate<NSObject*> *objectKVODelegate;
    
    @autoreleasepool {
        NSObject *object = [NSObject new];
        XCTAssertNotNil(object);
        
        objectKVODelegate = [KVOObservationDelegate<NSObject*> delegateWithOwner:object];
        XCTAssertEqual(object, objectKVODelegate.owner);
    }
    
    XCTAssertNil(objectKVODelegate.owner);
}

- (void)testWeakSelfBlock_providesSelf {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingWeakSelfBlock:^(ObservationDelegateBlockWithOwnerObjCTests *weakSelf) {
        XCTAssertEqual(self, weakSelf);
        
        [expect fulfill];
    }];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

- (void)testWeakSelfBlockWithOptions_providesSelf {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingWeakSelfBlock:^(ObservationDelegateBlockWithOwnerObjCTests *weakSelf) {
        XCTAssertEqual(self, weakSelf);
        
        [expect fulfill];
    } options:0];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

- (void)testWeakSelfKeyPathBlock_providesSelfAndKeyPath {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingWeakSelfKeyPathBlock:^(ObservationDelegateBlockWithOwnerObjCTests *weakSelf, NSString *keyPath) {
        XCTAssertEqual(self, weakSelf);
        XCTAssertEqualObjects(@"age", keyPath);
        
        [expect fulfill];
    } options:0];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

- (void)testWeakSelfNewOldBlock_providesSelfNewValueAndOldValue {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingWeakSelfNewOldBlock:^(ObservationDelegateBlockWithOwnerObjCTests *weakSelf, NSNumber *newValue, NSNumber *oldValue) {
        XCTAssertNotNil(newValue);
        XCTAssertNotNil(oldValue);
        
        XCTAssertEqual(self, weakSelf);
        XCTAssertEqual(1, newValue.unsignedIntegerValue);
        XCTAssertEqual(0, oldValue.unsignedIntegerValue);
        
        [expect fulfill];
    } options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

- (void)testWeakSelfNewOldPriorBlock_providesSelfNewValueOldValueAndIsPriorValue {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    expect.expectedFulfillmentCount = 2;
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingWeakSelfNewOldPriorBlock:^(ObservationDelegateBlockWithOwnerObjCTests *weakSelf, NSNumber *newValue, NSNumber *oldValue, BOOL isPrior) {
        XCTAssertEqual(self, weakSelf);
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

- (void)testWeakSelfKeyPathNewOldBlock_providesSelfKeyPathNewValueAndOldValue {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingWeakSelfKeyPathNewOldBlock:^(ObservationDelegateBlockWithOwnerObjCTests *weakSelf, NSString *keyPath, NSNumber *newValue, NSNumber *oldValue) {
        XCTAssertNotNil(newValue);
        XCTAssertNotNil(oldValue);
        
        XCTAssertEqual(self, weakSelf);
        XCTAssertEqualObjects(@"age", keyPath);
        XCTAssertEqual(1, newValue.unsignedIntegerValue);
        XCTAssertEqual(0, oldValue.unsignedIntegerValue);
        
        [expect fulfill];
    } options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

- (void)testWeakSelfKeyPathNewOldPriorBlock_providesSelfKeyPathNewValueOldValueAndIsPriorValue {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    expect.expectedFulfillmentCount = 2;
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingWeakSelfKeyPathNewOldPriorBlock:^(ObservationDelegateBlockWithOwnerObjCTests *weakSelf, NSString *keyPath, NSNumber *newValue, NSNumber *oldValue, BOOL isPrior) {
        XCTAssertEqual(self, weakSelf);
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

- (void)testWeakSelfChangeDictionaryBlock_providesSelfAndAmendedChangeDictionary {
    __auto_type expect = [self expectationWithDescription:@"Block called"];
    
    [self.kvoDelegate startObservingKeyPath:@"age" on:self.person usingWeakSelfChangeDictionaryBlock:^(ObservationDelegateBlockWithOwnerObjCTests *weakSelf, NSDictionary<NSKeyValueChangeKey,id> *change) {
        XCTAssertNotNil(change);
        
        XCTAssertEqual(self, weakSelf);
        XCTAssertEqual(1, [change[NSKeyValueChangeNewKey] unsignedIntegerValue]);
        XCTAssertEqual(self.person, change[kKVOKeyValueChangeKeyObject]);
        XCTAssertEqual(@"age", change[kKVOKeyValueChangeKeyKeyPath]);
        
        [expect fulfill];
    } options:NSKeyValueObservingOptionNew];
    
    self.person.age = 1;
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

@end
