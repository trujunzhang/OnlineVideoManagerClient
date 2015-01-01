//
// Created by djzhang on 12/27/14.
//

#import <Foundation/Foundation.h>


@interface OnlineVideoProjectStatisticsHelper : NSObject
@property(nonatomic, strong) NSString * onlinePath;
@property(nonatomic, copy) NSString * cacheDirectory;

- (instancetype)initWithOnlinePath:(NSString *)onlinePath withCacheDirectory:(NSString *)cacheDirectory;

- (void)makeProjectList:(NSString *)aPath withFullPath:(NSString *)fullPath to:(id)projectType;
@end