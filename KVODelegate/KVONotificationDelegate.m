//
//  KVONotificationDelegate.m
//  KVODelegate
//
//  Created by Ian Gregory on 16-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

#import "KVONotificationDelegate.h"

#import <objc/message.h>

@interface KVONotificationDelegate ()

@property (readwrite) Class <KVONotificationDelegator> owner;
@property NSMutableDictionary<NSString*,NSMutableSet<NSString*>*> *dependentKeys;

@end

static NSMutableDictionary<Class <KVONotificationDelegator>,KVONotificationDelegate*> *_delegates;

@implementation KVONotificationDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"
+ (instancetype)delegateForClass:(Class <KVONotificationDelegator>)clas {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _delegates = [NSMutableDictionary dictionary];
    });
    
    KVONotificationDelegate *delegate = _delegates[clas];
    if (!delegate) {
        delegate = _delegates[(Class <NSCopying>)clas] = [[self alloc] initWithOwner:clas];
        if ([clas respondsToSelector:@selector(configKVONotificationDelegate:)]) {
            [clas performSelector:@selector(configKVONotificationDelegate:) withObject:delegate];
        } else {
            [NSException raise:@"KVONotificationDelegateException" format:@"KVONotificationDelegate requested for class '%@', but it does not respond to +configKVONotificationDelegate (the requested delegate will be useless)", clas];
        }
    }
    
    return delegate;
}
#pragma clang diagnostic pop

- (instancetype)initWithOwner:(Class)owner {
    self = [super init];
    if (!self) return nil;
    
    self.owner = owner;
    
    return self;
}

- (void)key:(NSString *)dependent dependsUponKeyPath:(NSString *)affecting {
    [[self dependentKeyPathsSetForKey:dependent] addObject:affecting];
}

- (void)key:(NSString *)dependent dependsUponKeyPaths:(NSArray<NSString*> *)affecting {
    [[self dependentKeyPathsSetForKey:dependent] addObjectsFromArray:affecting];
}

- (NSMutableSet<NSString*> *)dependentKeyPathsSetForKey:(NSString *)key {
    if (!self.dependentKeys) self.dependentKeys = [NSMutableDictionary dictionary];

    NSMutableSet<NSString*> *keys = self.dependentKeys[key];
    if (!keys) keys = self.dependentKeys[key] = [NSMutableSet set];
    
    return keys;
}

- (NSSet<NSString*> *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSMutableSet<NSString*> *affecting = [NSMutableSet set];
    Class ownerSuper = self.owner.superclass;
    
    [affecting unionSet:[ownerSuper keyPathsForValuesAffectingValueForKey:key]];
    
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"keyPathsForValuesAffecting%@", key]);
    if ([ownerSuper respondsToSelector:sel]) {
        // ARC killed performSelector: for dynamic selectors
        [affecting unionSet:((NSSet<NSString*>* (*)(id, SEL))objc_msgSend)(ownerSuper, sel)];
    }
    
    [affecting unionSet:self.dependentKeys[key]];
    
    return affecting;
}

@end
