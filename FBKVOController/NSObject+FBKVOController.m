/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "NSObject+FBKVOController.h"

#import <objc/message.h>

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Convert your project to ARC or specify the -fobjc-arc flag.
#endif

#pragma mark NSObject Category -

NS_ASSUME_NONNULL_BEGIN

static void *NSObjectKVOControllerKey = &NSObjectKVOControllerKey;
static void *NSObjectKVOControllerNonRetainingKey = &NSObjectKVOControllerNonRetainingKey;
static void *NSObjectKVOControllerForSelfKey = &NSObjectKVOControllerForSelfKey;

@implementation NSObject (FBKVOController)

- (FBKVOController *)KVOController
{
  id controller = objc_getAssociatedObject(self, NSObjectKVOControllerKey);
  
  // lazily create the KVOController
  if (nil == controller) {
    controller = [FBKVOController controllerWithObserver:self];
    self.KVOController = controller;
  }
  
  return controller;
}

- (void)setKVOController:(FBKVOController *)KVOController
{
  objc_setAssociatedObject(self, NSObjectKVOControllerKey, KVOController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (FBKVOController *)KVOControllerNonRetaining
{
  id controller = objc_getAssociatedObject(self, NSObjectKVOControllerNonRetainingKey);
  
  if (nil == controller) {
    controller = [[FBKVOController alloc] initWithObserver:self storeType:FBKVOControllerObjectStoreTypeWeak];
    self.KVOControllerNonRetaining = controller;
  }
  
  return controller;
}

- (void)setKVOControllerNonRetaining:(FBKVOController *)KVOControllerNonRetaining
{
  objc_setAssociatedObject(self, NSObjectKVOControllerNonRetainingKey, KVOControllerNonRetaining, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (FBKVOController *)KVOControllerForSelf
{
  id controller = objc_getAssociatedObject(self, NSObjectKVOControllerForSelfKey);
  
  if (nil == controller) {
    controller = [[FBKVOController alloc] initWithObserver:self storeType:FBKVOControllerObjectStoreTypeAssign];
    self.KVOControllerForSelf = controller;
  }
  
  return controller;
}

- (void)setKVOControllerForSelf:(FBKVOController *)KVOControllerForSelf
{
  objc_setAssociatedObject(self, NSObjectKVOControllerForSelfKey, KVOControllerForSelf, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


NS_ASSUME_NONNULL_END
