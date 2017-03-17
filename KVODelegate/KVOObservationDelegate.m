//
//  KeyValueObservancesDelegate.m
//  AutoScript
//
//  Created by Ian Gregory on 11-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

#import "KVOObservationDelegate.h"

typedef NS_ENUM(NSUInteger, eKVOBlockType) {
    eKVOBlockTypeNoParams,
    eKVOBlockTypeKeyPath,
    eKVOBlockTypeNewOld,
    eKVOBlockTypeKeyPathNewOld,
    eKVOBlockTypeNewOldPrior,
    eKVOBlockTypeKeyPathNewOldPrior
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
    
    self.observations = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableStrongMemory];
    
    return self;
}

- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(KVONoParamsBlock)block {
    [self startObservingKeyPath:keyPath on:object usingBlock:block options:0];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(KVONoParamsBlock)block options:(NSKeyValueObservingOptions)options {
    KVOKeyPathsDict *objectObservations = [self observationsForObject:object];
    
    objectObservations[keyPath] = KVOObservationAttributes(eKVOBlockTypeNoParams, block);
    [object addObserver:self forKeyPath:keyPath options:options context:KVOSelfContext];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathBlock:(KVOKeyPathBlock)block options:(NSKeyValueObservingOptions)options {
    KVOKeyPathsDict *objectObservations = [self observationsForObject:object];
    
    objectObservations[keyPath] = KVOObservationAttributes(eKVOBlockTypeKeyPath, block);
    [object addObserver:self forKeyPath:keyPath options:options context:KVOSelfContext];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingNewOldBlock:(KVONewOldBlock)block options:(NSKeyValueObservingOptions)options {
    KVOKeyPathsDict *objectObservations = [self observationsForObject:object];
    
    objectObservations[keyPath] = KVOObservationAttributes(eKVOBlockTypeNewOld, block);
    [object addObserver:self forKeyPath:keyPath options:options context:KVOSelfContext];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathNewOldBlock:(KVOKeyPathNewOldBlock)block options:(NSKeyValueObservingOptions)options {
    KVOKeyPathsDict *objectObservations = [self observationsForObject:object];
    
    objectObservations[keyPath] = KVOObservationAttributes(eKVOBlockTypeKeyPathNewOld, block);
    [object addObserver:self forKeyPath:keyPath options:options context:KVOSelfContext];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingNewOldPriorBlock:(KVONewOldPriorBlock)block options:(NSKeyValueObservingOptions)options {
    KVOKeyPathsDict *objectObservations = [self observationsForObject:object];
    
    objectObservations[keyPath] = KVOObservationAttributes(eKVOBlockTypeNewOldPrior, block);
    [object addObserver:self forKeyPath:keyPath options:options context:KVOSelfContext];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathNewOldPriorBlock:(KVOKeyPathNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options {
    KVOKeyPathsDict *objectObservations = [self observationsForObject:object];
    
    objectObservations[keyPath] = KVOObservationAttributes(eKVOBlockTypeKeyPathNewOldPrior, block);
    [object addObserver:self forKeyPath:keyPath options:options context:KVOSelfContext];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingChangeDictionaryBlock:(KVOChangeDictionaryBlock)block options:(NSKeyValueObservingOptions)options {
    KVOKeyPathsDict *objectObservations = [self observationsForObject:object];
    
    objectObservations[keyPath] = KVOObservationAttributes(eKVOBlockTypeKeyPathNewOldPrior, block);
    [object addObserver:self forKeyPath:keyPath options:options context:KVOSelfContext];
}

- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(KVONoParamsBlock)block {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object usingBlock:block options:0];
    }
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(KVONoParamsBlock)block options:(NSKeyValueObservingOptions)options {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object usingBlock:block options:options];
    }
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathBlock:(KVOKeyPathBlock)block options:(NSKeyValueObservingOptions)options {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object usingKeyPathBlock:block options:options];
    }
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingNewOldBlock:(KVONewOldBlock)block options:(NSKeyValueObservingOptions)options {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object usingNewOldBlock:block options:options];
    }
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathNewOldBlock:(KVOKeyPathNewOldBlock)block options:(NSKeyValueObservingOptions)options {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object usingKeyPathNewOldBlock:block options:options];
    }
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingNewOldPriorBlock:(KVONewOldPriorBlock)block options:(NSKeyValueObservingOptions)options {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object usingNewOldPriorBlock:block options:options];
    }
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathNewOldPriorBlock:(KVOKeyPathNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object usingKeyPathNewOldPriorBlock:block options:options];
    }
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingChangeDictionaryBlock:(KVOChangeDictionaryBlock)block options:(NSKeyValueObservingOptions)options {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object usingChangeDictionaryBlock:block options:options];
    }
}

