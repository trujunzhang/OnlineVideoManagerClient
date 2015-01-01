#import <google-api-services-youtube/GYoutubeHelper.h>
#import "MxTabBarManager.h"
#import "YTVideoDetailViewController.h"
#import "LeftRevealHelper.h"
#import "ClientUIHelper.h"
#import "CollectionConstant.h"
#import "AsFileInfoVideoCollectionViewController.h"
#import "GGTabBarController.h"


@interface MxTabBarManager ()<GYoutubeHelperDelegate> {
   GGTabBarController * _tabBarController;
   NSArray * _tabBarViewControllerArray;
   YTLeftMenuViewController * _leftViewController;

   NSString * projectNameIDString;
}


@end


@implementation MxTabBarManager

+ (MxTabBarManager *)sharedTabBarManager {
   static MxTabBarManager * cache;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       cache = [[MxTabBarManager alloc] init];
       [GYoutubeHelper getInstance].delegate = cache;
   });

   return cache;
}


- (void)registerTabBarController:(GGTabBarController *)tabBarController withLeftViewController:(AsLeftMenuViewController *)leftViewController withTabbarControllerArray:(NSArray *)array {
   _tabBarController = tabBarController;
   _leftViewController = leftViewController;
   _tabBarViewControllerArray = array;
}


- (void)registerTabBarController:(UITabBarController *)tabBarController withLeftViewController:(id)leftViewController {

}


- (void)setLeftMenuControllerDelegate:(id)delegate {
   _leftViewController.delegate = delegate;
}


- (NSInteger)getCurrentNavigationIndex {
   return _tabBarController.selectedIndex;
}


- (UINavigationController *)currentNavigationController {
   NSUInteger integer = _tabBarController.selectedIndex;
   return _tabBarViewControllerArray[integer];
}


- (YTVideoDetailViewController *)makeVideoDetailViewController:(id)video {
   YTVideoDetailViewController * controller = [[YTVideoDetailViewController alloc] initWithVideo:video];
   controller.view.backgroundColor = [ClientUIHelper mainUIBackgroundColor];

   return controller;
}


- (NSString *)getCurrentProjectNameIDString {
   return projectNameIDString;
}


- (void)pushAndResetControllers:(NSArray *)controllers forChannelId:(NSString *)channelId {
   projectNameIDString = channelId;

   [[LeftRevealHelper sharedLeftRevealHelper] closeLeftMenuAndNoRearOpen];

   UINavigationController * navigationController = [self currentNavigationController];

   navigationController.viewControllers = nil;
   navigationController.viewControllers = controllers;
}


- (void)pushForYouTubePlayList:(id)playList withPlayListTitle:(NSString *)title {
   NSMutableArray * projectListArray = @[ playList ];

   AsFileInfoVideoCollectionViewController * controller = [[AsFileInfoVideoCollectionViewController alloc] initWithTitle:title
                                                                                                    withProjectListArray:projectListArray];
   controller.numbersPerLineArray = [NSArray arrayWithObjects:@"3", @"4", nil];


   [[LeftRevealHelper sharedLeftRevealHelper] closeLeftMenuAndNoRearOpen];

   UINavigationController * navigationController = [self currentNavigationController];

   [navigationController pushViewController:controller animated:YES];
}


- (void)pushWithVideo:(id)video {
   [[LeftRevealHelper sharedLeftRevealHelper] closeLeftMenuAndNoRearOpen];

   YTVideoDetailViewController * controller = [self makeVideoDetailViewController:video];

   UINavigationController * navigationController = [self currentNavigationController];

   [navigationController pushViewController:controller animated:YES];
}


#pragma mark -
#pragma mark GYoutubeHelperDelegate


- (void)callbackUpdateYoutubeChannelCompletion {
   [_leftViewController refreshChannelInfo];
}


@end
