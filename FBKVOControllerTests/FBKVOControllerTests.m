/**
  Copyright (c) 2014-present, Facebook, Inc.
  All rights reserved.

  This source code is licensed under the BSD-style license found in the
  LICENSE file in the root directory of this source tree. An additional grant
  of patent rights can be found in the PATENTS file in the same directory.
 */

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import <FBKVOController/FBKVOController.h>
#import <FBKVOController/NSObject+FBKVOController.h>

#import "FBKVOTesting.h"

@interface FBKVOControllerTests : XCTestCase
@end

@implementation FBKVOControllerTests

static NSString *radius = @"radius";
static NSString *borderWidth = @"borderWidth";
static void *context = (void *)@"context";
static NSKeyValueObservingOptions const optionsNone = 0;
static NSKeyValueObservingOptions const optionsBasic = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial;
static NSKeyValueObservingOptions const optionsAll = optionsBasic | NSKeyValueObservingOptionPrior;

- (void)testDebugDescriptionContainsClassName
{
  id<FBKVOTestObserving> observer = mockProtocol(@protocol(FBKVOTestObserving));
  FBKVOController *controller = [FBKVOController controllerWithObserver:observer];
  FBKVOTestCircle *circle = [FBKVOTestCircle circle];
  [controller observe:circle keyPaths:@[radius, borderWidth] options:optionsAll context:context];
  assertThat([controller debugDescription], containsSubstring(@"FBKVOController"));
}

- (void)testBlockOptionsBasic
{
  FBKVOTestCircle *circle = [FBKVOTestCircle circle];
  id<FBKVOTestObserving> observer = mockProtocol(@protocol(FBKVOTestObserving));
  FBKVOController *controller = [FBKVOController controllerWithObserver:observer];
  FBKVOTestObserver *referenceObserver = [FBKVOTestObserver observer];
  
  // add reference observe
  [circle addObserver:referenceObserver forKeyPath:radius options:optionsBasic context:context];
  
  __block NSUInteger blockCallCount = 0;
  __block id blockObserver = nil;
  __block id blockObject = nil;
  __block NSDictionary *blockChange = nil;
  
  // add mock observer
  [controller observe:circle keyPath:radius options:optionsBasic block:^(id observer, id object, NSDictionary *change) {
    blockObserver = observer;
    blockObject = object;
    blockChange = change;
    blockCallCount++;
  }];
  
  XCTAssert(1 == blockCallCount, @"unexpected block call count:%lu expected:%d", (unsigned long)blockCallCount, 1);
  XCTAssert(blockObserver == observer, @"value:%@ expected:%@", blockObserver, observer);
  XCTAssert(blockObject == referenceObserver.lastObject, @"value:%@ expected:%@", blockObject, referenceObserver.lastObject);
  XCTAssertEqualObjects(blockChange, referenceObserver.lastChange, @"value:%@ expected:%@", blockChange, referenceObserver.lastChange);
  
  circle.radius = 1.0;
  XCTAssert(2 == blockCallCount, @"unexpected block call count:%lu expected:%d", (unsigned long)blockCallCount, 2);
  XCTAssert(blockObserver == observer, @"value:%@ expected:%@", blockObserver, observer);
  XCTAssert(blockObject == referenceObserver.lastObject, @"value:%@ expected:%@", blockObject, referenceObserver.lastObject);
  XCTAssertEqualObjects(blockChange, referenceObserver.lastChange, @"value:%@ expected:%@", blockChange, referenceObserver.lastChange);
  
  // cleanup
  [circle removeObserver:referenceObserver forKeyPath:radius];
}

- (void)testNSKeyValueObservingOptionsNone
{
  FBKVOTestCircle *circle = [FBKVOTestCircle circle];
  id<FBKVOTestObserving> observer = mockProtocol(@protocol(FBKVOTestObserving));
  FBKVOController *controller = [FBKVOController controllerWithObserver:observer];
  FBKVOTestObserver *referenceObserver = [FBKVOTestObserver observer];

  // add observers
  [circle addObserver:referenceObserver forKeyPath:radius options:optionsNone context:context];
  [controller observe:circle keyPath:radius options:optionsNone context:context];

  // mutate
  circle.radius = 1.0;

  // verify
  [verify(observer) observeValueForKeyPath:referenceObserver.lastKeyPath ofObject:referenceObserver.lastObject change:referenceObserver.lastChange context:referenceObserver.lastContext];
  
  // cleanup
  [circle removeObserver:referenceObserver forKeyPath:radius];
}

