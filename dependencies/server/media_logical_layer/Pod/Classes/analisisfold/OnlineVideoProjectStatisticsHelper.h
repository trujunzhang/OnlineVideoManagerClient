//
// Created by djzhang on 12/27/14.
//

#import <Foundation/Foundation.h>


@interface OnlineVideoProjectStatisticsHelper : NSObject
@property(nonatomic, strong) NSString * onlinePath;

- (instancetype)initWithOnlinePath:(NSString *)onlinePath;


- (void)makeProjectList:(NSString *)aPath withFullPath:(NSString *)fullPath to:(id)projectType;
@end