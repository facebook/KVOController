/**
  Copyright (c) 2014-present, Facebook, Inc.
  All rights reserved.

  This source code is licensed under the BSD-style license found in the
  LICENSE file in the root directory of this source tree. An additional grant
  of patent rights can be found in the PATENTS file in the same directory.
 */

#import "ClockView.h"
#import "ClockLayer.h"
#import <FBKVOController/FBKVOController.h>

#define CLOCK_LAYER(VIEW) ((ClockLayer *)VIEW.layer)

static NSDictionary *layer_style(ClockViewStyle viewStyle)
{
  NSDictionary *dict = nil;
  switch (viewStyle) {
    case kClockViewStyleLight:
      dict = [ClockLayer lightStyle];
      break;
    case kClockViewStyleDark:
      dict = [ClockLayer darkStyle];
      break;
    default:
      break;
  }
  return dict;
}

@implementation ClockView
{
  FBKVOController *_KVOController;
}

+ (Class)layerClass
{
  return [ClockLayer class];
}

- (instancetype)initWithClock:(Clock *)clock style:(ClockViewStyle)style
{
  self = [super init];
  if (nil != self) {
    CLOCK_LAYER(self).style = layer_style(style);
    
    // create KVO controller instance
    _KVOController = [FBKVOController controllerWithObserver:self];
    
    // handle clock change, including initial value
    [_KVOController observe:clock keyPath:@"date" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(NSString* keyPath, ClockView *clockView, Clock *clock, NSDictionary *change) {
      
      // update observer with new value
      if ( [ keyPath isEqualToString: @"date" ] )
        CLOCK_LAYER(clockView).date = change[NSKeyValueChangeNewKey];
    }];
  }
  return self;
}

@end
