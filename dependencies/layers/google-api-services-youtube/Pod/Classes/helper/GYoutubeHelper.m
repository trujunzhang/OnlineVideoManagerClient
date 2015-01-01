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
          [self.delegate showStepInfo:@"Fetching failure?"];
       } else {
          if ([self checkValidateLocalSqlite:object.version] == NO) {
             // 2.
             NSProgress * progress;
             void (^downloadCompletion)(NSURLResponse *, NSURL *, NSError *) = ^(NSURLResponse * response, NSURL * url, NSError * error) {
                 if (error) {
                    id objectForKey = [[error userInfo] objectForKey:@"NSErrorFailingURLKey"];

                    [self.delegate showStepInfo:[NSString stringWithFormat:@"Download %@ failure?",
                                                                           [[objectForKey absoluteURL] absoluteString]]];
                 } else {
                    downloadCompletionBlock(nil, nil, nil);
                 }
             };
             [self fetchSqliteRemoteFile:downloadCompletion progressBlock:&progress];

             // Observe fractionCompleted using KVO
             [progress addObserver:self
                        forKeyPath:@"fractionCompleted"
                           options:NSKeyValueObservingOptionNew
                           context:NULL];


             [self.delegate showStepInfo:@"Downloading sqlite databse!"];
          } else {
             downloadCompletionBlock(nil, nil, nil);
             [self.delegate showStepInfo:@"Cache dictionary already has sqlite file!"];
          }
       }
   };
   // 1.
   [[ParseHelper sharedParseHelper] readOnlineVideoInfo:parseHelperResultBlock];

   [self.delegate showStepInfo:@"Fetching OnlineVideoInfo frome parse.com !"];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//   [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];

   if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
      NSProgress * progress = (NSProgress *) object;
      NSLog(@"Progress is %f", progress.fractionCompleted);
   }
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


- (void)fetchSqliteRemoteFile:(void (^)(NSURLResponse *, NSURL *, NSError *))downloadCompletionBlock progressBlock:(__autoreleasing NSProgress **)progressBlock {
   [Online_Request downloadSqliteFile:[self.onlineServerInfo getRemoteSqliteDatabase]
              downloadCompletionBlock:downloadCompletionBlock
                        progressBlock:progressBlock];
}


- (NSString *)getCurrentDomainUrl {
   return [self.onlineServerInfo getCurrentDomainUrl];
}


- (NSString *)getServerCacheDirectory {
   return [self.onlineServerInfo cacheThumbmail];
}


- (instancetype)init {
   self = [super init];
   if (self) {

   }

   return self;
}


@end
