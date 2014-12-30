//
//  Search.m
//  IOSTemplate
//
//  Created by djzhang on 9/25/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import "GYoutubeHelper.h"
#import "Online_Request.h"
#import "OnlineServerInfo.h"
#import "ParseHelper.h"


static GYoutubeHelper * instance = nil;


@interface GYoutubeHelper () {

}

@end


@implementation GYoutubeHelper


#pragma mark -
#pragma mark GYoutubeHelper Static instance


+ (GYoutubeHelper *)getInstance {
   @synchronized (self) {
      if (instance == nil) {
         instance = [[self alloc] init];
      }
   }
   return (instance);
}


- (void)initOnlineClient:(void (^)(NSURLResponse *, NSURL *, NSError *))downloadCompletionBlock {
   ParseHelperResultBlock parseHelperResultBlock = ^(OnlineServerInfo * object, NSError * error) {
       if (error) {
          downloadCompletionBlock(nil, nil, error);
       } else {
          if ([self checkValidateLocalSqlite:object.version] == NO) {
             // 2.
             self.onlineServerInfo = object;
             [self fetchSqliteRemoteFile:downloadCompletionBlock];
          }
       }
   };
   // 1.
   [[ParseHelper sharedParseHelper] readOnlineVideoInfo:parseHelperResultBlock];

//   [[ParseHelper sharedParseHelper] saveOnlineVideoInfo:[OnlineServerInfo standardServerInfo]];// test
}


- (BOOL)checkValidateLocalSqlite:(NSString *)version {


   return NO;
}


- (void)fetchSqliteRemoteFile:(void (^)(NSURLResponse *, NSURL *, NSError *))downloadCompletionBlock {
   [Online_Request downloadSqliteFile:[self.onlineServerInfo getRemoteSqliteDatabase]
              downloadCompletionBlock:downloadCompletionBlock];
}


- (NSString *)getCurrentDomainUrl {
   return [self.onlineServerInfo getCurrentDomainUrl];
}


- (instancetype)init {
   self = [super init];
   if (self) {

   }

   return self;
}


@end
