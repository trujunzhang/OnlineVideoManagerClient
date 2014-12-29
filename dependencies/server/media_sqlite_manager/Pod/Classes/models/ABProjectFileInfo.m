//
//  MFIReport.m
//  MobileApp
//
//  Created by Aaron Bratcher on 12/13/2012.
//  Copyright (c) 2012 Market Force. All rights reserved.
//

#import "ABProjectFileInfo.h"

#import "MobileDB.h"
#import "NSString+PJR.h"


@interface ABProjectFileInfo ()<NSCoding>

@end


@implementation ABProjectFileInfo
- (instancetype)init {
   self = [super init];
   if (self) {
      self.fileInforName = @"";
      self.subtitleName = @"";
      self.abstractFilePath = @"";

      self.fileInfoID = [MobileDB uniqueID];
   }

   return self;
}


- (instancetype)initWithFileInforName:(NSString *)fileInforName abstractFilePath:(NSString *)abstractFilePath {
   self = [self init];
   if (self) {
      self.fileInforName = fileInforName;
      self.abstractFilePath = abstractFilePath;
   }

   return self;
}


#pragma mark -
#pragma mark ABSqliteObject


- (NSMutableDictionary *)getUpdateDictionary {
   NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];

   [dictionary setObject:self.fileInforName forKey:@"fileInforName"];
   [dictionary setObject:self.subtitleName forKey:@"subtitleName"];
   [dictionary setObject:self.abstractFilePath forKey:@"abstractFilePath"];

   return dictionary;
}


- (NSMutableDictionary *)getInsertDictionary {

   return [self getUpdateDictionary];
}


- (NSString *)getOnlineVideoPlayUrl:(NSString *)domain {
   return [NSString stringWithFormat:@"%@%@", domain, [self encodeAbstractFilePath]];
}


- (NSString *)encodeAbstractFilePath {
   return [self.abstractFilePath replaceCharcter:@" " withCharcter:@"%20"];
}


- (NSString *)getFileInfoThumbnail {
   return [NSString stringWithFormat:@"%@%@.jpg", @"/.cache/thumbnail/", [self encodeAbstractFilePath]];
}
@end
