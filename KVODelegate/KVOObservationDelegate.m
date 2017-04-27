//
//  KVOObservationDelegate.m
//  KVODelegate
//
//  Created by Ian Gregory on 11-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

#import "KVOObservationDelegate.h"

typedef NS_ENUM(NSInteger, eKVOBlockType) {
    eKVOBlockTypeNoParams,
    eKVOBlockTypeKeyPath,
    eKVOBlockTypeNewOld,
    eKVOBlockTypeKeyPathNewOld,
    eKVOBlockTypeNewOldPrior,
    eKVOBlockTypeKeyPathNewOldPrior,
    eKVOBlockTypeChangeDictionary
};
typedef NSDictionary<NSString*,id> KVOObservationAttributesDict;
typedef NSMutableDictionary<NSString*,KVOObservationAttributesDict*> KVOKeyPathsDict;

typedef NSString* KVOObservationAttributesKey NS_STRING_ENUM;
static const KVOObservationAttributesKey kKVOObservationAttributeBlock = @"block";
static const KVOObservationAttributesKey kKVOObservationAttributeBlockType = @"blockType";

#define KVOObservationAttributes(blockType, block) @{kKVOObservationAttributeBlockType:@(blockType), kKVOObservationAttributeBlock:block}
#define KVOSelfContext (__bridge void*)self

@interface KVOObservationDelegate ()

@property NSMapTable<NSObject*,KVOKeyPathsDict*> *observations;

@end

@implementation KVOObservationDelegate

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _observations = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableStrongMemory];
    
    return self;
}

- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(KVONoParamsBlock)block {
    [self startObservingKeyPath:keyPath on:object usingBlock:block blockType:eKVOBlockTypeNoParams options:0];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(KVONoParamsBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block blockType:eKVOBlockTypeNoParams options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathBlock:(KVOKeyPathBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block blockType:eKVOBlockTypeKeyPath options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingNewOldBlock:(KVONewOldBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block blockType:eKVOBlockTypeNewOld options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathNewOldBlock:(KVOKeyPathNewOldBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block blockType:eKVOBlockTypeKeyPathNewOld options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingNewOldPriorBlock:(KVONewOldPriorBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block blockType:eKVOBlockTypeNewOldPrior options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathNewOldPriorBlock:(KVOKeyPathNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block blockType:eKVOBlockTypeKeyPathNewOldPrior options:options];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingChangeDictionaryBlock:(KVOChangeDictionaryBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPath:keyPath on:object usingBlock:block blockType:eKVOBlockTypeChangeDictionary options:options];
}

- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(KVONoParamsBlock)block {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block blockType:eKVOBlockTypeNoParams options:0];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(KVONoParamsBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block blockType:eKVOBlockTypeNoParams options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathBlock:(KVOKeyPathBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block blockType:eKVOBlockTypeKeyPath options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingNewOldBlock:(KVONewOldBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block blockType:eKVOBlockTypeNewOld options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathNewOldBlock:(KVOKeyPathNewOldBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block blockType:eKVOBlockTypeKeyPathNewOld options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingNewOldPriorBlock:(KVONewOldPriorBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block blockType:eKVOBlockTypeNewOldPrior options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathNewOldPriorBlock:(KVOKeyPathNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block blockType:eKVOBlockTypeKeyPathNewOldPrior options:options];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingChangeDictionaryBlock:(KVOChangeDictionaryBlock)block options:(NSKeyValueObservingOptions)options {
    [self startObservingKeyPaths:keyPaths on:object usingBlock:block blockType:eKVOBlockTypeChangeDictionary options:options];
}

// PRIVATE
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(id)block blockType:(eKVOBlockType)blockType options:(NSKeyValueObservingOptions)options {
    KVOKeyPathsDict *objectObservations = [self observationsForObject:object];
    
    objectObservations[keyPath] = KVOObservationAttributes(blockType, block);
    [object addObserver:self forKeyPath:keyPath options:options context:KVOSelfContext];
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(id)block blockType:(eKVOBlockType)blockType options:(NSKeyValueObservingOptions)options {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object usingBlock:block blockType:blockType options:options];
    }
}

- (void)stopObservingKeyPath:(NSString *)keyPath on:(NSObject *)object {
    KVOKeyPathsDict *keyPaths = [self.observations objectForKey:object];
    if (!keyPaths) { // If no map table entry, the object hasn't ever been observed by this delegate
        NSLog(@"Warning: Attempted to stop observing object %p of class '%@' when it was never being observed in the first place", object, [object class]);
        return;
    }
    
    KVOObservationAttributesDict *attributes = keyPaths[keyPath];
    if (!attributes) { // If no attributes dict, the key path wasn't being observed
        NSLog(@"Warning: Attempted to stop observing key path %@ on object %p of class '%@' when it wasn't being observed", keyPath, object, [object class]);
        return;
    }
    
    [object removeObserver:self forKeyPath:keyPath context:KVOSelfContext];
    [keyPaths removeObjectForKey:keyPath];
}
- (void)stopObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object {
    for (NSString *keyPath in keyPaths) {
        [self stopObservingKeyPath:keyPath on:object];
    }
}
- (void)stopObservingAllKeyPathsOn:(NSObject *)object {
    KVOKeyPathsDict *keyPaths = [self.observations objectForKey:object];
    [self stopObservingKeyPaths:keyPaths.allKeys on:object];
}
- (void)stopObservingAllKeyPaths {
    for (NSObject *object in self.observations) {
        [self stopObservingAllKeyPathsOn:object];
    }
}

- (KVOKeyPathsDict *)observationsForObject:(NSObject *)object {
    KVOKeyPathsDict *observations = [self.observations objectForKey:object];
    if (!observations) {
        observations = [NSMutableDictionary dictionary];
        [self.observations setObject:observations forKey:object];
    }
    
    return observations;
}

id nsNullToNil(id value) {
    return (value == [NSNull null]) ? nil : value;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void*)context {
    if (context != KVOSelfContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    KVOKeyPathsDict *keyPaths = [self.observations objectForKey:object];
    if (!keyPaths) return;
    
    NSDictionary<NSString*,id> *attributes = keyPaths[keyPath];
    if (!attributes) return;
    
    switch ((eKVOBlockType)[attributes[kKVOObservationAttributeBlockType] integerValue]) {
        case eKVOBlockTypeNoParams: {
            KVONoParamsBlock block = attributes[kKVOObservationAttributeBlock];
            block();
        } break;
        case eKVOBlockTypeKeyPath: {
            KVOKeyPathBlock block = attributes[kKVOObservationAttributeBlock];
            block(keyPath);
        } break;
        case eKVOBlockTypeNewOld: {
            KVONewOldBlock block = attributes[kKVOObservationAttributeBlock];
            id newVal = nsNullToNil(change[NSKeyValueChangeNewKey]), oldVal = nsNullToNil(change[NSKeyValueChangeOldKey]);
            block(newVal, oldVal);
        } break;
        case eKVOBlockTypeKeyPathNewOld: {
            KVOKeyPathNewOldBlock block = attributes[kKVOObservationAttributeBlock];
            id newVal = nsNullToNil(change[NSKeyValueChangeNewKey]), oldVal = nsNullToNil(change[NSKeyValueChangeOldKey]);
            block(keyPath, newVal, oldVal);
        } break;
        case eKVOBlockTypeNewOldPrior: {
            KVONewOldPriorBlock block = attributes[kKVOObservationAttributeBlock];
            id newVal = nsNullToNil(change[NSKeyValueChangeNewKey]), oldVal = nsNullToNil(change[NSKeyValueChangeOldKey]);
            BOOL isPrior = [change[NSKeyValueChangeNotificationIsPriorKey] boolValue];
            block(newVal, oldVal, isPrior);
        } break;
        case eKVOBlockTypeKeyPathNewOldPrior: {
            KVOKeyPathNewOldPriorBlock block = attributes[kKVOObservationAttributeBlock];
            id newVal = nsNullToNil(change[NSKeyValueChangeNewKey]), oldVal = nsNullToNil(change[NSKeyValueChangeOldKey]);
            BOOL isPrior = [change[NSKeyValueChangeNotificationIsPriorKey] boolValue];
            block(keyPath, newVal, oldVal, isPrior);
        } break;
        case eKVOBlockTypeChangeDictionary: {
            KVOChangeDictionaryBlock block = attributes[kKVOObservationAttributeBlock];
            block(change);
        } break;
    }
}

- (void)dealloc {
    [self stopObservingAllKeyPaths];
}

@end
