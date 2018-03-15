//
//  Person.m
//  KVODelegate
//
//  Created by Ian Gregory on 16-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

#import "Contact.h"

@implementation Contact

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@ %@", self.title, self.firstName, self.lastName];
}
- (void)setFullName:(NSString *)fullName {
    NSUInteger spaceLoc1 = [fullName rangeOfString:@" "].location,
               spaceLoc2 = [fullName rangeOfString:@" " options:0 range:NSMakeRange(spaceLoc1, fullName.length - spaceLoc1 - 1)].location;
    
    _title = [fullName substringToIndex:spaceLoc1];
    _firstName = [fullName substringWithRange:NSMakeRange(spaceLoc1 + 1, spaceLoc2 - spaceLoc1)];
    _lastName = [fullName substringFromIndex:spaceLoc2 + 1];
}

- (NSString *)titleAndLastName {
    return [NSString stringWithFormat:@"%@ %@", self.title, self.lastName];
}
- (void)setTitleAndLastName:(NSString *)titleAndLastName {
    NSUInteger spaceLoc = [titleAndLastName rangeOfString:@" "].location;
    
    _title = [titleAndLastName substringToIndex:spaceLoc];
    _lastName = [titleAndLastName substringFromIndex:spaceLoc + 1];
}

+ (void)configKVONotificationDelegate:(KVONotificationDelegate *)delegate {
    [delegate key:@"firstName" dependsUponKeyPath:@"fullName"];
    [delegate key:@"fullName" dependsUponKeyPaths:@[@"firstName", @"lastName", @"title"]];
    [delegate key:@"title" dependsUponKeyPaths:@[@"fullName", @"titleAndLastName"]];
    [delegate key:@"lastName" dependsUponKeyPath:@"fullName"];
}
KVO_DELEGATE_HANDLES_keyPathsForValuesAffectingValueForKey;

// Should be picked up by -[KVONotificationDelegate keyPathsForValuesAffectingValueForKey:]
+ (NSSet<NSString*> *)keyPathsForValuesAffectingTitleAndLastName {
    return [NSSet<NSString*> setWithObjects:@"title", @"lastName", nil];
}
+ (NSSet<NSString*> *)keyPathsForValuesAffectingLastName {
    return [NSSet<NSString*> setWithObject:@"titleAndLastName"];
}

@end
