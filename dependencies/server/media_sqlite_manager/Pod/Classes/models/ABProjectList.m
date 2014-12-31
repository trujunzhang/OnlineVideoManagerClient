//
//  MFIReport.m
//  MobileApp
//
//  Created by Aaron Bratcher on 12/13/2012.
//  Copyright (c) 2012 Market Force. All rights reserved.
//

#import "ABProjectList.h"

#import "ABProjectFileInfo.h"
#import "MobileDB.h"


@interface ABProjectList ()<NSCoding>

@end


@implementation ABProjectList
- (instancetype)init {
   self = [super init];
   if (self) {
      self.projectListID = [MobileDB uniqueID];

      self.projectListName = @"";
      self.projectFileInfos = [[NSMutableArray alloc] init];
   }

   return self;
}


- (instancetype)initWithProjectListName:(NSString *)projectListName {
   self = [self init];
   if (self) {
      self.projectListName = projectListName;
   }

   return self;
}


- (BOOL)isEqual:(id)object {
   ABProjectList * compareReport = object;

   return self.projectListID == compareReport.projectListID;
}


#pragma mark -
#pragma mark ABSqliteObject


- (NSMutableDictionary *)getUpdateDictionary {
   NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];

   [dictionary setObject:self.projectListName forKey:@"projectListName"];

   return dictionary;
}


- (NSMutableDictionary *)getInsertDictionary {

   return [self getUpdateDictionary];
}


- (void)appendFileInfo:(ABProjectFileInfo *)fileInfo {
   [self.projectFileInfos addObject:fileInfo];
}


- (NSString *)getPlayListThumbnailGeneratedFromVideo {
   if (self.projectFileInfos.count > 0) {
      ABProjectFileInfo * firstFileInfo = self.projectFileInfos[0];

      return [firstFileInfo getCacheFileInfoThumbnail];
   }
   return @"";
}


@end
