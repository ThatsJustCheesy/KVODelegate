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

- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(void(^)())block;
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingBlock:(void(^)())block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathBlock:(void(^)(NSString *keyPath))block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingNewOldBlock:(void(^)(_Nullable id newValue, _Nullable id oldValue))block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathNewOldBlock:(void(^)(NSString *keyPath, _Nullable id newValue, _Nullable id oldValue))block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingNewOldPriorBlock:(void(^)(_Nullable id newValue, _Nullable id oldValue, BOOL prior))block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPath:(NSString *)keyPath on:(NSObject *)object usingKeyPathNewOldPriorBlock:(void(^)(NSString *keyPath, _Nullable id newValue, _Nullable id oldValue, BOOL prior))block options:(NSKeyValueObservingOptions)options;

- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(void(^)())block;
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingBlock:(void(^)())block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathBlock:(void(^)(NSString *keyPath))block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingNewOldBlock:(void(^)(_Nullable id newValue, _Nullable id oldValue))block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathNewOldBlock:(void(^)(NSString *keyPath, _Nullable id newValue, _Nullable id oldValue))block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingNewOldPriorBlock:(void(^)(_Nullable id newValue, _Nullable id oldValue, BOOL prior))block options:(NSKeyValueObservingOptions)options;
- (void)startObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object usingKeyPathNewOldPriorBlock:(void(^)(NSString *keyPath, _Nullable id newValue, _Nullable id oldValue, BOOL prior))block options:(NSKeyValueObservingOptions)options;

- (void)stopObservingKeyPath:(NSString *)keyPath on:(NSObject *)object;
- (void)stopObservingKeyPaths:(NSArray<NSString*> *)keyPaths on:(NSObject *)object;
- (void)stopObservingAllKeyPathsOn:(NSObject *)object;
- (void)stopObservingAllKeyPaths;

@end

NS_ASSUME_NONNULL_END
