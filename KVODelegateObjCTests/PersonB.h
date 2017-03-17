//
//  Person.h
//  KVODelegate
//
//  Created by Ian Gregory on 16-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

@import Foundation;
@import KVODelegate;

@interface PersonB : NSObject <KVONotificationDelegator>

@property NSString *firstName, *lastName, *fullName, *address, *postalCode;
@property NSArray<NSNumber*> *creditCardNumbers;

@end
