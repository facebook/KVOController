/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.

 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <XCTest/XCTest.h>

#import <FBKVOController/NSObject+FBKVOController.h>

@interface NSObject_FBKVOControllerTests : XCTestCase
@end

@implementation NSObject_FBKVOControllerTests

- (void)testFBKVOControllerOnAnyObjectIsNotNil {
  NSObject *object = [[NSObject alloc] init];
  XCTAssertNotNil(object.KVOController);
}

@end
