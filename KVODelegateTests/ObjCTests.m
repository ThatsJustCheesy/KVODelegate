//
//  KVODelegateTests.m
//  KVODelegateTests
//
//  Created by Ian Gregory on 15-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

@import XCTest;
@import KVODelegate;

@interface Person : NSObject
@property NSString *name, *address, *postalCode;
@property NSArray<NSNumber*> *creditCardNumbers;
@end

@implementation Person
@end

@interface KVODelegateTests : XCTestCase
@property KVOObservationDelegate *kvoDelegate;
@end

@implementation KVODelegateTests

- (void)setUp {
    [super setUp];
    self.kvoDelegate = [KVOObservationDelegate new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)basicObserving1 {
    Person *a = [Person new];
    a.name = @"Bob";
    a.address = @"123 Happy Street";
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    [self.kvoDelegate startObservingKeyPath:@"postalCode" on:a usingBlock:^{
        dispatch_semaphore_signal(sema);
    }];
    
    a.postalCode = @"A1B 2C3";
    
    long timedOut = dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 1000*NSEC_PER_MSEC));
    XCTAssert(timedOut == 0);
    
    [self.kvoDelegate stopObservingAllKeyPathsOn:a];
}

@end
