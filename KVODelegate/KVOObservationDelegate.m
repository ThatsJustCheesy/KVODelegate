//
//  KeyValueObservancesDelegate.m
//  AutoScript
//
//  Created by Ian Gregory on 11-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

#import "KVOObservationDelegate.h"

@interface KVOObservationDelegate ()

//                   object    keyPaths dict       keyPath   attributes dict
@property NSMapTable<NSObject*,NSMutableDictionary<NSString*,NSDictionary<NSString*,id>*>*> *observations;

@end

@implementation KVOObservationDelegate

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.observations = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableStrongMemory];
    
    return self;
}

- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(void (^)())block {
    [self startObservingKeyPath:keyPath on:object usingBlock:block options:0];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(void (^)())block options:(NSKeyValueObservingOptions)options {
    NSMutableDictionary<NSString*,NSDictionary<NSString*,id>*> *objectObservations = [self.observations objectForKey:object];
    if (!objectObservations) {
        objectObservations = [NSMutableDictionary dictionary];
        [self.observations setObject:objectObservations forKey:object];
    }
    objectObservations[keyPath] = @{@"keyPath":keyPath, @"block":block};
    
    [object addObserver:self forKeyPath:keyPath options:options context:(__bridge void*)self];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathBlock:(void (^)(NSString *))block options:(NSKeyValueObservingOptions)options {
    NSMutableDictionary<NSString*,NSDictionary<NSString*,id>*> *objectObservations = [self.observations objectForKey:object];
    if (!objectObservations) {
        objectObservations = [NSMutableDictionary dictionary];
        [self.observations setObject:objectObservations forKey:object];
    }
    objectObservations[keyPath] = @{@"keyPath":keyPath, @"keyPathBlock":block};
    
    [object addObserver:self forKeyPath:keyPath options:options context:(__bridge void*)self];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingNewOldBlock:(void (^)(id, id))block options:(NSKeyValueObservingOptions)options {
    NSMutableDictionary<NSString*,NSDictionary<NSString*,id>*> *objectObservations = [self.observations objectForKey:object];
    if (!objectObservations) {
        objectObservations = [NSMutableDictionary dictionary];
        [self.observations setObject:objectObservations forKey:object];
    }
    objectObservations[keyPath] = @{@"keyPath":keyPath, @"newOldBlock":block};
    
    [object addObserver:self forKeyPath:keyPath options:options context:(__bridge void*)self];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathNewOldBlock:(void (^)(NSString *, id, id))block options:(NSKeyValueObservingOptions)options {
    NSMutableDictionary<NSString*,NSDictionary<NSString*,id>*> *objectObservations = [self.observations objectForKey:object];
    if (!objectObservations) {
        objectObservations = [NSMutableDictionary dictionary];
        [self.observations setObject:objectObservations forKey:object];
    }
    objectObservations[keyPath] = @{@"keyPath":keyPath, @"keyPathNewOldBlock":block};
    
    [object addObserver:self forKeyPath:keyPath options:options context:(__bridge void*)self];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingNewOldPriorBlock:(void (^)(id, id, BOOL))block options:(NSKeyValueObservingOptions)options {
    NSMutableDictionary<NSString*,NSDictionary<NSString*,id>*> *objectObservations = [self.observations objectForKey:object];
    if (!objectObservations) {
        objectObservations = [NSMutableDictionary dictionary];
        [self.observations setObject:objectObservations forKey:object];
    }
    objectObservations[keyPath] = @{@"keyPath":keyPath, @"newOldPriorBlock":block};
    
    [object addObserver:self forKeyPath:keyPath options:options context:(__bridge void*)self];
}
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathNewOldPriorBlock:(void (^)(NSString *, id, id, BOOL))block options:(NSKeyValueObservingOptions)options {
    NSMutableDictionary<NSString*,NSDictionary<NSString*,id>*> *objectObservations = [self.observations objectForKey:object];
    if (!objectObservations) {
        objectObservations = [NSMutableDictionary dictionary];
        [self.observations setObject:objectObservations forKey:object];
    }
    objectObservations[keyPath] = @{@"keyPath":keyPath, @"keyPathNewOldPriorBlock":block};
    
    [object addObserver:self forKeyPath:keyPath options:options context:(__bridge void*)self];
}

- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(void (^)())block {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object usingBlock:block options:0];
    }
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(void (^)())block options:(NSKeyValueObservingOptions)options {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object usingBlock:block options:options];
    }
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathBlock:(void (^)(NSString *))block options:(NSKeyValueObservingOptions)options {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object usingKeyPathBlock:block options:options];
    }
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingNewOldBlock:(void (^)(id, id))block options:(NSKeyValueObservingOptions)options {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object usingNewOldBlock:block options:options];
    }
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathNewOldBlock:(void (^)(NSString *, id, id))block options:(NSKeyValueObservingOptions)options {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object usingKeyPathNewOldBlock:block options:options];
    }
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingNewOldPriorBlock:(void (^)(id, id, BOOL))block options:(NSKeyValueObservingOptions)options {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object usingNewOldPriorBlock:block options:options];
    }
}
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathNewOldPriorBlock:(void (^)(NSString *, id, id, BOOL))block options:(NSKeyValueObservingOptions)options {
    for (NSString *keyPath in keyPaths) {
        [self startObservingKeyPath:keyPath on:object usingKeyPathNewOldPriorBlock:block options:options];
    }
}

