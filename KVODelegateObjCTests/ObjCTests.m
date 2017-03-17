//
//  KVODelegateTests.m
//  KVODelegateTests
//
//  Created by Ian Gregory on 15-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

@import XCTest;
@import KVODelegate;

#import "PersonA.h"
#import "PersonB.h"

@interface KVODelegateTests : XCTestCase
@property KVOObservationDelegate *kvoDelegate;
@end

@implementation KVODelegateTests

- (void)setUp {
    [super setUp];
    self.kvoDelegate = [KVOObservationDelegate new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testBasicObserving {
    PersonA *a = [PersonA new];
    a.address = @"123 Happy Street";
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 1000*NSEC_PER_MSEC);
    long signalReceived;
    
    [self.kvoDelegate startObservingKeyPath:@"postalCode" on:a usingBlock:^{
        dispatch_semaphore_signal(sema);
    }];
    a.postalCode = @"A1B 2C3";
    signalReceived = dispatch_semaphore_wait(sema, timeout);
    XCTAssert(signalReceived == 0);
    
    [self.kvoDelegate stopObservingKeyPath:@"postalCode" on:a];
    a.postalCode = @"A1B 2C4";
    signalReceived = dispatch_semaphore_wait(sema, timeout);
    XCTAssert(signalReceived != 0);
    
    [self.kvoDelegate startObservingKeyPath:@"address" on:a usingNewOldBlock:^(id newValue, id oldValue) {
        XCTAssert([a.address isEqual:newValue]);
        if ([newValue containsString:[oldValue substringFromIndex:4]]) a.postalCode = @"A1B 2D4";
        else a.postalCode = @"X7Y 8Z9";
        dispatch_semaphore_signal(sema);
    } options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld];
    a.address = @"456 Happy Street";
    signalReceived = dispatch_semaphore_wait(sema, timeout);
    XCTAssert(signalReceived == 0);
    XCTAssert([a.postalCode isEqualToString:@"A1B 2D4"]);
    a.address = @"1 Cherry Lane";
    signalReceived = dispatch_semaphore_wait(sema, timeout);
    XCTAssert(signalReceived == 0);
    XCTAssert([a.postalCode isEqualToString:@"X7Y 8Z9"]);
    
    [self.kvoDelegate stopObservingAllKeyPathsOn:a];
}

- (void)testDependentKeys {
    PersonB *b = [PersonB new];
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 1000*NSEC_PER_MSEC);
    long signalReceived;
    
    [self.kvoDelegate startObservingKeyPath:@"fullName" on:b usingBlock:^{
        dispatch_semaphore_signal(sema);
    }];
    b.fullName = @"Billy Brown";
    signalReceived = dispatch_semaphore_wait(sema, timeout);
    XCTAssert(signalReceived == 0);
    b.firstName = @"Barbara";
    signalReceived = dispatch_semaphore_wait(sema, timeout);
    XCTAssert(signalReceived == 0);
    b.lastName = @"Blue";
    signalReceived = dispatch_semaphore_wait(sema, timeout);
    XCTAssert(signalReceived == 0);
    
    [self.kvoDelegate stopObservingAllKeyPathsOn:b];
}

@end
