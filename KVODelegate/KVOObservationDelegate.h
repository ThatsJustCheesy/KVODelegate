//
//  KVOObservationDelegate.h
//  KVODelegate
//
//  Created by Ian Gregory on 11-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString* KVOKeyValueChangeKey NS_STRING_ENUM;
extern const KVOKeyValueChangeKey kKVOKeyValueChangeKeyObject;
extern const KVOKeyValueChangeKey kKVOKeyValueChangeKeyKeyPath;

#ifndef SWIFT_SDK_OVERLAY_FOUNDATION_EPOCH // UUUUGLY but the only way I know of to detect the fact that we're compiling for Swift importation

@interface KVOObservationDelegate<OwnerType> : NSObject

#else

@interface KVOObservationDelegate : NSObject

typedef id OwnerType;

#endif

typedef void(^KVONoParamsBlock)(void);
typedef void(^KVOWeakSelfBlock)(OwnerType weakSelf) NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
typedef void(^KVOKeyPathBlock)(NSString *keyPath);
typedef void(^KVONewOldBlock)(_Nullable id newValue, _Nullable id oldValue);
typedef void(^KVONewOldPriorBlock)(_Nullable id newValue, _Nullable id oldValue, BOOL prior);
typedef void(^KVOWeakSelfKeyPathBlock)(OwnerType weakSelf, NSString *keyPath) NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
typedef void(^KVOWeakSelfNewOldBlock)(OwnerType weakSelf, _Nullable id newValue, _Nullable id oldValue) NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
typedef void(^KVOWeakSelfNewOldPriorBlock)(OwnerType weakSelf, _Nullable id newValue, _Nullable id oldValue, BOOL prior) NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
typedef void(^KVOKeyPathNewOldBlock)(NSString *keyPath, _Nullable id newValue, _Nullable id oldValue);
typedef void(^KVOKeyPathNewOldPriorBlock)(NSString *keyPath, _Nullable id newValue, _Nullable id oldValue, BOOL prior);
typedef void(^KVOWeakSelfKeyPathNewOldBlock)(OwnerType weakSelf, NSString *keyPath, _Nullable id newValue, _Nullable id oldValue) NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
typedef void(^KVOWeakSelfKeyPathNewOldPriorBlock)(OwnerType weakSelf, NSString *keyPath, _Nullable id newValue, _Nullable id oldValue, BOOL prior) NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
typedef void(^KVOChangeDictionaryBlock)(NSDictionary<NSKeyValueChangeKey,id> *change);
typedef void(^KVOWeakSelfChangeDictionaryBlock)(OwnerType weakSelf, NSDictionary<NSKeyValueChangeKey,id> *change) NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");

@property(weak,nullable) OwnerType owner;

@property BOOL vendsUnmodifiedChangeDictionaries;
@property BOOL automaticallyStopsObservingIfOwnerIsNil;
@property BOOL silentlyStopsObservingUnobservedObject;
@property BOOL silentlyStopsObservingUnobservedKeyPath;

+ (instancetype)delegateWithOwner:(OwnerType)owner;
- (instancetype)initWithOwner:(OwnerType)owner;

