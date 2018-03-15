//
//  KVOObservationDelegate.m
//  KVODelegate
//
//  Created by Ian Gregory on 11-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

#import "KVOObservationDelegate.h"

#import <objc/message.h>

const KVOKeyValueChangeKey kKVOKeyValueChangeKeyObject = @"KVOKeyValueChangeKeyObject";
const KVOKeyValueChangeKey kKVOKeyValueChangeKeyKeyPath = @"KVOKeyValueChangeKeyKeyPath";

typedef NS_ENUM(NSInteger, KVOCallbackType) {
    eKVOCallbackTypeBlockNoParams,
    eKVOCallbackTypeBlockWeakSelf,
    eKVOCallbackTypeBlockKeyPath,
    eKVOCallbackTypeBlockNewOld,
    eKVOCallbackTypeBlockNewOldPrior,
    eKVOCallbackTypeBlockWeakSelfKeyPath,
    eKVOCallbackTypeBlockWeakSelfNewOld,
    eKVOCallbackTypeBlockWeakSelfNewOldPrior,
    eKVOCallbackTypeBlockKeyPathNewOld,
    eKVOCallbackTypeBlockKeyPathNewOldPrior,
    eKVOCallbackTypeBlockWeakSelfKeyPathNewOld,
    eKVOCallbackTypeBlockWeakSelfKeyPathNewOldPrior,
    eKVOCallbackTypeBlockChangeDictionary,
    eKVOCallbackTypeBlockWeakSelfChangeDictionary,
    
    eKVOCallbackTypeSelectorNoParams,
    eKVOCallbackTypeSelectorKeyPath,
    eKVOCallbackTypeSelectorNewOld,
    eKVOCallbackTypeSelectorNewOldPrior,
    eKVOCallbackTypeSelectorKeyPathNewOld,
    eKVOCallbackTypeSelectorKeyPathNewOldPrior,
    eKVOCallbackTypeSelectorChangeDictionary
};
typedef NSDictionary<NSString*,id>* KVOObservationAttributesDict;
typedef NSMutableDictionary<NSString*,KVOObservationAttributesDict>* KVOKeyPathsDict;

typedef NSString* KVOObservationAttributesKey NS_STRING_ENUM;
static const KVOObservationAttributesKey kKVOObservationAttributeCallbackType = @"type";
static const KVOObservationAttributesKey kKVOObservationAttributeCallbackObject = @"object";

#define KVOObservationAttributes(CallbackType, CallbackObject) @{kKVOObservationAttributeCallbackType:@(CallbackType), kKVOObservationAttributeCallbackObject:(CallbackObject)}
#define KVOSelfContext (__bridge void*)self

@interface KVOObservationDelegate ()

@property NSMapTable<NSObject*,KVOKeyPathsDict> *observations;

@end

@implementation KVOObservationDelegate

+ (instancetype)delegateWithOwner:(id)owner {
    return [[self alloc] initWithOwner:owner];
}

- (instancetype)initWithOwner:(id)owner {
    self = [self init];
    
    _owner = owner;
    
    return self;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _observations = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableStrongMemory];
    
    return self;
}

- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(KVONoParamsBlock)block {
    [self startObservingKeyPath:keyPath on:object usingBlock:block type:eKVOCallbackTypeBlockNoParams options:0];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingWeakSelfBlock:(KVOWeakSelfBlock)block {
    [self startObservingKeyPath:keyPath on:object usingBlock:block type:eKVOCallbackTypeBlockWeakSelf options:0];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(KVONoParamsBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block type:eKVOCallbackTypeBlockNoParams options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingWeakSelfBlock:(KVOWeakSelfBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block type:eKVOCallbackTypeBlockWeakSelf options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathBlock:(KVOKeyPathBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block type:eKVOCallbackTypeBlockKeyPath options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingNewOldBlock:(KVONewOldBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block type:eKVOCallbackTypeBlockNewOld options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingNewOldPriorBlock:(KVONewOldPriorBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block type:eKVOCallbackTypeBlockNewOldPrior options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingWeakSelfKeyPathBlock:(KVOWeakSelfKeyPathBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block type:eKVOCallbackTypeBlockWeakSelfKeyPath options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingWeakSelfNewOldBlock:(KVOWeakSelfNewOldBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block type:eKVOCallbackTypeBlockWeakSelfNewOld options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingWeakSelfNewOldPriorBlock:(KVOWeakSelfNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block type:eKVOCallbackTypeBlockWeakSelfNewOldPrior options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathNewOldBlock:(KVOKeyPathNewOldBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block type:eKVOCallbackTypeBlockKeyPathNewOld options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathNewOldPriorBlock:(KVOKeyPathNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block type:eKVOCallbackTypeBlockKeyPathNewOldPrior options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingWeakSelfKeyPathNewOldBlock:(KVOWeakSelfKeyPathNewOldBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block type:eKVOCallbackTypeBlockWeakSelfKeyPathNewOld options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingWeakSelfKeyPathNewOldPriorBlock:(KVOWeakSelfKeyPathNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block type:eKVOCallbackTypeBlockWeakSelfKeyPathNewOldPrior options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingChangeDictionaryBlock:(KVOChangeDictionaryBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block type:eKVOCallbackTypeBlockChangeDictionary options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingWeakSelfChangeDictionaryBlock:(KVOWeakSelfChangeDictionaryBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block type:eKVOCallbackTypeBlockWeakSelfChangeDictionary options:options];
}

- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(KVONoParamsBlock)block {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block type:eKVOCallbackTypeBlockNoParams options:0];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingWeakSelfBlock:(KVOWeakSelfBlock)block {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block type:eKVOCallbackTypeBlockWeakSelf options:0];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(KVONoParamsBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block type:eKVOCallbackTypeBlockNoParams options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingWeakSelfBlock:(KVOWeakSelfBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block type:eKVOCallbackTypeBlockWeakSelf options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathBlock:(KVOKeyPathBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block type:eKVOCallbackTypeBlockKeyPath options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingNewOldBlock:(KVONewOldBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block type:eKVOCallbackTypeBlockNewOld options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingNewOldPriorBlock:(KVONewOldPriorBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block type:eKVOCallbackTypeBlockNewOldPrior options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingWeakSelfKeyPathBlock:(KVOWeakSelfKeyPathBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block type:eKVOCallbackTypeBlockWeakSelfKeyPath options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingWeakSelfNewOldBlock:(KVOWeakSelfNewOldBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block type:eKVOCallbackTypeBlockWeakSelfNewOld options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingWeakSelfNewOldPriorBlock:(KVOWeakSelfNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block type:eKVOCallbackTypeBlockWeakSelfNewOldPrior options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathNewOldBlock:(KVOKeyPathNewOldBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block type:eKVOCallbackTypeBlockKeyPathNewOld options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathNewOldPriorBlock:(KVOKeyPathNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block type:eKVOCallbackTypeBlockKeyPathNewOldPrior options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingWeakSelfKeyPathNewOldBlock:(KVOWeakSelfKeyPathNewOldBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block type:eKVOCallbackTypeBlockWeakSelfKeyPathNewOld options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingWeakSelfKeyPathNewOldPriorBlock:(KVOWeakSelfKeyPathNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block type:eKVOCallbackTypeBlockWeakSelfKeyPathNewOldPrior options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingChangeDictionaryBlock:(KVOChangeDictionaryBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block type:eKVOCallbackTypeBlockChangeDictionary options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingWeakSelfChangeDictionaryBlock:(KVOWeakSelfChangeDictionaryBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block type:eKVOCallbackTypeBlockWeakSelfChangeDictionary options:options];
}

- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object callingSelector:(SEL)selector {
    [self startObservingKeyPath:keyPath on:object callingSelector:selector type:eKVOCallbackTypeSelectorNoParams options:0];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object callingSelector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object callingSelector:selector type:eKVOCallbackTypeSelectorNoParams options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object callingKeyPathSelector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object callingSelector:selector type:eKVOCallbackTypeSelectorKeyPath options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object callingNewOldSelector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object callingSelector:selector type:eKVOCallbackTypeSelectorNewOld options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object callingNewOldPriorSelector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object callingSelector:selector type:eKVOCallbackTypeSelectorNewOldPrior options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object callingKeyPathNewOldSelector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object callingSelector:selector type:eKVOCallbackTypeSelectorKeyPathNewOld options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object callingKeyPathNewOldPriorSelector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object callingSelector:selector type:eKVOCallbackTypeSelectorKeyPathNewOldPrior options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object callingChangeDictionarySelector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object callingSelector:selector type:eKVOCallbackTypeSelectorChangeDictionary options:options];
}

- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object callingSelector:(SEL)selector {
    [self startObservingKeyPaths:keyPaths on:object callingSelector:selector type:eKVOCallbackTypeSelectorNoParams options:0];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object callingSelector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object callingSelector:selector type:eKVOCallbackTypeSelectorNoParams options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object callingKeyPathSelector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object callingSelector:selector type:eKVOCallbackTypeSelectorKeyPath options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object callingNewOldSelector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object callingSelector:selector type:eKVOCallbackTypeSelectorNewOld options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object callingNewOldPriorSelector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object callingSelector:selector type:eKVOCallbackTypeSelectorNewOldPrior options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object callingKeyPathNewOldSelector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object callingSelector:selector type:eKVOCallbackTypeSelectorKeyPathNewOld options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object callingKeyPathNewOldPriorSelector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object callingSelector:selector type:eKVOCallbackTypeSelectorKeyPathNewOldPrior options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object callingChangeDictionarySelector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object callingSelector:selector type:eKVOCallbackTypeSelectorChangeDictionary options:options];
}

// PRIVATE
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(id)block type:(KVOCallbackType)type options:(NSKeyValueObservingOptions)options {
    KVOKeyPathsDict objectObservations = [self observedKeyPathsForObjectCreatingIfAbsent:object];
    
    objectObservations[keyPath] = KVOObservationAttributes(type, block);
    [object addObserver:self forKeyPath:keyPath options:options context:KVOSelfContext];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(id)block type:(KVOCallbackType)type options:(NSKeyValueObservingOptions)options {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object usingBlock:block type:type options:options];
    }
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object callingSelector:(SEL)selector type:(KVOCallbackType)type options:(NSKeyValueObservingOptions)options {
    KVOKeyPathsDict objectObservations = [self observedKeyPathsForObjectCreatingIfAbsent:object];
    
    objectObservations[keyPath] = KVOObservationAttributes(type, [NSValue valueWithPointer:selector]);
    [(NSObject *)object addObserver:self forKeyPath:keyPath options:options context:KVOSelfContext];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object callingSelector:(SEL)selector type:(KVOCallbackType)type options:(NSKeyValueObservingOptions)options {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object callingSelector:selector type:type options:options];
    }
}

- (void)stopObservingKeyPath:(NSString *)keyPath on:(NSObject *)object {
    KVOKeyPathsDict keyPaths = [self observedKeyPathsForObjectLoggingIfAbsent:object];
    if (!keyPaths) return;
    
    KVOObservationAttributesDict attributes = [self observationAttributesForKeyPathLoggingIfAbsent:keyPath inKeyPathsDict:keyPaths onObject:object];
    if (!attributes) return;
    
    [self stopObservingKeyPath:keyPath on:object keyPathsDict:keyPaths];
}
- (void)stopObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object {
    for (NSString *keyPath in keyPaths) {
        [self stopObservingKeyPath:keyPath on:object];
    }
}
- (void)stopObservingAllKeyPathsOn:(NSObject *)object {
    KVOKeyPathsDict keyPaths = [self observedKeyPathsForObjectLoggingIfAbsent:object];
    if (!keyPaths) return;
    
    [self stopObservingKeyPaths:keyPaths.allKeys on:object];
}
- (void)stopObservingAllKeyPaths {
    for (NSObject *object in self.observations) {
        [self stopObservingAllKeyPathsOn:object];
    }
}

static BOOL requiresOwner(KVOCallbackType type) {
    switch (type) {
        case eKVOCallbackTypeBlockWeakSelf:
        case eKVOCallbackTypeBlockWeakSelfKeyPath:
        case eKVOCallbackTypeBlockWeakSelfNewOld:
        case eKVOCallbackTypeBlockWeakSelfNewOldPrior:
        case eKVOCallbackTypeBlockWeakSelfKeyPathNewOld:
        case eKVOCallbackTypeBlockWeakSelfKeyPathNewOldPrior:
        case eKVOCallbackTypeBlockWeakSelfChangeDictionary:
        case eKVOCallbackTypeSelectorNoParams:
        case eKVOCallbackTypeSelectorKeyPath:
        case eKVOCallbackTypeSelectorNewOld:
        case eKVOCallbackTypeSelectorNewOldPrior:
        case eKVOCallbackTypeSelectorKeyPathNewOld:
        case eKVOCallbackTypeSelectorKeyPathNewOldPrior:
        case eKVOCallbackTypeSelectorChangeDictionary:
            return YES;
        case eKVOCallbackTypeBlockNoParams:
        case eKVOCallbackTypeBlockKeyPath:
        case eKVOCallbackTypeBlockNewOld:
        case eKVOCallbackTypeBlockNewOldPrior:
        case eKVOCallbackTypeBlockKeyPathNewOld:
        case eKVOCallbackTypeBlockKeyPathNewOldPrior:
        case eKVOCallbackTypeBlockChangeDictionary:
            return NO;
    }
}

// PRIVATE
- (void)stopObservingKeyPathsRequiringOwner {
    for (NSObject *object in self.observations) {
        KVOKeyPathsDict keyPaths = [self observedKeyPathsForObjectCreatingIfAbsent:object];
        for (NSString *keyPath in keyPaths) {
            KVOObservationAttributesDict observationAttributes = [self observationAttributesForKeyPathCreatingIfAbsent:keyPath inKeyPathsDict:keyPaths];
            
            if (requiresOwner((KVOCallbackType)[observationAttributes[kKVOObservationAttributeCallbackType] integerValue])) {
                [self stopObservingKeyPath:keyPath on:object keyPathsDict:keyPaths];
            }
        }
    }
}

// PRIVATE
- (void)stopObservingKeyPath:(NSString *)keyPath on:(NSObject *)object keyPathsDict:(KVOKeyPathsDict)keyPaths {
    [object removeObserver:self forKeyPath:keyPath context:KVOSelfContext];
    [keyPaths removeObjectForKey:keyPath];
}

// PRIVATE
- (KVOKeyPathsDict)observedKeyPathsForObjectCreatingIfAbsent:(NSObject *)object {
    KVOKeyPathsDict keyPaths = [self.observations objectForKey:object];
    if (keyPaths) return keyPaths;
    
    keyPaths = [NSMutableDictionary new];
    [self.observations setObject:keyPaths forKey:object];
    
    return keyPaths;
}
- (_Nullable KVOKeyPathsDict)observedKeyPathsForObjectLoggingIfAbsent:(NSObject *)object {
    KVOKeyPathsDict keyPaths = [self.observations objectForKey:object];
    if (keyPaths) return keyPaths;
    
    if (!self.silentlyStopsObservingUnobservedObject) {
        NSLog(@"Warning: Attempted to stop observing object %@ when it was never being observed in the first place", object);
    }
    return nil;
}
- (_Nullable KVOObservationAttributesDict)observationAttributesForKeyPathCreatingIfAbsent:(NSString *)keyPath inKeyPathsDict:(KVOKeyPathsDict)keyPaths {
    KVOObservationAttributesDict observationAttributes = keyPaths[keyPath];
    if (observationAttributes) return observationAttributes;
    
    observationAttributes = [NSMutableDictionary new];
    keyPaths[keyPath] = observationAttributes;
    
    return observationAttributes;
}
- (_Nullable KVOObservationAttributesDict)observationAttributesForKeyPathLoggingIfAbsent:(NSString *)keyPath inKeyPathsDict:(KVOKeyPathsDict)keyPaths onObject:(NSObject *)object {
    KVOObservationAttributesDict observationAttributes = keyPaths[keyPath];
    if (observationAttributes) return observationAttributes;
    
    if (!self.silentlyStopsObservingUnobservedKeyPath) {
        NSLog(@"Warning: Attempted to stop observing key path %@ on object %@ when it wasn't being observed", keyPath, object);
    }
    return nil;
}
- (_Nullable KVOObservationAttributesDict)observationAttributesForKeyPathCreatingIfAbsent:(NSString *)keyPath onObject:(NSObject *)object {
    KVOKeyPathsDict keyPaths = [self observedKeyPathsForObjectCreatingIfAbsent:object];
    return [self observationAttributesForKeyPathCreatingIfAbsent:keyPath inKeyPathsDict:keyPaths];
}
- (_Nullable KVOObservationAttributesDict)observationAttributesForKeyPathLoggingIfAbsent:(NSString *)keyPath onObject:(NSObject *)object {
    KVOKeyPathsDict keyPaths = [self observedKeyPathsForObjectLoggingIfAbsent:object];
    if (!keyPaths) return nil;
    
    return [self observationAttributesForKeyPathLoggingIfAbsent:keyPath inKeyPathsDict:keyPaths onObject:object];
}

static id nsNullToNil(id value) {
    return (value == [NSNull null]) ? nil : value;
}
static id newVal(NSDictionary<NSKeyValueChangeKey,id> *change) {
    return nsNullToNil(change[NSKeyValueChangeNewKey]);
}
static id oldVal(NSDictionary<NSKeyValueChangeKey,id> *change) {
    return nsNullToNil(change[NSKeyValueChangeOldKey]);
}
static BOOL isPrior(NSDictionary<NSKeyValueChangeKey,id> *change) {
    return [change[NSKeyValueChangeNotificationIsPriorKey] boolValue];
}
- (NSDictionary<NSKeyValueChangeKey,id> *)amendedChangeDictionaryFromChangeDictionary:(NSDictionary<NSKeyValueChangeKey,id> *)change keyPath:(NSString *)keyPath object:(id)object {
    if (self.vendsUnmodifiedChangeDictionaries) return change;
    
    NSMutableDictionary<NSKeyValueChangeKey,id> *mutableChange = [change mutableCopy];
    mutableChange[kKVOKeyValueChangeKeyKeyPath] = keyPath;
    mutableChange[kKVOKeyValueChangeKeyObject] = object;
    
    return mutableChange;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void*)context {
    if (context != KVOSelfContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    KVOKeyPathsDict keyPaths = [self.observations objectForKey:object];
    if (!keyPaths) return;
    
    KVOObservationAttributesDict attributes = keyPaths[keyPath];
    if (!attributes) return;
    
    KVOCallbackType type = [attributes[kKVOObservationAttributeCallbackType] integerValue];
    
    if (requiresOwner(type) && !_owner) {
        if (self.automaticallyStopsObservingIfOwnerIsNil) {
            [self stopObservingKeyPathsRequiringOwner];
        }
        return;
    }
    
    switch ((KVOCallbackType)[attributes[kKVOObservationAttributeCallbackType] integerValue]) {
        case eKVOCallbackTypeBlockNoParams: {
            KVONoParamsBlock block = attributes[kKVOObservationAttributeCallbackObject];
            block();
        } break;
        case eKVOCallbackTypeBlockWeakSelf: {
            KVOWeakSelfBlock block = attributes[kKVOObservationAttributeCallbackObject];
            block(_owner);
        } break;
        case eKVOCallbackTypeBlockKeyPath: {
            KVOKeyPathBlock block = attributes[kKVOObservationAttributeCallbackObject];
            block(keyPath);
        } break;
        case eKVOCallbackTypeBlockNewOld: {
            KVONewOldBlock block = attributes[kKVOObservationAttributeCallbackObject];
            block(newVal(change), oldVal(change));
        } break;
        case eKVOCallbackTypeBlockNewOldPrior: {
            KVONewOldPriorBlock block = attributes[kKVOObservationAttributeCallbackObject];
            block(newVal(change), oldVal(change), isPrior(change));
        } break;
        case eKVOCallbackTypeBlockWeakSelfKeyPath: {
            KVOWeakSelfKeyPathBlock block = attributes[kKVOObservationAttributeCallbackObject];
            block(_owner, keyPath);
        } break;
        case eKVOCallbackTypeBlockWeakSelfNewOld: {
            KVOWeakSelfNewOldBlock block = attributes[kKVOObservationAttributeCallbackObject];
            block(_owner, newVal(change), oldVal(change));
        } break;
        case eKVOCallbackTypeBlockWeakSelfNewOldPrior: {
            KVOWeakSelfNewOldPriorBlock block = attributes[kKVOObservationAttributeCallbackObject];
            block(_owner, newVal(change), oldVal(change), isPrior(change));
        } break;
        case eKVOCallbackTypeBlockKeyPathNewOld: {
            KVOKeyPathNewOldBlock block = attributes[kKVOObservationAttributeCallbackObject];
            block(keyPath, newVal(change), oldVal(change));
        } break;
        case eKVOCallbackTypeBlockKeyPathNewOldPrior: {
            KVOKeyPathNewOldPriorBlock block = attributes[kKVOObservationAttributeCallbackObject];
            block(keyPath, newVal(change), oldVal(change), isPrior(change));
        } break;
        case eKVOCallbackTypeBlockWeakSelfKeyPathNewOld: {
            KVOWeakSelfKeyPathNewOldBlock block = attributes[kKVOObservationAttributeCallbackObject];
            block(_owner, keyPath, newVal(change), oldVal(change));
        } break;
        case eKVOCallbackTypeBlockWeakSelfKeyPathNewOldPrior: {
            KVOWeakSelfKeyPathNewOldPriorBlock block = attributes[kKVOObservationAttributeCallbackObject];
            block(_owner, keyPath, newVal(change), oldVal(change), isPrior(change));
        } break;
        case eKVOCallbackTypeBlockChangeDictionary: {
            KVOChangeDictionaryBlock block = attributes[kKVOObservationAttributeCallbackObject];
            block([self amendedChangeDictionaryFromChangeDictionary:change keyPath:keyPath object:object]);
        } break;
        case eKVOCallbackTypeBlockWeakSelfChangeDictionary: {
            KVOWeakSelfChangeDictionaryBlock block = attributes[kKVOObservationAttributeCallbackObject];
            block(_owner, [self amendedChangeDictionaryFromChangeDictionary:change keyPath:keyPath object:object]);
        } break;
        
        case eKVOCallbackTypeSelectorNoParams: {
            SEL selector = [attributes[kKVOObservationAttributeCallbackObject] pointerValue];
            ((void(*)(id self, SEL _cmd))objc_msgSend)(
                _owner, selector);
        } break;
        case eKVOCallbackTypeSelectorKeyPath: {
            SEL selector = [attributes[kKVOObservationAttributeCallbackObject] pointerValue];
            ((void(*)(id self, SEL _cmd, NSString *keyPath))objc_msgSend)(
                _owner, selector, keyPath);
        } break;
        case eKVOCallbackTypeSelectorNewOld: {
            SEL selector = [attributes[kKVOObservationAttributeCallbackObject] pointerValue];
            ((void(*)(id self, SEL _cmd, _Nullable id newValue, _Nullable id oldValue))objc_msgSend)(
                _owner, selector, newVal(change), oldVal(change));
        } break;
        case eKVOCallbackTypeSelectorNewOldPrior: {
            SEL selector = [attributes[kKVOObservationAttributeCallbackObject] pointerValue];
            ((void(*)(id self, SEL _cmd, _Nullable id newValue, _Nullable id oldValue, BOOL prior))objc_msgSend)(
                _owner, selector, newVal(change), oldVal(change), isPrior(change));
        } break;
        case eKVOCallbackTypeSelectorKeyPathNewOld: {
            SEL selector = [attributes[kKVOObservationAttributeCallbackObject] pointerValue];
            ((void(*)(id self, SEL _cmd, NSString *keyPath, _Nullable id newValue, _Nullable id oldValue))objc_msgSend)(
                _owner, selector, keyPath, newVal(change), oldVal(change));
        } break;
        case eKVOCallbackTypeSelectorKeyPathNewOldPrior: {
            SEL selector = [attributes[kKVOObservationAttributeCallbackObject] pointerValue];
            ((void(*)(id self, SEL _cmd, NSString *keyPath, _Nullable id newValue, _Nullable id oldValue, BOOL prior))objc_msgSend)(
                _owner, selector, keyPath, newVal(change), oldVal(change), isPrior(change));
        } break;
        case eKVOCallbackTypeSelectorChangeDictionary: {
            SEL selector = [attributes[kKVOObservationAttributeCallbackObject] pointerValue];
            ((void(*)(id self, SEL _cmd, NSDictionary<NSKeyValueChangeKey,id> *change))objc_msgSend)(
                _owner, selector, [self amendedChangeDictionaryFromChangeDictionary:change keyPath:keyPath object:object]);
        }
    }
}

- (void)dealloc {
    [self stopObservingAllKeyPaths];
}

@end