- (void)testNSKeyValueObservingOptionsBasic
{
  FBKVOTestCircle *circle = [FBKVOTestCircle circle];
  id<FBKVOTestObserving> observer = mockProtocol(@protocol(FBKVOTestObserving));
  FBKVOController *controller = [FBKVOController controllerWithObserver:observer];
  FBKVOTestObserver *referenceObserver = [FBKVOTestObserver observer];

  // initial value
  circle.radius = 1.0;

  // add reference observe
  [circle addObserver:referenceObserver forKeyPath:radius options:optionsBasic context:context];
  
  // add mock observer
  [controller observe:circle keyPath:radius options:optionsBasic context:context];

  // verify 
  [verify(observer) observeValueForKeyPath:referenceObserver.lastKeyPath ofObject:referenceObserver.lastObject change:referenceObserver.lastChange context:referenceObserver.lastContext];
  
  // cleanup
  [circle removeObserver:referenceObserver forKeyPath:radius];
}

- (void)testNSKeyValueObservingOptionsAll
{
  FBKVOTestCircle *circle = [FBKVOTestCircle circle];
  id<FBKVOTestObserving> observer = mockProtocol(@protocol(FBKVOTestObserving));
  FBKVOController *controller = [FBKVOController controllerWithObserver:observer];
  FBKVOTestObserver *referenceObserver = [FBKVOTestObserver observer];

  // initial value
  circle.radius = 1.0;
  
  // add reference observe
  [circle addObserver:referenceObserver forKeyPath:radius options:optionsAll context:context];
  
  // add mock observer
  [controller observe:circle keyPath:radius options:optionsAll context:context];

  // verify initial
  [verify(observer) observeValueForKeyPath:referenceObserver.lastKeyPath ofObject:referenceObserver.lastObject change:referenceObserver.lastChange context:referenceObserver.lastContext];
  
  circle.radius = 2.0;

  // verify mutation
  [verify(observer) observeValueForKeyPath:referenceObserver.lastKeyPath ofObject:referenceObserver.lastObject change:referenceObserver.lastChange context:referenceObserver.lastContext];

  // cleanup
  [circle removeObserver:referenceObserver forKeyPath:radius];
}

- (void)testObserveKeyPathsOptionsBlockWhenKeyPathsIsNilRaises
{
  FBKVOController *controller = [FBKVOController controllerWithObserver:nil];
  FBKVONotificationBlock arbitraryBlock = ^(id observer, id object, NSDictionary *change) { /* noop */ };
  XCTAssertThrows([controller observe:nil keyPaths:(id _Nonnull)nil options:0 block:arbitraryBlock]);
}

- (void)testObserveKeyPathsOptionsBlockWhenKeyPathsIsEmptyRaises
{
  FBKVOController *controller = [FBKVOController controllerWithObserver:nil];
  NSArray *emptyKeyPaths = @[];
  FBKVONotificationBlock arbitraryBlock = ^(id observer, id object, NSDictionary *change) { /* noop */ };
  XCTAssertThrows([controller observe:nil keyPaths:emptyKeyPaths options:0 block:arbitraryBlock]);
}

- (void)testObserveKeyPathsOptionsBlockWhenBlockIsNilRaises
{
  FBKVOController *controller = [FBKVOController controllerWithObserver:nil];
  NSArray *arbitraryKeyPaths = @[@"ante", @"bellum"];
  XCTAssertThrows([controller observe:nil keyPaths:arbitraryKeyPaths options:0 block:(id _Nonnull)nil]);
}

- (void)testObserveKeyPathsOptionsBlockWhenObjectIsNilDoesNothing
{
  FBKVOController *controller = [FBKVOController controllerWithObserver:nil];
  NSArray *arbitraryKeyPaths = @[@"ante", @"bellum"];
  FBKVONotificationBlock arbitraryBlock = ^(id observer, id object, NSDictionary *change) { /* noop */ };
  XCTAssertNoThrow([controller observe:nil keyPaths:arbitraryKeyPaths options:0 block:arbitraryBlock]);
}

