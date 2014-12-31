#import <UIKit/UIKit.h>


@interface MxTabBarManager : NSObject

+ (MxTabBarManager *)sharedTabBarManager;

- (void)setLeftMenuControllerDelegate:(id)delegate;
- (UINavigationController *)currentNavigationController;
- (id)makeVideoDetailViewController:(id)video;

- (void)pushAndResetControllers:(NSArray *)controllers;
- (void)pushForYouTubePlayList:(id)playList withPlayListTitle:(NSString *)title;
- (void)pushWithVideo:(id)video;

- (void)callbackUpdateYoutubeChannelCompletion;
- (void)registerTabBarController:(id)controller withLeftViewController:(id)controller1 withTabbarControllerArray:(NSArray *)array;
@end
