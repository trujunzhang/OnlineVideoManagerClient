//
// Created by djzhang on 12/31/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "FetchingOnlineInfoViewController.h"
#import "GYoutubeHelper.h"
#import "LeftRevealHelper.h"
#import "MxTabBarManager.h"


@interface FetchingOnlineInfoViewController ()<GYoutubeHelperDelegate> {
   ASTextNode * _fetchingInfo;
   ASTextNode * _shuffleNode;

}
@end


@implementation FetchingOnlineInfoViewController {

}
- (instancetype)initWithDelegate:(id<FetchingOnlineInfoViewControllerDelegate>)delegate {
   self = [super init];
   if (self) {
      self.delegate = delegate;

      [GYoutubeHelper getInstance].delegate = self;
      [self initOnlineClientInfo];

      [self setupUI];

      self.view.backgroundColor = [UIColor whiteColor];
   }

   return self;
}


- (void)setupUI {
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
       // 1
       ASTextNode * node = [[ASTextNode alloc] init];
       NSDictionary * attrsNode = @{
        NSFontAttributeName : [UIFont systemFontOfSize:32.0f],
        NSForegroundColorAttributeName : [UIColor blueColor],
       };
       node.attributedString = [[NSAttributedString alloc] initWithString:@"Fetching OnlineVideoInfo!"
                                                               attributes:attrsNode];
       [node measure:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
       node.frame = CGRectMake(100, 100, 100, 100);
       node.backgroundColor = [UIColor whiteColor];
       node.contentMode = UIViewContentModeRight;

       // 2
       // attribute a string
       NSDictionary * attrs = @{
        NSFontAttributeName : [UIFont systemFontOfSize:22.0f],
        NSForegroundColorAttributeName : [UIColor redColor],
       };
       NSAttributedString * string = [[NSAttributedString alloc] initWithString:@"Reload"
                                                                     attributes:attrs];

       // create the node
       _shuffleNode = [[ASTextNode alloc] init];
       _shuffleNode.attributedString = string;

       // configure the button
       _shuffleNode.userInteractionEnabled = YES; // opt into touch handling
       [_shuffleNode addTarget:self
                        action:@selector(buttonTapped:)
              forControlEvents:ASControlNodeEventTouchUpInside];

       // size all the things
       CGRect b = self.view.bounds; // convenience
       CGSize size = [_shuffleNode measure:CGSizeMake(b.size.width, FLT_MAX)];
       CGPoint origin = CGPointMake(roundf((b.size.width - size.width) / 2.0f),
        roundf((b.size.height - size.height) / 2.0f));
       _shuffleNode.frame = (CGRect) { origin, size };


       // self.view isn't a node, so we can only use it on the main thread
       dispatch_sync(dispatch_get_main_queue(), ^{
           _fetchingInfo = node;
           [self.view addSubview:node.view];
           [self.view addSubview:_shuffleNode.view];
       });
   });

}


- (void)buttonTapped:(id)sender {
   [self initOnlineClientInfo];
}


- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];
   CGRect rect = self.view.bounds;
   CGFloat dW = rect.size.width;
   CGFloat dH = 100;
   CGFloat dX = (rect.size.width - dW) / 2;
   CGFloat dY = (rect.size.height - dH) / 2 - 200;
   _fetchingInfo.frame = CGRectMake(dX, dY, dW, dH);
}


- (void)initOnlineClientInfo {

   SqliteResponseBlock sqliteResponseBlock = ^(NSObject * respObject) {
       [self.delegate fetchingOnlineClientCompletion];

       [[LeftRevealHelper sharedLeftRevealHelper] openLeftMenu];
       [[MxTabBarManager sharedTabBarManager] callbackUpdateYoutubeChannelCompletion:0];
   };

   [[GYoutubeHelper getInstance] initOnlineClient:sqliteResponseBlock];
}


- (void)showLoadingFailInfo {

}


#pragma mark -
#pragma mark GYoutubeHelperDelegate


- (void)showStepInfo:(NSString *)string {
   NSDictionary * attrsNode = @{
    NSFontAttributeName : [UIFont systemFontOfSize:32.0f],
    NSForegroundColorAttributeName : [UIColor blueColor],
   };
   _fetchingInfo.attributedString = [[NSAttributedString alloc] initWithString:string
                                                                    attributes:attrsNode];
}


@end