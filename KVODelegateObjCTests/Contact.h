//
//  Person.h
//  KVODelegate
//
//  Created by Ian Gregory on 16-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

@import Foundation;
@import KVODelegate;

@interface Contact : NSObject <KVONotificationDelegator>

@property NSString *firstName, *lastName, *title, *fullName, *titleAndLastName;

@end
