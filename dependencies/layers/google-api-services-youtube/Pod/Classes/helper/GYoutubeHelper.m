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
#import "ParseLocalStore.h"


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
       self.onlineServerInfo = object;

       if (error) {
          downloadCompletionBlock(nil, nil, error);
          [self.delegate showStepInfo:"Fetching failure?"];
       } else {
          if ([self checkValidateLocalSqlite:object.version] == NO) {
             // 2.
             [self fetchSqliteRemoteFile:downloadCompletionBlock];
             [self.delegate showStepInfo:"Downloading sqlite databse!"];
          } else {
             downloadCompletionBlock(nil, nil, nil);
             [self.delegate showStepInfo:"Downloaded sqlite databse failure?"];
          }
       }
   };
   // 1.
   [[ParseHelper sharedParseHelper] readOnlineVideoInfo:parseHelperResultBlock];

   [self.delegate showStepInfo:"Fetching OnlineVideoInfo!"];
}


//   [[ParseHelper sharedParseHelper] saveOnlineVideoInfo:[OnlineServerInfo standardServerInfo]];// test
- (BOOL)checkValidateLocalSqlite:(NSString *)version {
   NSString * lastVersion = [ParseLocalStore readSqliteVersion];
   [ParseLocalStore saveSqliteVersion:version];
   if ([ParseLocalStore checkLocalCacheSqliteExist] == YES) {// exist
      if ([lastVersion isEqualToString:version] == YES) { // the same
         return YES;
      }
   }


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