// The following invoke `block` when `keyPath` is observed on `object`.
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(KVONoParamsBlock)block NS_SWIFT_NAME(startObserving(keyPath:on:using:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingWeakSelfBlock:(KVOWeakSelfBlock)block NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(KVONoParamsBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:using:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingWeakSelfBlock:(KVOWeakSelfBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathBlock:(KVOKeyPathBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:using:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingNewOldBlock:(KVONewOldBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:using:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingNewOldPriorBlock:(KVONewOldPriorBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:using:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingWeakSelfKeyPathBlock:(KVOWeakSelfKeyPathBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingWeakSelfNewOldBlock:(KVOWeakSelfNewOldBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingWeakSelfNewOldPriorBlock:(KVOWeakSelfNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathNewOldBlock:(KVOKeyPathNewOldBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:using:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathNewOldPriorBlock:(KVOKeyPathNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:using:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingWeakSelfKeyPathNewOldBlock:(KVOWeakSelfKeyPathNewOldBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingWeakSelfKeyPathNewOldPriorBlock:(KVOWeakSelfKeyPathNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingChangeDictionaryBlock:(KVOChangeDictionaryBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:using:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingWeakSelfChangeDictionaryBlock:(KVOWeakSelfChangeDictionaryBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");

// The following invoke `block` when any key path in `keyPaths` is observed on `object`.
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(KVONoParamsBlock)block NS_SWIFT_NAME(startObserving(keyPaths:on:using:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingWeakSelfBlock:(KVOWeakSelfBlock)block NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(KVONoParamsBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:using:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingWeakSelfBlock:(KVOWeakSelfBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathBlock:(KVOKeyPathBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:using:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingNewOldBlock:(KVONewOldBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:using:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingNewOldPriorBlock:(KVONewOldPriorBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:using:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingWeakSelfKeyPathBlock:(KVOWeakSelfKeyPathBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingWeakSelfNewOldBlock:(KVOWeakSelfNewOldBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingWeakSelfNewOldPriorBlock:(KVOWeakSelfNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathNewOldBlock:(KVOKeyPathNewOldBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:using:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathNewOldPriorBlock:(KVOKeyPathNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:using:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingWeakSelfKeyPathNewOldBlock:(KVOWeakSelfKeyPathNewOldBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingWeakSelfKeyPathNewOldPriorBlock:(KVOWeakSelfKeyPathNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingChangeDictionaryBlock:(KVOChangeDictionaryBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:using:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingWeakSelfChangeDictionaryBlock:(KVOWeakSelfChangeDictionaryBlock)block options:(NSKeyValueObservingOptions)options NS_SWIFT_UNAVAILABLE("Use a capture list of [weak self] or [unowned self] instead");

// The following call `selector` on `self.owner` when `keyPath` is observed on `object`.
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object callingSelector:(SEL)selector NS_SWIFT_NAME(startObserving(keyPath:on:selector:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object callingSelector:(SEL)selector options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:selector:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object callingKeyPathSelector:(SEL)selector options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:keyPathSelector:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object callingNewOldSelector:(SEL)selector options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:newOldSelector:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object callingNewOldPriorSelector:(SEL)selector options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:newOldPriorSelector:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object callingKeyPathNewOldSelector:(SEL)selector options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:keyPathNewOldSelector:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object callingKeyPathNewOldPriorSelector:(SEL)selector options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:keyPathNewOldPriorSelector:options:));
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object callingChangeDictionarySelector:(SEL)selector options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPath:on:changeDictionarySelector:options:));

// The following call `selector` on `self.owner` when any key path in `keyPaths` is observed on `object`.
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object callingSelector:(SEL)selector NS_SWIFT_NAME(startObserving(keyPaths:on:selector:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object callingSelector:(SEL)selector options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:selector:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object callingKeyPathSelector:(SEL)selector options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:keyPathSelector:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object callingNewOldSelector:(SEL)selector options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:newOldSelector:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object callingNewOldPriorSelector:(SEL)selector options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:newOldPriorSelector:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object callingKeyPathNewOldSelector:(SEL)selector options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:keyPathNewOldSelector:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object callingKeyPathNewOldPriorSelector:(SEL)selector options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:keyPathNewOldPriorSelector:options:));
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object callingChangeDictionarySelector:(SEL)selector options:(NSKeyValueObservingOptions)options NS_SWIFT_NAME(startObserving(keyPaths:on:changeDictionarySelector:options:));

- (void)stopObservingKeyPath:(NSString *)keyPath on:(NSObject *)object NS_SWIFT_NAME(stopObserving(keyPath:on:));
- (void)stopObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object NS_SWIFT_NAME(stopObserving(keyPaths:on:));
- (void)stopObservingAllKeyPathsOn:(NSObject *)object NS_SWIFT_NAME(stopObserving(allKeyPathsOn:));
- (void)stopObservingAllKeyPaths NS_SWIFT_NAME(stopObservingAllKeyPaths());

@end

NS_ASSUME_NONNULL_END
