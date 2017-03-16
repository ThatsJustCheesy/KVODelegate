//
//  KeyValueObservancesDelegate.h
//  AutoScript
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

- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(KVONoParamsBlock)block;
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(KVONoParamsBlock)block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathBlock:(KVOKeyPathBlock)block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingNewOldBlock:(KVONewOldBlock)block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathNewOldBlock:(KVOKeyPathNewOldBlock)block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingNewOldPriorBlock:(KVONewOldPriorBlock)block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathNewOldPriorBlock:(KVOKeyPathNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingChangeDictionaryBlock:(KVOChangeDictionaryBlock)block options:(NSKeyValueObservingOptions)options;

- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(KVONoParamsBlock)block;
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(KVONoParamsBlock)block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathBlock:(KVOKeyPathBlock)block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingNewOldBlock:(KVONewOldBlock)block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathNewOldBlock:(KVOKeyPathNewOldBlock)block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingNewOldPriorBlock:(KVONewOldPriorBlock)block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathNewOldPriorBlock:(KVOKeyPathNewOldPriorBlock)block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingChangeDictionaryBlock:(KVOChangeDictionaryBlock)block options:(NSKeyValueObservingOptions)options;

- (void)stopObservingKeyPath:(NSString *)keyPath on:(NSObject *)object;
- (void)stopObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object;
- (void)stopObservingAllKeyPathsOn:(NSObject *)object;
- (void)stopObservingAllKeyPaths;

@end

NS_ASSUME_NONNULL_END