- (void)stopObservingKeyPath:(NSString *)keyPath on:(NSObject *)object {
    if (![self.observations objectForKey:object]) {
        NSLog(@"Warning: Attempted to stop observing object %p of class '%@' when it was never being observed in the first place", object, [object class]);
    } else if (![self.observations objectForKey:object][keyPath]) {
        NSLog(@"Warning: Attempted to stop observing key path %@ on object %p of class '%@' when it wasn't being observed", keyPath, object, [object class]);
    } else {
        [object removeObserver:self forKeyPath:keyPath context:KVOSelfContext];
        [[self.observations objectForKey:object] removeObjectForKey:keyPath];
    }
}
- (void)stopObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object {
    for (NSString *keyPath in keyPaths) {
        [self stopObservingKeyPath:keyPath on:object];
    }
}
- (void)stopObservingAllKeyPathsOn:(NSObject *)object {
    if (![self.observations objectForKey:object]) {
        NSLog(@"Warning: Attempted to stop observing object %p of class '%@' when it was never being observed in the first place", object, [object class]);
    } else {
        for (NSString *keyPath in [self.observations objectForKey:object]) {
            [object removeObserver:self forKeyPath:keyPath context:KVOSelfContext];
        }
        [[self.observations objectForKey:object] removeAllObjects];
    }
}
- (void)stopObservingAllKeyPaths {
    for (NSObject *object in self.observations) {
        [self stopObservingAllKeyPathsOn:object];
    }
}

- (KVOKeyPathsDict *)observationsForObject:(NSObject *)object {
    NSMutableDictionary<NSString*,NSDictionary<NSString*,id>*> *observations = [self.observations objectForKey:object];
    if (!observations) {
        observations = [NSMutableDictionary dictionary];
        [self.observations setObject:observations forKey:object];
    }
    
    return observations;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void*)context {
    if ((__bridge id)context != self) { [super observeValueForKeyPath:keyPath ofObject:object change:change context:context]; return; }
    
    NSMutableDictionary<NSString*,NSDictionary<NSString*,id>*> *keyPaths = [self.observations objectForKey:object];
    if (!keyPaths) return;
    
    NSDictionary<NSString*,id> *attributes = keyPaths[keyPath];
    if (!attributes) return;
    
    switch ([attributes[kKVOObservationAttributeBlockType] intValue]) {
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
            id new = change[NSKeyValueChangeNewKey], old = change[NSKeyValueChangeOldKey];
            if (new == [NSNull null]) new = nil;
            if (old == [NSNull null]) old = nil;
            block(new, old);
        } break;
        case eKVOBlockTypeKeyPathNewOld: {
            KVOKeyPathNewOldBlock block = attributes[@"keyPathNewOldBlock"];
            id new = change[NSKeyValueChangeNewKey], old = change[NSKeyValueChangeOldKey];
            if (new == [NSNull null]) new = nil;
            if (old == [NSNull null]) old = nil;
            block(keyPath, new, old);
        } break;
        case eKVOBlockTypeNewOldPrior: {
            KVONewOldPriorBlock block = attributes[@"newOldPriorBlock"];
            id new = change[NSKeyValueChangeNewKey], old = change[NSKeyValueChangeOldKey];
            if (new == [NSNull null]) new = nil;
            if (old == [NSNull null]) old = nil;
            block(new, old, [change[NSKeyValueChangeNotificationIsPriorKey] boolValue]);
        } break;
        case eKVOBlockTypeKeyPathNewOldPrior: {
            KVOKeyPathNewOldPriorBlock block = attributes[@"keyPathNewOldPriorBlock"];
            id new = change[NSKeyValueChangeNewKey], old = change[NSKeyValueChangeOldKey];
            if (new == [NSNull null]) new = nil;
            if (old == [NSNull null]) old = nil;
            block(keyPath, new, old, [change[NSKeyValueChangeNotificationIsPriorKey] boolValue]);
        } break;
    }
}

- (void)dealloc {
    [self stopObservingAllKeyPaths];
}

@end
