/**
  Copyright (c) 2014-present, Facebook, Inc.
  All rights reserved.

  This source code is licensed under the BSD-style license found in the
  LICENSE file in the root directory of this source tree. An additional grant
  of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBKVOTesting.h"

@implementation FBKVOTestCircle

+ (instancetype)circle
{
  return [[self alloc] init];
}

- (NSString *)debugDescription
{
  return [NSString stringWithFormat:@"<%@:%p radius:%f borderWidth:%f>", self, self.class, _radius, _borderWidth];
}

@end

BOOL FBKVOTestCircleDeallocatingWasDeallocated = NO;

@implementation FBKVOTestCircleDeallocating

- (void)dealloc
{
  FBKVOTestCircleDeallocatingWasDeallocated = YES;
}

@end

@implementation FBKVOTestObserver

+ (instancetype)observer
{
  return [[self alloc] init];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  self.lastKeyPath = keyPath;
  self.lastObject = object;
  self.lastChange = change;
  self.lastContext = context;
}

- (NSString *)debugDescription
{
  return [NSString stringWithFormat:@"<%@:%p lastKeyPath:%@ lastObject:%@ lastChange:%@ lastContext:%p>", self, self.class, _lastKeyPath, _lastObject, _lastChange, _lastContext];
}

@end
