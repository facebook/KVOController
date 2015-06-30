/**
  Copyright (c) 2014-present, Facebook, Inc.
  All rights reserved.

  This source code is licensed under the BSD-style license found in the
  LICENSE file in the root directory of this source tree. An additional grant
  of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>

/**
 Circle test object.
 */
@interface FBKVOTestCircle : NSObject
+ (instancetype)circle;
@property (assign, nonatomic) float radius;
@property (assign, nonatomic) float borderWidth;
@end

/**
 This global boolean is set to YES whenever an instance of
 FBKVOTestCircleDeallocating is deallocated.
 */
extern BOOL FBKVOTestCircleDeallocatingWasDeallocated;

/**
 Circle test object that sets some global state when it's deallocated.
 */
@interface FBKVOTestCircleDeallocating : FBKVOTestCircle
@end

/**
 Observer protocol for mocking.
 */
@protocol FBKVOTestObserving <NSObject>
- (void)propertyDidChange;
- (void)propertyDidChange:(NSDictionary *)change;
- (void)propertyDidChange:(NSDictionary *)change object:(id)object;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
@end

/**
 Observer test object that records the last set of values of an NSKeyValueObserving notification.
 */
@interface FBKVOTestObserver : NSObject
+ (instancetype)observer;
@property (strong, nonatomic) id lastObject;
@property (copy, nonatomic) NSString *lastKeyPath;
@property (copy, nonatomic) NSDictionary *lastChange;
@property (assign, nonatomic) void *lastContext;
@end
