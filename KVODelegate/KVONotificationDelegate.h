//
//  KVONotificationDelegate.h
//  KVODelegate
//
//  Created by Ian Gregory on 16-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KVONotificationDelegator.h"

NS_ASSUME_NONNULL_BEGIN

@interface KVONotificationDelegate : NSObject

@property (readonly) Class <KVONotificationDelegator> owner;

+ (instancetype)delegateForClass:(Class <KVONotificationDelegator>)clas;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void)key:(NSString *)dependent dependsUponKeyPath:(NSString *)affecting;
- (void)key:(NSString *)dependent dependsUponKeyPaths:(NSArray<NSString*> *)affecting;

- (NSSet<NSString*> *)keyPathsForValuesAffectingValueForKey:(NSString *)key;

@end

#define KVO_DELEGATE_HANDLES_keyPathsForValuesAffectingValueForKey \
    + (NSSet<NSString*> *)keyPathsForValuesAffectingValueForKey:(NSString *)key { \
        return [[KVONotificationDelegate delegateForClass:self] keyPathsForValuesAffectingValueForKey:key]; \
    }

NS_ASSUME_NONNULL_END
