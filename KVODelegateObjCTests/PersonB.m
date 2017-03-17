//
//  Person.m
//  KVODelegate
//
//  Created by Ian Gregory on 16-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

#import "PersonB.h"

@implementation PersonB

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (void)setFullName:(NSString *)fullName {
    NSUInteger spaceLoc = [fullName rangeOfString:@" "].location;
    _firstName = [fullName substringToIndex:spaceLoc];
    _lastName = [fullName substringFromIndex:spaceLoc + 1];
}

+ (void)configKVONotificationDelegate:(KVONotificationDelegate *)delegate {
    [delegate key:@"fullName" dependsUponKeyPaths:@[@"firstName", @"lastName"]];
    [delegate key:@"firstName" dependsUponKeyPath:@"fullName"];
    [delegate key:@"lastName" dependsUponKeyPath:@"fullName"];
}
KVO_DELEGATE_HANDLES_keyPathsForValuesAffectingValueForKey;

@end
