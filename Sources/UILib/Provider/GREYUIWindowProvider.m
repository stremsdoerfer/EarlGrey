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

#import "GREYUIWindowProvider.h"

#import "../../CommonLib/Assertion/GREYFatalAsserts.h"
#import "GREYAppleInternals.h"

UIWindow *GREYGetApplicationKeyWindow(UIApplication *application) {
  // New API only available on Xcode 13+
#if (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 120000) || \
    (defined(__TV_OS_VERSION_MAX_ALLOWED) && __TV_OS_VERSION_MAX_ALLOWED >= 150000) ||       \
    (defined(__WATCH_OS_VERSION_MAX_ALLOWED) && __WATCH_OS_VERSION_MAX_ALLOWED >= 150000) || \
    (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000)
  if (@available(iOS 15.0, *)) {
    // There can be multiple key windows on iOS 15 because they are now bound to UIScene.
    // This may indicate that all the active scenes can receive keyboard/system events at the same
    // time, we currently only return the first key window for testing purposes. We shall evaluate
    // how EarlGrey can support multiple key windows later.
    // TODO(b/191156739): Support multiple key windows.
    NSSet<UIScene *> *scenes = application.connectedScenes;
    NSPredicate *filter = [NSPredicate
        predicateWithBlock:^BOOL(UIWindowScene *scene, NSDictionary<NSString *, id> *unused) {
          if (![scene isKindOfClass:UIWindowScene.class]) {
            return NO;
          } else if (scene.activationState != UISceneActivationStateForegroundActive) {
            return NO;
          } else {
            return scene.keyWindow != nil;
          }
        }];
    NSSet<UIScene *> *keyScenes = [scenes filteredSetUsingPredicate:filter];
    return ((UIWindowScene *)keyScenes.anyObject).keyWindow;
  }
#endif

  if (@available(iOS 13.0, *)) {
    NSArray<UIWindow *> *windows = application.windows;
    NSPredicate *windowFilter =
        [NSPredicate predicateWithBlock:^BOOL(UIWindow *window,
                                              NSDictionary<NSString *, id> *_Nullable bindings) {
          return window.isKeyWindow;
        }];
    NSArray<UIWindow *> *keyWindows = [windows filteredArrayUsingPredicate:windowFilter];
    // on iOS 15+, it's possible to have multiple key windows, we only return the first one for now.
    return keyWindows.firstObject;
  } else {
    // This API is deprecated in iOS 13, so we suppress warning here in case its minimum required
    // SDKs are lower.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [application keyWindow];
#pragma clang diagnostic pop
  }
}

@implementation GREYUIWindowProvider {
  NSArray<UIWindow *> *_windows;
  BOOL _includeStatusBar;
}

+ (instancetype)providerWithWindows:(NSArray<UIWindow *> *)windows {
  return [[GREYUIWindowProvider alloc] initWithWindows:windows withStatusBar:NO];
}

+ (instancetype)providerWithAllWindowsWithStatusBar:(BOOL)includeStatusBar {
  return [[GREYUIWindowProvider alloc] initWithAllWindowsWithStatusBar:includeStatusBar];
}

- (instancetype)initWithWindows:(NSArray<UIWindow *> *)windows
                  withStatusBar:(BOOL)includeStatusBar {
  self = [super init];
  if (self) {
    _windows = [windows copy];
    _includeStatusBar = includeStatusBar;
  }
  return self;
}

- (instancetype)initWithAllWindowsWithStatusBar:(BOOL)includeStatusBar {
  self = [self initWithWindows:@[] withStatusBar:includeStatusBar];
  if (self) {
    // Cannot pass in nil to the designated initializer.
    _windows = nil;
  }
  return self;
}

- (NSEnumerator *)dataEnumerator {
  GREYFatalAssertMainThread();
  if (_windows) {
    return [_windows objectEnumerator];
  } else {
    return [[[self class] allWindowsWithStatusBar:_includeStatusBar] objectEnumerator];
  }
}

+ (NSArray *)windowsFromLevelOfWindow:(UIWindow *)window withStatusBar:(BOOL)includeStatusBar {
  NSArray<UIWindow *> *windows = [self allWindowsWithStatusBar:includeStatusBar];
  NSUInteger index = [windows indexOfObject:window];
  NSRange range = NSMakeRange(0, index + 1);
  return [windows subarrayWithRange:range];
}

+ (NSArray<UIWindow *> *)allWindowsWithStatusBar:(BOOL)includeStatusBar {
  UIApplication *sharedApp = UIApplication.sharedApplication;
  NSMutableOrderedSet<UIWindow *> *windows = [[NSMutableOrderedSet alloc] init];
  if (sharedApp.windows) {
    [windows addObjectsFromArray:sharedApp.windows];
  }

  if ([sharedApp.delegate respondsToSelector:@selector(window)] && sharedApp.delegate.window) {
    [windows addObject:sharedApp.delegate.window];
  }

  UIWindow *keyWindow = GREYGetApplicationKeyWindow(sharedApp);
  if (keyWindow) {
    [windows addObject:keyWindow];
  }

  if (includeStatusBar) {
    UIWindow *statusBarWindow;
    // Add the status bar if asked for.
    if (@available(iOS 13.0, *)) {
#if TARGET_OS_IOS && defined(__IPHONE_13_0)
      // Check if any status bar is already present in the application's views.
      BOOL statusBarPresent = NO;
      for (UIWindow *window in windows) {
        if (window.windowLevel == UIWindowLevelStatusBar) {
          statusBarPresent = YES;
          break;
        }
      }
      // Create a local status bar and add it to the windows array for iteration.
      if (!statusBarPresent) {
        UIStatusBarManager *manager = [[keyWindow windowScene] statusBarManager];
        UIView *localStatusBar = (UIView *)[manager createLocalStatusBar];
        statusBarWindow = [[UIWindow alloc] initWithFrame:localStatusBar.frame];
        [statusBarWindow addSubview:localStatusBar];
        [statusBarWindow setHidden:NO];
        statusBarWindow.windowLevel = UIWindowLevelStatusBar;
      }
#endif  // TARGET_OS_IOS && defined(__IPHONE_13_0)
    } else {
      statusBarWindow = sharedApp.statusBarWindow;
    }

    if (statusBarWindow) {
      [windows addObject:statusBarWindow];
    }
  }

  // After sorting, reverse the windows because they need to appear from front to back.
  return [[windows sortedArrayWithOptions:NSSortStable
                          usingComparator:^NSComparisonResult(id obj1, id obj2) {
                            if ([obj1 windowLevel] < [obj2 windowLevel]) {
                              return -1;
                            } else if ([obj1 windowLevel] == [obj2 windowLevel]) {
                              return 0;
                            } else {
                              return 1;
                            }
                          }] reverseObjectEnumerator]
      .allObjects;
}

@end
