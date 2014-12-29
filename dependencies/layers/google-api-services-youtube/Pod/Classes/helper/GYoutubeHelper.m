//
//  Search.m
//  IOSTemplate
//
//  Created by djzhang on 9/25/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import "GYoutubeHelper.h"
#import "Online_Request.h"


static GYoutubeHelper * instance = nil;


@interface GYoutubeHelper () {

}
@property(nonatomic, strong) NSString * domainUrl;
@end


@implementation GYoutubeHelper

#pragma mark -
#pragma mark Global YTServiceYouTube instance


#pragma mark -
#pragma mark GYoutubeHelper Static instance


+ (GYoutubeHelper *)getInstance {
   @synchronized (self) {
      if (instance == nil) {
         instance = [[self alloc] init];
//         instance.domainUrl = @"http://192.168.1.200:8040";
         instance.domainUrl = @"http://192.168.1.103:8040";
      }
   }
   return (instance);
}


- (void)fetchSqliteRemoteFile {
   void (^downloadCompletionBlock)(NSURLResponse *, NSURL *, NSError *) = ^(NSURLResponse * response, NSURL * url, NSError * error) {
       NSString * debug = @"debug";
   };
   [Online_Request downloadSqliteFile:[self getRemoteSqliteDatabase] downloadCompletionBlock:downloadCompletionBlock];
}


- (NSString *)getCurrentDomainUrl {
   return self.domainUrl;
}


- (instancetype)init {
   self = [super init];
   if (self) {

   }

   return self;
}


- (NSString *)getRemoteSqliteDatabase {
   return [NSString stringWithFormat:@"%@/%@/%@", self.domainUrl, @".cache", @"VideoTrainingDB.db"];
}
@end
