//
//  Search.h
//  IOSTemplate
//
//  Created by djzhang on 9/25/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "YoutubeConstants.h"
#import "GYoutubeRequestInfo.h"


@class GYoutubeRequestInfo;

typedef void (^YoutubeResponseBlock)(NSArray * array, NSObject * respObject);
typedef void (^ErrorResponseBlock)(NSError * error);


@protocol GYoutubeHelperDelegate<NSObject>

@optional


@end


@interface GYoutubeHelper : NSObject {

}
// Accessor for the app's single instance of the service object.
@property(nonatomic) BOOL isSignedIn;


+ (GYoutubeHelper *)getInstance;


- (NSString *)getCurrentDomainUrl;
- (void)searchByQueryWithRequestInfo:(GYoutubeRequestInfo *)info completionHandler:(YoutubeResponseBlock)handler errorHandler:(ErrorResponseBlock)handler1;

@property(nonatomic, weak) id<GYoutubeHelperDelegate> delegate;
- (void)fetchPlayListFromChannelWithRequestInfo:(GYoutubeRequestInfo *)info completionHandler:(YoutubeResponseBlock)completeBlock errorHandler:(ErrorResponseBlock)errorHandler;
- (void)fetchPlaylistItemsListWithRequestInfo:(GYoutubeRequestInfo *)info completion:(YoutubeResponseBlock)completion errorHandler:(ErrorResponseBlock)handler;


- (NSString *)getRemoteSqliteDatabase;
- (void)fetchSqliteRemoteFile:(void (^)(NSURLResponse *, NSURL *, NSError *))downloadCompletionBlock;
@end