- (void)testObserveKeyPathsOptionsBlockObservesEachOfTheKeyPaths
{
  // Arrange 1: Create a controller to observe changes to a circle.
  id<FBKVOTestObserving> observer = mockProtocol(@protocol(FBKVOTestObserving));
  FBKVOController *controller = [FBKVOController controllerWithObserver:observer];

  // Arrange 2: Observe the key paths "radius" and "borderWidth" on the circle.
  //            Aggregate the new values in an array.
  NSMutableArray *newValues = [NSMutableArray array];
  FBKVOTestCircle *circle = [FBKVOTestCircle circle];
  [controller observe:circle keyPaths:@[radius, borderWidth] options:NSKeyValueObservingOptionNew block:^(id observer, FBKVOTestCircle *circle, NSDictionary *change) {
    [newValues addObject:change[NSKeyValueChangeNewKey]];
  }];

  // Act: Change the values to trigger the KVO notification block.
  circle.radius = 1.f;
  circle.borderWidth = 10.f;

  // Assert: Changes to the radius and borderWidth should have been observed.
  assertThat(newValues, equalTo(@[@1, @10]));
}

- (void)testObserveKeyPathsOptionsActionWhenKeyPathsIsNilRaises
{
  FBKVOController *controller = [FBKVOController controllerWithObserver:nil];
  SEL arbitrarySelector = @selector(cookies);
  XCTAssertThrows([controller observe:nil keyPaths:(id _Nonnull)nil options:0 action:arbitrarySelector]);
}

- (void)testObserveKeyPathsOptionsActionWhenKeyPathsIsEmptyRaises
{
  FBKVOController *controller = [FBKVOController controllerWithObserver:nil];
  NSArray *emptyKeyPaths = @[];
  SEL arbitrarySelector = @selector(cookies);
  XCTAssertThrows([controller observe:nil keyPaths:emptyKeyPaths options:0 action:arbitrarySelector]);
}

- (void)testObserveKeyPathsOptionsActionWhenActionIsNullRaises
{
  FBKVOController *controller = [FBKVOController controllerWithObserver:nil];
  NSArray *arbitraryKeyPaths = @[@"carpe", @"diem"];
  XCTAssertThrows([controller observe:nil keyPaths:arbitraryKeyPaths options:0 action:(SEL _Nonnull)NULL]);
}

- (void)testObserveKeyPathsOptionsActionWhenObjectIsNilRaises
{
  FBKVOController *controller = [FBKVOController controllerWithObserver:nil];
  NSArray *arbitraryKeyPaths = @[@"ante", @"bellum"];
  XCTAssertThrows([controller observe:nil keyPaths:arbitraryKeyPaths options:0 action:@selector(debugDescription)]);
}

- (void)testObserveKeyPathsOptionsActionWhenObjectDoesNotRespondToSelectorRaises
{
  FBKVOController *controller = [FBKVOController controllerWithObserver:nil];
  NSArray *arbitraryKeyPaths = @[@"caveat", @"emptor"];
  XCTAssertThrows([controller observe:[NSObject new] keyPaths:arbitraryKeyPaths options:0 action:@selector(cookies)]);
}

- (void)testObserveKeyPathsOptionsActionObservesEachOfTheKeyPaths
{
  // Arrange 1: Create a controller to observe changes to a circle.
  id<FBKVOTestObserving> observer = mockProtocol(@protocol(FBKVOTestObserving));
  FBKVOController *controller = [FBKVOController controllerWithObserver:observer];

  // Arrange 2: Observe the key paths "radius" and "borderWidth" on the circle.
  FBKVOTestCircle *circle = [FBKVOTestCircle circle];
  [controller observe:circle
             keyPaths:@[radius, borderWidth]
              options:NSKeyValueObservingOptionNew
               action:@selector(propertyDidChange)];

  // Act: Change the values to trigger the KVO action selector.
  circle.radius = 1.f;
  circle.borderWidth = 10.f;

  // Assert: Changes to the radius and borderWidth should have been observed.
  [verifyCount(observer, times(2)) propertyDidChange];
}

- (void)testObserveKeyPathsOptionsContextWhenKeyPathsIsNilRaises
{
  FBKVOController *controller = [FBKVOController controllerWithObserver:nil];
  XCTAssertThrows([controller observe:nil keyPaths:(id _Nonnull)nil options:0 context:NULL]);
}

- (void)testObserveKeyPathsOptionsContextWhenKeyPathsIsEmptyRaises
{
  FBKVOController *controller = [FBKVOController controllerWithObserver:nil];
  NSArray *emptyKeyPaths = @[];
  XCTAssertThrows([controller observe:nil keyPaths:emptyKeyPaths options:0 context:NULL]);
}

