//
//  NotificationDelegateDependentKeysObjCTests.m
//  KVODelegateObjCTests
//
//  Created by Ian Gregory on 12-03-2018.
//  Copyright © 2018 ThatsJustCheesy. All rights reserved.
//

@import XCTest;
@import KVODelegate;

#import "Contact.h"
#import "DefectiveNotificationDelegator.h"

@interface NotificationDelegateDependentKeysObjCTests : XCTestCase

@property KVOObservationDelegate *kvoDelegate;
@property Contact *contact;

@end

@implementation NotificationDelegateDependentKeysObjCTests

- (void)setUp {
    [super setUp];
    
    self.kvoDelegate = [KVOObservationDelegate new];
    self.contact = [Contact new];
}

- (void)tearDown {
    [self.kvoDelegate stopObservingAllKeyPaths];
    
    [super tearDown];
}

- (void)testDefectiveNotificationDelegator_raisesException {
    XCTAssertThrowsSpecificNamed([KVONotificationDelegate delegateForClass:[DefectiveNotificationDelegator class]], NSException, @"KVONotificationDelegateException");
}

- (void)testDelegatedDependentKey_causesChangeDetected {
    __auto_type expect = [self expectationWithDescription:@"Change detected"];
    expect.expectedFulfillmentCount = 2;
    
    [self.kvoDelegate startObservingKeyPath:@"firstName" on:self.contact usingBlock:^{
        [expect fulfill];
    }];
    
    self.contact.firstName = @"Barbara";
    self.contact.fullName = @"Mr. Billy Brown";
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

- (void)testMultipleDelegatedDependentKeys_causeChangeDetected {
    __auto_type expect = [self expectationWithDescription:@"Change detected"];
    expect.expectedFulfillmentCount = 4;
    
    [self.kvoDelegate startObservingKeyPath:@"fullName" on:self.contact usingBlock:^{
        [expect fulfill];
    }];
    
    self.contact.fullName = @"Mr. Billy Brown";
    self.contact.title = @"Mrs.";
    self.contact.firstName = @"Barbara";
    self.contact.lastName = @"Blue";
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

// See Contact.m
- (void)testExternallyDeclaredDependentKey_isFoundByNotificationDelegateAndCausesChangeDetected {
    __auto_type expect = [self expectationWithDescription:@"Change detected"];
    expect.expectedFulfillmentCount = 3;
    
    [self.kvoDelegate startObservingKeyPath:@"titleAndLastName" on:self.contact usingBlock:^{
        [expect fulfill];
    }];
    
    self.contact.titleAndLastName = @"Mr. Brown";
    self.contact.title = @"Mrs.";
    self.contact.lastName = @"Blue";
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

// See Contact.m
- (void)testMixNMatchDelegatedDependentKeyAndExternallyDeclaredDependentKey_bothCauseChangeDetected {
    __auto_type expect = [self expectationWithDescription:@"Change detected"];
    expect.expectedFulfillmentCount = 3;
    
    [self.kvoDelegate startObservingKeyPath:@"lastName" on:self.contact usingBlock:^{
        [expect fulfill];
    }];
    
    self.contact.lastName = @"Blue";
    self.contact.fullName = @"Mr. Billy Brown";
    self.contact.titleAndLastName = @"Mrs. Blue";
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

@end
