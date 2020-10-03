//
//  RNCloudFileManager.h
//  RNCloudFs
//
//  Created by Shaomeng Zhang on 10/2/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __has_include(<React/RCTBridgeModule.h>)
  #import <React/RCTBridgeModule.h>
#else
  #import "RCTBridgeModule.h"
#endif
#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNCloudFileManager : RCTEventEmitter <RCTBridgeModule>

@end

NS_ASSUME_NONNULL_END
