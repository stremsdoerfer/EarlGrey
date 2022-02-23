//
// Copyright 2017 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "UIApplication+ActiveRunLoopMode.h"

#include <objc/runtime.h>

#import "../../CommonLib/Assertion/GREYFatalAsserts.h"
#import "GREYAppleInternals.h"
#import "GREYDefines.h"
#import "GREYSwizzler.h"

/**
 * List for all the runloop modes that have been pushed and unpopped using UIApplication's push/pop
 * runloop mode methods. The most recently pushed runloop mode is at the end of the list.
 */
static NSMutableArray<NSString *> *gRunLoopModes;

@implementation UIApplication (ActiveRunLoopMode)

+ (void)load {
  gRunLoopModes = [[NSMutableArray alloc] init];
  GREYSwizzler *swizzler = [[GREYSwizzler alloc] init];

  if (iOS12_OR_ABOVE()) {
    SEL originalSel = @selector(_pushRunLoopMode:requester:reason:);
    SEL swizzledSel = @selector(greyswizzled_pushRunLoopMode:requester:reason:);
    BOOL swizzleSuccess = [swizzler swizzleClass:self
                           replaceInstanceMethod:originalSel
                                      withMethod:swizzledSel];
    GREYFatalAssertWithMessage(swizzleSuccess,
                               @"Cannot swizzle UIApplication _pushRunLoopMode:requester:reason:");
    originalSel = @selector(_popRunLoopMode:requester:reason:);
    swizzledSel = @selector(greyswizzled_popRunLoopMode:requester:reason:);
    swizzleSuccess = [swizzler swizzleClass:self
                      replaceInstanceMethod:originalSel
                                 withMethod:swizzledSel];
    GREYFatalAssertWithMessage(swizzleSuccess,
                               @"Cannot swizzle UIApplication _pushRunLoopMode:requester:reason:");
  } else {
    BOOL swizzleSuccess = [swizzler swizzleClass:self
                           replaceInstanceMethod:@selector(pushRunLoopMode:requester:)
                                      withMethod:@selector(greyswizzled_pushRunLoopMode:
                                                                              requester:)];
    GREYFatalAssertWithMessage(swizzleSuccess,
                               @"Cannot swizzle UIApplication pushRunLoopMode:requester:");
    swizzleSuccess = [swizzler swizzleClass:self
                      replaceInstanceMethod:@selector(popRunLoopMode:requester:)
                                 withMethod:@selector(greyswizzled_popRunLoopMode:requester:)];
    GREYFatalAssertWithMessage(swizzleSuccess,
                               @"Cannot swizzle UIApplication popRunLoopMode:requester:");
  }
}

- (NSString *)grey_activeRunLoopMode {
  @synchronized(gRunLoopModes) {
    // could be nil.
    return [gRunLoopModes lastObject];
  }
}

#pragma mark - Swizzled Implementation

- (void)greyswizzled_pushRunLoopMode:(NSString *)mode requester:(id)requester {
  [self grey_pushRunLoopMode:mode];
  INVOKE_ORIGINAL_IMP2(void, @selector(greyswizzled_pushRunLoopMode:requester:), mode, requester);
}

- (void)greyswizzled_popRunLoopMode:(NSString *)mode requester:(id)requester {
  [self grey_popRunLoopMode:mode];
  INVOKE_ORIGINAL_IMP2(void, @selector(greyswizzled_popRunLoopMode:requester:), mode, requester);
}

/** Internal push runloop method added post iOS 12.*/
- (void)greyswizzled_pushRunLoopMode:(NSString *)mode
                           requester:(id)requester
                              reason:(NSString *)reason {
  [self grey_pushRunLoopMode:mode];
  INVOKE_ORIGINAL_IMP3(void, @selector(greyswizzled_pushRunLoopMode:requester:reason:), mode,
                       requester, reason);
}

/** Internal pop runloop method added post iOS 12.*/
- (void)greyswizzled_popRunLoopMode:(NSString *)mode
                          requester:(id)requester
                             reason:(NSString *)reason {
  [self grey_popRunLoopMode:mode];
  INVOKE_ORIGINAL_IMP3(void, @selector(greyswizzled_popRunLoopMode:requester:reason:), mode,
                       requester, reason);
}

#pragma mark - Private

- (void)grey_pushRunLoopMode:(NSString *)mode {
  @synchronized(gRunLoopModes) {
    [gRunLoopModes addObject:mode];
  }
}

- (void)grey_popRunLoopMode:(NSString *)mode {
  @synchronized(gRunLoopModes) {
    NSString *topOfStackMode = [gRunLoopModes lastObject];
    if (![topOfStackMode isEqual:mode]) {
      NSLog(@"Mode being popped: %@ isn't top of stack: %@", mode, topOfStackMode);
      abort();
    }
    [gRunLoopModes removeLastObject];
  }
}

@end
