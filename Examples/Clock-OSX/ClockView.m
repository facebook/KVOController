/**
  Copyright (c) 2014-present, Facebook, Inc.
  All rights reserved.

  This source code is licensed under the BSD-style license found in the
  LICENSE file in the root directory of this source tree. An additional grant
  of patent rights can be found in the PATENTS file in the same directory.
 */

#import "ClockView.h"
#import "Clock.h"
#import "FBKVOController.h"

@implementation ClockView
{
  FBKVOController *_KVOController;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
  self = [super initWithFrame:frameRect];
  if (nil != self) {
    self.datePickerStyle = NSClockAndCalendarDatePickerStyle;
    self.datePickerElements = NSHourMinuteSecondDatePickerElementFlag;
    [self sizeToFit];
  }
  return self;
}

- (instancetype)initWithClock:(Clock *)clock
{
  self = [self init];
  if (nil != self) {
    // create KVO controller instance
    _KVOController = [FBKVOController controllerWithObserver:self];

    // handle clock change, including initial value
    [_KVOController observe:clock keyPath:@"date" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(NSString* keyPath, ClockView *clockView, Clock *clock, NSDictionary *change) {

      // update observer with new value
      if ( [ keyPath isEqualToString: @"date" ] )
        clockView.dateValue = change[NSKeyValueChangeNewKey];
    }];
  }
  return self;
}

@end