- (void)testObserveKeyPathsOptionsContextWhenObjectIsNilDoesNothing
{
  FBKVOController *controller = [FBKVOController controllerWithObserver:nil];
  NSArray *arbitraryKeyPaths = @[@"terra", @"firma"];
  XCTAssertNoThrow([controller observe:nil keyPaths:arbitraryKeyPaths options:0 context:NULL]);
}

- (void)testObserveKeyPathsOptionsContextObservesEachOfTheKeyPaths
{
  // Arrange 1: Create a controller to observe changes to a circle.
  id<FBKVOTestObserving> observer = mockProtocol(@protocol(FBKVOTestObserving));
  FBKVOController *controller = [FBKVOController controllerWithObserver:observer];

  // Arrange 2: Observe the key paths "radius" and "borderWidth" on the circle.
  FBKVOTestCircle *circle = [FBKVOTestCircle circle];
  [controller observe:circle
             keyPaths:@[radius, borderWidth]
              options:NSKeyValueObservingOptionNew
              context:NULL];

  // Act: Change the values to trigger the KVO action selector.
  circle.radius = 1.f;
  circle.borderWidth = 10.f;

  // Assert: Changes to the radius and borderWidth should have been observed.
  [verifyCount(observer, times(1)) observeValueForKeyPath:radius
                                                 ofObject:circle
                                                   change:anything()
                                                  context:NULL];
  [verifyCount(observer, times(1)) observeValueForKeyPath:borderWidth
                                                 ofObject:circle
                                                   change:anything()
                                                  context:NULL];
}

- (void)testObserveKeyPathsOptionsContextUnobserveWithinBlockWithOptionInitial
{
  id<FBKVOTestObserving> observer = mockProtocol(@protocol(FBKVOTestObserving));
  FBKVOController *controller = [FBKVOController controllerWithObserver:observer];
  FBKVOTestCircle *circle = [FBKVOTestCircle circle];

  circle.radius = 1.0;
  __block float lastObservedRadius = 0.f;
  [controller observe:circle
              keyPath:radius
              options:NSKeyValueObservingOptionInitial
                block:^(id observer, id object, NSDictionary *change) {
                  lastObservedRadius = circle.radius;
                  [controller unobserve:circle];
                }];

  XCTAssertNoThrow(circle.radius = 2.f);
  XCTAssertEqual(lastObservedRadius, 1.f);
}

- (void)testCustomActionOptionsBasic
{
  FBKVOTestCircle *circle = [FBKVOTestCircle circle];
  id<FBKVOTestObserving> observer = mockProtocol(@protocol(FBKVOTestObserving));
  FBKVOController *controller = [FBKVOController controllerWithObserver:observer];
  
  // add mock observer
  [controller observe:circle keyPath:radius options:optionsBasic action:@selector(propertyDidChange)];

  // verify initial
  [verifyCount(observer, times(1)) propertyDidChange];

  // verify mutation
  circle.radius = 1.0;
  [verifyCount(observer, times(2)) propertyDidChange];
}

- (void)testCustomActionWithChangeOptionsBasic
{
  FBKVOTestCircle *circle = [FBKVOTestCircle circle];
  id<FBKVOTestObserving> observer = mockProtocol(@protocol(FBKVOTestObserving));
  FBKVOController *controller = [FBKVOController controllerWithObserver:observer];
  FBKVOTestObserver *referenceObserver = [FBKVOTestObserver observer];

  // add reference observe
  [circle addObserver:referenceObserver forKeyPath:radius options:optionsBasic context:context];

  // add mock observer
  [controller observe:circle keyPath:radius options:optionsBasic action:@selector(propertyDidChange:)];

  // verify initial
  [verify(observer) propertyDidChange:referenceObserver.lastChange];
  
  circle.radius = 2.0;
  
  // verify mutation
  [verify(observer) propertyDidChange:referenceObserver.lastChange];
  
  // cleanup
  [circle removeObserver:referenceObserver forKeyPath:radius];
}

