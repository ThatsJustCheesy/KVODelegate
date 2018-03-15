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

static NSMutableDictionary<Class <KVONotificationDelegator>,KVONotificationDelegate*> *delegates_;

@implementation KVONotificationDelegate

+ (instancetype)delegateForClass:(Class <KVONotificationDelegator>)clas {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        delegates_ = [NSMutableDictionary dictionary];
    });
    
    KVONotificationDelegate *delegate = delegates_[clas];
    if (delegate) return delegate;
    
    delegate = [[self alloc] initWithOwner:clas];
    delegates_[(Class <NSCopying>)clas] = delegate;
    
    if ([clas respondsToSelector:@selector(configKVONotificationDelegate:)]) {
        ((void(*)(Class self, SEL _cmd, KVONotificationDelegate *delegate))objc_msgSend)
            (clas, @selector(configKVONotificationDelegate:), delegate);
    } else {
        [NSException raise:@"KVONotificationDelegateException" format:@"KVONotificationDelegate requested for class '%@', but it does not respond to +configKVONotificationDelegate: (the requested delegate will be useless)", clas];
    }
    
    return delegate;
}

- (instancetype)initWithOwner:(Class)owner {
    self = [super init];
    if (!self) return nil;
    
    _owner = owner;
    
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
    if (keys) return keys;
    
    keys = [NSMutableSet set];
    self.dependentKeys[key] = keys;
    return keys;
}

- (NSSet<NSString*> *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSMutableSet<NSString*> *affecting = [NSMutableSet set];
    
    // Retrieve affecting key paths from the superclass's implementation
    [affecting unionSet:[self.owner.superclass keyPathsForValuesAffectingValueForKey:key]];
    
    // Grab NSObject's +keyPathsForValuesAffectingValueForKey (which handles calling keyPathsForValuesAffecting<Key> methods for us) and copy it to this delegate's owner class under an addressable name
    SEL selector = sel_registerName("KVO_NSObject_keyPathsForValuesAffectingValueForKey:");
    if (![self.owner respondsToSelector:selector]) {
        IMP implementation = class_getMethodImplementation(objc_getMetaClass("NSObject"), @selector(keyPathsForValuesAffectingValueForKey:));
        BOOL success = class_addMethod(object_getClass(self.owner), selector, implementation, "@@:@");
        NSAssert(success, @"Failed to add addressable +[NSObject keyPathsForValuesAffectingValueForKey] to class '%@'", self.owner);
    }
    
    // Call NSObject's implementation, which retrieves affecting key paths from any keyPathsForValuesAffecting<Key> methods
    [affecting unionSet:((NSSet<NSString*>*(*)(id self, SEL _cmd, NSString *key))objc_msgSend)(
        self.owner, selector, key)];
    
    // Backup implementation in case +[NSObject keyPathsForValuesAffectingValueForKey:] changes its implementation some day
//    char upcasedFirstLetterOfKey = [key characterAtIndex:0] - ('a' - 'A');
//    SEL keyNameSelector = NSSelectorFromString([NSString stringWithFormat:@"keyPathsForValuesAffecting%c%@", upcasedFirstLetterOfKey, [key substringFromIndex:1]]);
//    if ([self.owner respondsToSelector:keyNameSelector]) {
//        [affecting unionSet:((NSSet<NSString*>*(*)(id self, SEL _cmd))objc_msgSend)(self.owner, keyNameSelector)];
//    }
    
    // Finally, add in affecting keys that were declared in +configKVONotificationDelegate
    [affecting unionSet:[self dependentKeyPathsSetForKey:key]];
    
    return affecting;
}

@end
