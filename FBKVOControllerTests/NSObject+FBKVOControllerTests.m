/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.

 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <XCTest/XCTest.h>

#import <FBKVOController/NSObject+FBKVOController.h>

#import "FBKVOTesting.h"

@interface NSObject_FBKVOControllerTests : XCTestCase
@end

@implementation NSObject_FBKVOControllerTests

- (void)setUp
{
  [super setUp];
  FBKVOTestCircleDeallocatingWasDeallocated = NO;
}

- (void)testFBKVOControllerOnAnyObjectIsNotNil
{
  // Arrange: Begin observing an object using a non-retaining observer.
  NSObject *observer = [NSObject new];
  FBKVOTestCircleDeallocating *deallocating = [FBKVOTestCircleDeallocating circle];
  [observer.KVOController observe:deallocating keyPath:@"radius" options:0 block:^(id observer, id object, NSDictionary *change) {
    // noop
  }];

  // Act: Decrement the reference count of the object we're observing.
  deallocating = nil;

  XCTAssertFalse(FBKVOTestCircleDeallocatingWasDeallocated,
                 @"The object should not have been deallocated because its observer was retaining.");
}

- (void)testFBKVOControllerNotRetainingOnAnyObjectIsNotNil
{
  // Arrange: Begin observing an object using a non-retaining observer.
  NSObject *observer = [NSObject new];
  FBKVOTestCircleDeallocating *deallocating = [FBKVOTestCircleDeallocating circle];
  [observer.KVOControllerNonRetaining observe:deallocating keyPath:@"radius" options:0 block:^(id observer, id object, NSDictionary *change) {
    // noop
  }];

  // Act: Release the object we're observing.
  deallocating = nil;

  XCTAssertTrue(FBKVOTestCircleDeallocatingWasDeallocated,
                @"The object should have been deallocated because its observer was non-retaining.");
}

@end
