/**
  Copyright (c) 2014-present, Facebook, Inc.
  All rights reserved.

  This source code is licensed under the BSD-style license found in the
  LICENSE file in the root directory of this source tree. An additional grant
  of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>
#import "FBKVOController.h"

@interface NSObject ( FBKVOController )

/**
 @abstract Lazy-loaded FBKVOController for use with any object
 @return FBKVOController associated with this object, creating one if necessary
 @discussion This makes it convenient to simply create and forget a FBKVOController, and when this object gets dealloc'd, so will the associated controller and the observation info.
 */
@property ( nonatomic, strong ) FBKVOController* KVOController;
@property ( nonatomic, strong ) FBKVOController* KVOControllerNonRetaining;

@end
