//
//  DMEThumnailer.m
//

#import "VideohumbnailerHelper.h"


@implementation VideohumbnailerHelper

+ (instancetype)sharedInstance {
   static VideohumbnailerHelper * sharedInstance = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       sharedInstance = [[VideohumbnailerHelper alloc] init];
   });

   return sharedInstance;
}


@end