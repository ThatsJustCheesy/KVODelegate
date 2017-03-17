//
//  KVONotificationDelegator.h
//  KVODelegate
//
//  Created by Ian Gregory on 16-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KVONotificationDelegate;

@protocol KVONotificationDelegator <NSObject>

+ (void)configKVONotificationDelegate:(KVONotificationDelegate *)delegate;

@end
