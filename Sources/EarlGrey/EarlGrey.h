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
 *  Umbrella public header for the EarlGrey framework.
 *
 *  Instead of importing individual headers, import this header using:
 *  @code
 *    @import EarlGrey;  // if your project uses modules
 *  @endcode
 *    OR if your project doesn't use modules:
 *  @code
 *    #import "EarlGrey/EarlGrey.h"
 *  @endcode
 *
 *  To learn more, check out: http://github.com/google/EarlGrey
 */

#import <Foundation/Foundation.h>

#import "Action/GREYAction.h"
#import "Action/GREYActionBlock.h"
#import "Action/GREYActions.h"
#import "Action/GREYBaseAction.h"
#import "Action/GREYScrollActionError.h"
#import "AppSupport/GREYIdlingResource.h"
#import "Assertion/GREYAssertion.h"
#import "Assertion/GREYAssertionBlock.h"
#import "Assertion/GREYAssertionDefines.h"
#import "Assertion/GREYAssertions.h"
#import "Common/GREYConfiguration.h"
#import "Common/GREYConstants.h"
#import "Common/GREYDefines.h"
#import "Common/GREYElementHierarchy.h"
#import "Common/GREYScreenshotUtil.h"
#import "Common/GREYTestHelper.h"
#import "Core/EarlGreyImpl.h"
#import "Core/GREYElementFinder.h"
#import "Core/GREYElementInteraction.h"
#import "Core/GREYInteraction.h"
#import "Exception/GREYFailureHandler.h"
#import "Exception/GREYFrameworkException.h"
#import "Matcher/GREYAllOf.h"
#import "Matcher/GREYAnyOf.h"
#import "Matcher/GREYBaseMatcher.h"
#import "Matcher/GREYDescription.h"
#import "Matcher/GREYElementMatcherBlock.h"
#import "Matcher/GREYLayoutConstraint.h"
#import "Matcher/GREYMatcher.h"
#import "Matcher/GREYMatchers.h"
#import "Matcher/GREYNot.h"
#import "Provider/GREYDataEnumerator.h"
#import "Provider/GREYProvider.h"
#import "Synchronization/GREYCondition.h"
#import "Synchronization/GREYDispatchQueueIdlingResource.h"
#import "Synchronization/GREYManagedObjectContextIdlingResource.h"
#import "Synchronization/GREYNSTimerIdlingResource.h"
#import "Synchronization/GREYOperationQueueIdlingResource.h"
#import "Synchronization/GREYSyncAPI.h"
#import "Synchronization/GREYUIThreadExecutor.h"
