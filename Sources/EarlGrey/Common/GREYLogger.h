//
// Copyright 2016 Google Inc.
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

/**
 *  @file GREYLogger.h
 *  @brief Macro for printing more logs for aiding in debugging.
 */

#import "../Common/GREYConstants.h"

/**
 *  Prints a log statement if @c kGREYAllowVerboseLogging is present and turned to @c YES in
 *  @c NSUserDefaults. You can pass it in the command line arguments as:
 *  To turn on, set @c kGREYAllowVerboseLogging key in @c NSUserDefaults to @c YES.
 *  @code
 *    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kGREYAllowVerboseLogging];
 *  @endcode
 *
 *  @remark Once you set this, as with any @c NSUserDefault, you need to explicitly turn it off
 *          or delete and re-install the app under test.
 *
 *  @param format The string format to be printed.
 *  @param ...    The parameters to be added to the string format.
 */
#define GREYLogVerbose(format, ...) \
({ \
  if ([[NSUserDefaults standardUserDefaults] boolForKey:kGREYAllowVerboseLogging]) { \
    NSLog((format), ##__VA_ARGS__); \
  } \
})


/**
 *  Log an error generated by the system or EarlGrey to the console.
 *
 *  @param error  An error object to be logged. This can be an @c NSError object or
 *                a @c GREYError object.
 *
 */
#define GREYLogError(error) \
({ \
  I_GREYLogError(error, \
                 [NSString stringWithUTF8String:__FILE__], \
                 __LINE__, \
                 [NSString stringWithUTF8String:__PRETTY_FUNCTION__], \
                 [NSThread callStackSymbols]); \
})

NS_ASSUME_NONNULL_BEGIN

/**
 *  Log an error generated by the system or EarlGrey to the console.
 */
GREY_EXPORT void I_GREYLogError(NSError *error,
                                NSString *filePath,
                                NSUInteger lineNumber,
                                NSString *functionName,
                                NSArray *stackTrace);

NS_ASSUME_NONNULL_END