- (void)stopObservingKeyPath:(NSString *)keyPath on:(NSObject *)object {
    if (![self.observations objectForKey:object]) {
        NSLog(@"Warning: Attempted to stop observing object %p of class '%@' when it was never observed in the first place", object, [object class]);
    } else if (![[self.observations objectForKey:object] objectForKey:keyPath]) {
        NSLog(@"Warning: Attempted to stop observing key path %@ on object %p of class '%@' when it wasn't being observed", keyPath, object, [object class]);
    } else {
        [object removeObserver:self forKeyPath:keyPath context:(__bridge void*)self];
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
        NSLog(@"Warning: Attempted to stop observing object %p of class '%@' when it was never observed in the first place", object, [object class]);
    } else {
        for (NSString *keyPath in [self.observations objectForKey:object].allKeys) {
            [object removeObserver:self forKeyPath:keyPath context:(__bridge void*)self];
        }
        [[self.observations objectForKey:object] removeAllObjects];
    }
}
- (void)stopObservingAllKeyPaths {
    for (NSObject *object in self.observations) {
        [self stopObservingAllKeyPathsOn:object];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void*)context {
    if ((__bridge id)context != self) { [super observeValueForKeyPath:keyPath ofObject:object change:change context:context]; return; }
    
    NSMutableDictionary<NSString*,NSDictionary<NSString*,id>*> *keyPaths = [self.observations objectForKey:object];
    if (!keyPaths) return;
    
    NSDictionary<NSString*,id> *attributes = keyPaths[keyPath];
    if (!attributes) return;
    
    if (attributes[@"block"]) {
        void (^block)() = attributes[@"block"];
        block();
    } else if(attributes[@"keyPathBlock"]) {
        void (^block)(NSString *) = attributes[@"keyPathBlock"];
        block(keyPath);
    } else if (attributes[@"newOldBlock"]) {
        void (^block)(id, id) = attributes[@"newOldBlock"];
        id new = change[NSKeyValueChangeNewKey], old = change[NSKeyValueChangeOldKey];
        if (new == [NSNull null]) new = nil;
        if (old == [NSNull null]) old = nil;
        block(new, old);
    } else if (attributes[@"keyPathNewOldBlock"]) {
        void (^block)(NSString *, id, id) = attributes[@"keyPathNewOldBlock"];
        id new = change[NSKeyValueChangeNewKey], old = change[NSKeyValueChangeOldKey];
        if (new == [NSNull null]) new = nil;
        if (old == [NSNull null]) old = nil;
        block(keyPath, new, old);
    } else if (attributes[@"newOldPriorBlock"]) {
        void (^block)(id, id, BOOL) = attributes[@"newOldPriorBlock"];
        id new = change[NSKeyValueChangeNewKey], old = change[NSKeyValueChangeOldKey];
        if (new == [NSNull null]) new = nil;
        if (old == [NSNull null]) old = nil;
        block(new, old, [change[NSKeyValueChangeNotificationIsPriorKey] boolValue]);
    } else if (attributes[@"keyPathNewOldPriorBlock"]) {
        void (^block)(NSString *, id, id, BOOL) = attributes[@"keyPathNewOldPriorBlock"];
        id new = change[NSKeyValueChangeNewKey], old = change[NSKeyValueChangeOldKey];
        if (new == [NSNull null]) new = nil;
        if (old == [NSNull null]) old = nil;
        block(keyPath, new, old, [change[NSKeyValueChangeNotificationIsPriorKey] boolValue]);
    } else return;
}

- (void)dealloc {
    [self stopObservingAllKeyPaths];
}

@end
