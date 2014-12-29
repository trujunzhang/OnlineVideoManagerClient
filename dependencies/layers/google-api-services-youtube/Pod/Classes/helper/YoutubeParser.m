//
//  YoutubeParser.m
//  IOSTemplate
//
//  Created by djzhang on 11/15/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <google-api-services-youtube/GYoutubeHelper.h>
#import "YoutubeParser.h"
#import "ISMemoryCache.h"
#import "RXMatch.h"
#import "NSString+Regexer.h"
#import "YoutubeVideoDescriptionStringAttribute.h"
#import "NSString+PJR.h"
#import "GYoutubeHelper.h"


@interface YoutubeParser ()

@end


@implementation YoutubeParser


#pragma mark -
#pragma mark  Video cache


+ (NSString *)getVideoSnippetThumbnails:(YTYouTubeVideoCache *)video {
   return @"";
}


+ (NSString *)getWatchVideoId:(YTYouTubeVideoCache *)video {

   NSObject * domain = [[GYoutubeHelper getInstance] getCurrentDomainUrl];
   NSString * onlineVideoPlayUrl = [video getOnlineVideoPlayUrl:domain];
   return onlineVideoPlayUrl;
}


+ (NSString *)getChannelIdByVideo:(YTYouTubeVideoCache *)video {
   return @"";
}


+ (NSString *)getVideoSnippetTitle:(YTYouTubeVideoCache *)video {
   return video.fileInforName;
}


+ (NSString *)getVideoDescription:(YTYouTubeVideoCache *)video {
   return @"";
}


+ (NSString *)getVideoSnippetChannelTitle:(YTYouTubeVideoCache *)video {
   return @"";
}


+ (NSString *)getVideoSnippetChannelPublishedAt:(YTYouTubeVideoCache *)video {
   return @"";
}


+ (NSString *)getVideoThumbnailsGeneratedFromVideo:(YTYouTubeVideoCache *)fileInfo {
   NSString * playListThumbnail = [fileInfo getCacheFileInfoThumbnail];

   NSObject * domain = [[GYoutubeHelper getInstance] getCurrentDomainUrl];
   return [NSString stringWithFormat:@"%@%@", domain, playListThumbnail];
}


#pragma mark -
#pragma mark Channel for other request


+ (NSString *)getPlayListTitle:(YTYouTubePlayList *)channel {
   return channel.projectListName;
}


+ (NSString *)getPlayListThumbnailsGeneratedFromVideo:(YTYouTubePlayList *)playList {
   NSString * playListThumbnail = [playList getPlayListThumbnailGeneratedFromVideo];

   NSObject * domain = [[GYoutubeHelper getInstance] getCurrentDomainUrl];
   return [NSString stringWithFormat:@"%@%@", domain, playListThumbnail];
}


+ (NSString *)getChannelBannerImageUrl:(YTYouTubeChannel *)channel {
   return @"";
}


+ (NSArray *)getChannelBannerImageUrlArray:(YTYouTubeChannel *)channel {

   return @[
    @"",
    @"",
   ];
}


+ (NSString *)getChannelSnippetId:(YTYouTubeChannel *)channel {
   return [NSString stringWithFormat:@"%i", channel.projectNameID];
}


+ (NSString *)getChannelSnippetTitle:(YTYouTubeChannel *)channel {
   return [channel.projectName removeSubString:@"@@"];
}


+ (NSString *)getChannelSnippetThumbnail:(YTYouTubeChannel *)channel {
   return @"";
}


+ (NSString *)getChannelBrandingSettingsTitle:(YTYouTubeChannel *)channel {
   return @"";
}


+ (NSString *)getChannelStatisticsSubscriberCount:(YTYouTubeChannel *)channel {
   return @"";
}


#pragma mark -
#pragma mark Url cache


+ (void)cacheWithKey:(NSString *)key withValue:(NSString *)value {
   [[ISMemoryCache sharedCache] setObject:value forKey:key];
}


+ (NSString *)checkAndAppendThumbnailWithChannelId:(NSString *)key {
   return [[ISMemoryCache sharedCache] objectForKey:key];
}


+ (NSString *)getYoutubeTypeTitle:(YTYouTubeType *)projectType {
   return [projectType.projectTypeName removeSubString:@"@"];
}
@end
