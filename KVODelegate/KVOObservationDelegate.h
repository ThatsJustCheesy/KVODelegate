//
//  KVOObservationDelegate.h
//  KVODelegate
//
//  Created by Ian Gregory on 11-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVOObservationDelegate : NSObject

typedef void(^KVONoParamsBlock)();
typedef void(^KVOKeyPathBlock)(NSString *keyPath);
typedef void(^KVONewOldBlock)(_Nullable id newValue, _Nullable id oldValue);
typedef void(^KVOKeyPathNewOldBlock)(NSString *keyPath, _Nullable id newValue, _Nullable id oldValue);
typedef void(^KVONewOldPriorBlock)(_Nullable id newValue, _Nullable id oldValue, BOOL prior);
typedef void(^KVOKeyPathNewOldPriorBlock)(NSString *keyPath, _Nullable id newValue, _Nullable id oldValue, BOOL prior);
typedef void(^KVOChangeDictionaryBlock)(NSDictionary<NSKeyValueChangeKey,id> *change);

- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(KVONoParamsBlock)block NS_SWIFT_NAME(startObserving(keyPath:on:using:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(KVONoParamsBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:using:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathBlock:(KVOKeyPathBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:using:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingNewOldBlock:(KVONewOldBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:using:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathNewOldBlock:(KVOKeyPathNewOldBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:using:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingNewOldPriorBlock:(KVONewOldPriorBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:using:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathNewOldPriorBlock:(KVOKeyPathNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:using:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingChangeDictionaryBlock:(KVOChangeDictionaryBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:using:options:));

- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(KVONoParamsBlock)block NS_SWIFT_NAME(startObserving(keyPaths:on:using:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(KVONoParamsBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:using:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathBlock:(KVOKeyPathBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:using:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingNewOldBlock:(KVONewOldBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:using:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathNewOldBlock:(KVOKeyPathNewOldBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:using:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingNewOldPriorBlock:(KVONewOldPriorBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:using:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathNewOldPriorBlock:(KVOKeyPathNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:using:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingChangeDictionaryBlock:(KVOChangeDictionaryBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:using:options:));

- (void)stopObservingKeyPath:(NSString *)keyPath on:(NSObject *)object NS_SWIFT_NAME(stopObserving(keyPath:on:));
- (void)stopObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object NS_SWIFT_NAME(stopObserving(keyPaths:on:));
- (void)stopObservingAllKeyPathsOn:(NSObject *)object NS_SWIFT_NAME(stopObserving(allKeyPathsOn:));
- (void)stopObservingAllKeyPaths NS_SWIFT_NAME(stopObservingAllKeyPaths());

@end

NS_ASSUME_NONNULL_END
