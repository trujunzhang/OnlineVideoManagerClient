//
// Created by djzhang on 12/31/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "FetchingOnlineInfoViewController.h"
#import "GYoutubeHelper.h"
#import "LeftRevealHelper.h"
#import "MxTabBarManager.h"


@implementation FetchingOnlineInfoViewController {

}
- (instancetype)initWithDelegate:(id<FetchingOnlineInfoViewControllerDelegate>)delegate {
   self = [super init];
   if (self) {
      self.delegate = delegate;
      [self initOnlineClientInfo];

      self.view.backgroundColor = [UIColor redColor];
   }

   return self;
}


- (void)initOnlineClientInfo {
   [self.delegate fetchingOnlineClientCompletion];

   [[LeftRevealHelper sharedLeftRevealHelper] openLeftMenu];
   [[MxTabBarManager sharedTabBarManager] callbackUpdateYoutubeChannelCompletion];
}


- (void)initOnlineClientInfo123 {
   [[GYoutubeHelper getInstance] initOnlineClient:^(NSURLResponse * response, NSURL * url, NSError * error) {
       if (error) {
          [self showLoadingFailInfo];
       } else {
          [self.delegate fetchingOnlineClientCompletion];

          [[LeftRevealHelper sharedLeftRevealHelper] openLeftMenu];
          [[MxTabBarManager sharedTabBarManager] callbackUpdateYoutubeChannelCompletion];
       }
   }];
}


- (void)showLoadingFailInfo {

}

@end