- (void)testCustomActionWithChangeObjectOptionsBasic
{
  FBKVOTestCircle *circle = [FBKVOTestCircle circle];
  id<FBKVOTestObserving> observer = mockProtocol(@protocol(FBKVOTestObserving));
  FBKVOController *controller = [FBKVOController controllerWithObserver:observer];
  FBKVOTestObserver *referenceObserver = [FBKVOTestObserver observer];
  
  // add reference observe
  [circle addObserver:referenceObserver forKeyPath:radius options:optionsBasic context:context];
  
  // add mock observer
  [controller observe:circle keyPath:radius options:optionsBasic action:@selector(propertyDidChange:object:)];
  
  // verify initial
  [verify(observer) propertyDidChange:referenceObserver.lastChange object:referenceObserver.lastObject];
  
  circle.radius = 2.0;
  
  // verify mutation
  [verify(observer) propertyDidChange:referenceObserver.lastChange object:referenceObserver.lastObject];
  
  // cleanup
  [circle removeObserver:referenceObserver forKeyPath:radius];
}

- (void)testUnobserveKeyPath
{
  FBKVOTestCircle *circle = [FBKVOTestCircle circle];
  id<FBKVOTestObserving> observer = mockProtocol(@protocol(FBKVOTestObserving));
  FBKVOController *controller = [FBKVOController controllerWithObserver:observer];

  // observe radius and borderWidth
  [controller observe:circle keyPath:radius options:optionsNone context:context];
  [controller observe:circle keyPath:borderWidth options:optionsNone context:context];

  // mutate both properties
  circle.radius = 1.0;
  circle.borderWidth = 1.0;
  
  // verify
  [verifyCount(observer, times(2)) observeValueForKeyPath:anything() ofObject:circle change:anything() context:context];
  
  // unobserve borderWidth
  [controller unobserve:circle keyPath:borderWidth];

  // mutate both properties
  circle.radius = 2.0;
  circle.borderWidth = 2.0;
  
  // verify
  [verifyCount(observer, times(3)) observeValueForKeyPath:anything() ofObject:circle change:anything() context:context];
}

- (void)testUnobserveObject
{
  FBKVOTestCircle *circle1 = [FBKVOTestCircle circle];
  FBKVOTestCircle *circle2 = [FBKVOTestCircle circle];
  id<FBKVOTestObserving> observer = mockProtocol(@protocol(FBKVOTestObserving));
  FBKVOController *controller = [FBKVOController controllerWithObserver:observer];
  FBKVOTestObserver *referenceObserver = [FBKVOTestObserver observer];

  // observe circle1 and circle2
  [controller observe:circle1 keyPath:radius options:optionsNone action:@selector(propertyDidChange:object:)];
  [controller observe:circle2 keyPath:radius options:optionsNone action:@selector(propertyDidChange:object:)];

  // unobserve circle2
  [controller unobserve:circle2];

  // add reference observer
  [circle1 addObserver:referenceObserver forKeyPath:radius options:optionsNone context:context];

  // mutate circle1 and circle2
  circle1.radius = 1.0;
  circle2.radius = 1.0;

  // verify mutation
  [verifyCount(observer, times(1)) propertyDidChange:referenceObserver.lastChange object:referenceObserver.lastObject];
  
  // cleanup
  [circle1 removeObserver:referenceObserver forKeyPath:radius];
}

- (void)testDeallocatedController
{
  FBKVOTestCircle *circle = [FBKVOTestCircle circle];
  id<FBKVOTestObserving> observer = mockProtocol(@protocol(FBKVOTestObserving));
  __attribute__((objc_precise_lifetime)) FBKVOController *controller = nil;
  
  @autoreleasepool {
    controller = [FBKVOController controllerWithObserver:observer];
  
    // add mock observer
    [controller observe:circle keyPath:radius options:optionsBasic action:@selector(propertyDidChange)];
    
    // verify initial
    [verifyCount(observer, times(1)) propertyDidChange];
    
    // dealloc controller
    controller = nil;
  }
  
  // mutate
  circle.radius = 1.0;
  
  // verify unobserve all
  [verifyCount(observer, times(1)) propertyDidChange];
}

- (void)testDeallocatedObserver
{
  FBKVOTestCircle *circle = [FBKVOTestCircle circle];
  __attribute__((objc_precise_lifetime)) id<FBKVOTestObserving> observer = mockProtocol(@protocol(FBKVOTestObserving));
  FBKVOController *controller = [FBKVOController controllerWithObserver:observer];

  // add mock observer
  [controller observe:circle keyPath:radius options:optionsBasic action:@selector(propertyDidChange)];
  
  // verify initial
  [verifyCount(observer, times(1)) propertyDidChange];
  
  // dealloc observer
  observer = nil;

  // mutate witout throwing exception
  circle.radius = 1.0;
}

- (void)testTravisContinuousIntegrationHappyDance
{
  // happy dance
  return;
}

@end
