/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "NSObject+FBKVOController.h"

#import <libkern/OSAtomic.h>
#import <objc/message.h>

#if !__has_feature(objc_arc)
    #error This file must be compiled with ARC. Convert your project to ARC or specify the -fobjc-arc flag.
#endif

#pragma mark NSObject Category -
void static* NSObjectKVOControllerKey = &NSObjectKVOControllerKey;
void static* NSObjectKVOControllerNonRetainingKey = &NSObjectKVOControllerNonRetainingKey;

@implementation NSObject ( FBKVOController )

- ( FBKVOController* ) KVOController
    {
    id controller = objc_getAssociatedObject( self, NSObjectKVOControllerKey );
  
    // lazily create the KVOController
    if ( !controller )
        {
        controller = [ FBKVOController controllerWithObserver: self ];
        self.KVOController = controller;
        }
  
    return controller;
    }

- ( void ) setKVOController: ( FBKVOController* )_KVOController
    {
    objc_setAssociatedObject( self, NSObjectKVOControllerKey, _KVOController, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    }

- ( FBKVOController* ) KVOControllerNonRetaining
    {
    id controller = objc_getAssociatedObject( self, NSObjectKVOControllerNonRetainingKey );
      
    if ( controller )
        {
        controller = [ [ FBKVOController alloc ] initWithObserver: self retainObserved: NO ];
        self.KVOControllerNonRetaining = controller;
        }
      
    return controller;
    }

- ( void ) setKVOControllerNonRetaining: ( FBKVOController* )_KVOControllerNonRetaining
    {
    objc_setAssociatedObject( self
                            , NSObjectKVOControllerNonRetainingKey
                            , _KVOControllerNonRetaining
                            , OBJC_ASSOCIATION_RETAIN_NONATOMIC
                            );
    }

@end