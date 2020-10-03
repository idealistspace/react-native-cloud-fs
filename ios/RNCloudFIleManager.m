//
//  RNCloudFileManager.m
//  RNCloudFs
//
//  Created by Shaomeng Zhang on 10/2/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "RNCloudFileManager.h"

@implementation RNCloudFileManager
{
  bool hasListeners;
}
RCT_EXPORT_MODULE();

// Will be called when this module's first listener is added.
-(void)startObserving {
    hasListeners = YES;
    // Set up any upstream listeners or background tasks as necessary
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving {
    hasListeners = NO;
    // Remove upstream listeners, stop unnecessary background tasks
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"FileLoader"];
}

RCT_EXPORT_METHOD(startLoading:(NSString *)filename
resolver:(RCTPromiseResolveBlock)resolver
rejecter:(RCTPromiseRejectBlock)rejecter)
{
//    [[RNCloudFileL]]
}

- (void)fileLoading:(NSNotification *)notification
{
    NSString *eventName = notification.userInfo[@"name"];
    if (hasListeners) { // Only send events if anyone is listening
        [self sendEventWithName:@"FileLoader" body:@{@"name": eventName}];
    }
}

@end
