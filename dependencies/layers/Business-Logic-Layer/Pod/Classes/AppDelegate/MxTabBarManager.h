#import <UIKit/UIKit.h>


@interface MxTabBarManager : NSObject

+ (MxTabBarManager *)sharedTabBarManager;

- (void)setLeftMenuControllerDelegate:(id)delegate;
- (NSInteger)getCurrentNavigationIndex;
- (UINavigationController *)currentNavigationController;
- (id)makeVideoDetailViewController:(id)video;

- (NSString *)getCurrentProjectNameIDString;
- (void)pushAndResetControllers:(NSArray *)controllers forChannelId:(NSString *)id1;
- (void)pushForYouTubePlayList:(id)playList withPlayListTitle:(NSString *)title;
- (void)pushWithVideo:(id)video;

- (void)callbackUpdateYoutubeChannelCompletion;
- (void)registerTabBarController:(id)controller withLeftViewController:(id)controller1 withTabbarControllerArray:(NSArray *)array;
@end
