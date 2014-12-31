//
//  EasySpendLogDB.m
//  Easy Spend Log
//
//  Created by Aaron Bratcher on 04/25/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <media_sqlite_manager/MobileDB.h>
#import "MobileDB.h"
#import "ABSQLiteDB.h"
#import "ABProjectFileInfo.h"
#import "ABProjectType.h"

static NSString * const dataBaseName = @"VideoTrainingDB.db";

static MobileDB * _dbInstance;


@interface MobileDB ()

@end


@implementation MobileDB {
   id<ABDatabase> db;
}


#pragma mark - Base


- (id)init {
   return [self initWithFile:NULL];
}


- (id)initWithFile:(NSString *)filePathName {
   if (!(self = [super init])) return nil;

   _dbInstance = self;

   BOOL myPathIsDir;
   BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePathName isDirectory:&myPathIsDir];

   // backupDbPath allows for a pre-made database to be in the app. Good for testing
   NSString * backupDbPath = [[NSBundle mainBundle] pathForResource:@"Mobile" ofType:@"db"];

   BOOL copiedBackupDb = NO;
   if (backupDbPath != nil) {
      copiedBackupDb = [[NSFileManager defaultManager]
       copyItemAtPath:backupDbPath
               toPath:filePathName
                error:nil];
   }

   // open SQLite db file
   db = [[ABSQLiteDB alloc] init];

   if (![db connect:filePathName]) {
      return nil;
   }

   if (!fileExists) {
      if (!backupDbPath || !copiedBackupDb)
         [self makeDB];
   }

   [self checkSchema]; // always check schema because updates are done here

   return self;
}


+ (MobileDB *)dbInstance {
   NSArray * searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
   NSString * path = searchPaths[0];

   return [MobileDB dbInstance:path];
}


+ (MobileDB *)dbInstance:(NSString *)path {
   if (!_dbInstance) {
      NSString * dbFilePath = [path stringByAppendingPathComponent:dataBaseName];
      MobileDB * mobileDB = [[MobileDB alloc] initWithFile:dbFilePath];
   }

   return _dbInstance;
}


+ (BOOL)checkSqliteFileExist:(NSString *)path {
//"/Volumes/Home/djzhang/Library/Developer/CoreSimulator/Devices/F1B2461C-89B4-48A5-93D7-64546C39189E/data/Containers/Data/Application/9B95F76F-B072-4F20-B5EC-8E82B913289C/Library/Caches/VideoTrainingDB.db"
   BOOL myPathIsDir;
   BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&myPathIsDir];

   return fileExists;
}


- (void)close {
   [db close];
}


#pragma mark - ABProjectType


- (void)saveProjectType:(ABProjectType *)projectType {
   NSString * sql;
   BOOL exists = NO;

   //select projectTypeName from ProjectType where projectTypeName ='@Muse'
   sql = [NSString stringWithFormat:@"select projectTypeName from ProjectType where projectTypeName ='%@'",
                                    projectType.projectTypeName];
   id<ABRecordset> results = [db sqlSelect:sql];
   if (![results eof])
      exists = YES;

   if (exists) {
      NSString * sqlStringSerializationForUpdate = [projectType sqlStringSerializationForUpdate];

      sql = [NSString stringWithFormat:
       @"update ProjectType set %@ where projectTypeID = %i",
       sqlStringSerializationForUpdate,
       projectType.projectTypeID];
   } else {
      NSArray * sqlStringSerializationForInsert = [projectType sqlStringSerializationForInsert];

      sql = [NSString stringWithFormat:
       @"insert into ProjectType(projectTypeID,%@) values(%i,%@)",
       sqlStringSerializationForInsert[0],
       projectType.projectTypeID,
       sqlStringSerializationForInsert[1]
      ];
   }

   [db sqlExecute:sql];

   [self saveProjectTypeNamesArray:projectType.projectTypeID withArray:projectType.ProjectNameArray];
}


- (void)saveProjectTypeNamesArray:(int)projectTypeID withArray:(NSMutableArray *)mutableArray {
   NSString * sql;
   if ([mutableArray count] > 0) {
      for (ABProjectName * projectName in mutableArray) {
         sql = [NSString stringWithFormat:@"select projectNameID from ProjectTypeNames where projectTypeID = %i and projectNameID = %i",
                                          projectTypeID,
                                          projectName.projectNameID];
         id<ABRecordset> results = [db sqlSelect:sql];

         if ([results eof]) {
            sql = [NSString stringWithFormat:@"insert into ProjectTypeNames(projectTypeID,projectNameID) values(%i,%i);",
                                             projectTypeID,
                                             projectName.projectNameID];
            [db sqlExecute:sql];
         }
      }
   }
}


- (void)readProjectTypeNames:(int)projectTypeID withArray:(NSMutableArray *)mutableArray isReadArray:(BOOL)isReadArray {
   NSString * sql;
   sql = [NSString stringWithFormat:@"select projectNameID from ProjectTypeNames where projectTypeID = '%i'",
                                    projectTypeID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      int projectNameID = [[results fieldWithName:@"projectNameID"] intValue];

      LocationResultsBlock locationsBlock = ^(NSArray * locations) {
          if (locations.count > 0) {
             ABProjectName * projectName = locations[0];
             [mutableArray addObject:projectName];

             if (isReadArray)
                [self readProjectNameLists:projectName.projectNameID
                                 withArray:projectName.projectLists
                               isReadArray:YES];
          }
      };
      [self readProjectNameListWithResults:locationsBlock withprojectNameID:projectNameID];

      [results moveNext];
   }

}


- (void)readProjectTypeListWithResults:(LocationResultsBlock)locationsBlock {
   NSMutableArray * projectTypeArray = [[NSMutableArray alloc] init];
   NSString * sql = @"select * from ProjectType";

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      int projectTypeID = [[results fieldWithName:@"projectTypeID"] intValue];
      NSString * projectTypeName = [[results fieldWithName:@"projectTypeName"] stringValue];

      [projectTypeArray addObject:[[ABProjectType alloc] initWithProjectTypeID:projectTypeID
                                                               projectTypeName:projectTypeName]];

      [results moveNext];
   }

   locationsBlock(projectTypeArray);
}


#pragma mark - ABProjectName


- (void)saveProjectName:(ABProjectName *)projectName {
   NSString * sql;
   BOOL exists = NO;

   sql = [NSString stringWithFormat:@"select projectName from ProjectName where projectName = '%@'",
                                    projectName.projectName];
   id<ABRecordset> results = [db sqlSelect:sql];
   if (![results eof])
      exists = YES;

   if (exists) {
      NSString * sqlStringSerializationForUpdate = [projectName sqlStringSerializationForUpdate];

      sql = [NSString stringWithFormat:
       @"update ProjectName set %@ where projectNameID = %i",
       sqlStringSerializationForUpdate,
       projectName.projectNameID];
   } else {
      NSArray * sqlStringSerializationForInsert = [projectName sqlStringSerializationForInsert];

      sql = [NSString stringWithFormat:
       @"insert into ProjectName(projectNameID,%@) values(%i,%@)",
       sqlStringSerializationForInsert[0],
       projectName.projectNameID,
       sqlStringSerializationForInsert[1]
      ];
   }

   [db sqlExecute:sql];


   [self saveProjectNameListsArray:projectName.projectNameID withArray:projectName.projectLists];
}


- (void)saveProjectNameListsArray:(int)projectNameID withArray:(NSMutableArray *)mutableArray {
   NSString * sql;
   if ([mutableArray count] > 0) {
      for (ABProjectList * projectList in mutableArray) {
         sql = [NSString stringWithFormat:@"select projectListID from ProjectNameLists where projectNameID = %i and projectListID = %i",
                                          projectNameID,
                                          projectList.projectListID];
         id<ABRecordset> results = [db sqlSelect:sql];

         if ([results eof]) {
            sql = [NSString stringWithFormat:@"insert into ProjectNameLists(projectNameID,projectListID) values(%i,%i);",
                                             projectNameID,
                                             projectList.projectListID];
            [db sqlExecute:sql];
         }
      }
   }
}


- (void)readProjectNameLists:(int)projectNameID withArray:(NSMutableArray *)mutableArray isReadArray:(BOOL)isReadArray {
   NSString * sql;
   sql = [NSString stringWithFormat:@"select projectListID from ProjectNameLists where projectNameID = '%i'",
                                    projectNameID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      int projectListID = [[results fieldWithName:@"projectListID"] intValue];

      LocationResultsBlock locationsBlock = ^(NSArray * locations) {
          if (locations.count > 0) {
             ABProjectList * projectList = locations[0];
             [mutableArray addObject:projectList];

             if (isReadArray)
                [self readProjectListFileInfos:projectList.projectListID withArray:projectList.projectFileInfos];
          }
      };
      [self readProjectListsWithResults:locationsBlock withProjectListID:projectListID];

      [results moveNext];
   }

}


- (void)readProjectNameListWithResults:(LocationResultsBlock)locationsBlock withprojectNameID:(int)projectNameID {
   NSMutableArray * projectNameArray = [[NSMutableArray alloc] init];
   NSString * sql;

   sql = [NSString stringWithFormat:@"select * from ProjectName where projectNameID = '%i'",
                                    projectNameID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      ABProjectName * projectName = [[ABProjectName alloc] init];

      projectName.projectNameID = [[results fieldWithName:@"projectNameID"] intValue];
      projectName.projectName = [[results fieldWithName:@"projectName"] stringValue];
      projectName.projectDownloadUrl = [[results fieldWithName:@"projectDownloadUrl"] stringValue];
      projectName.projectAbstractPath = [[results fieldWithName:@"projectAbstractPath"] stringValue];

      [projectNameArray addObject:projectName];

      [results moveNext];
   }

   locationsBlock(projectNameArray);
}


#pragma mark - ABProjectList


- (void)saveProjectList:(ABProjectList *)projectList {
   NSString * sql;
   BOOL exists = NO;

   sql = [NSString stringWithFormat:@"select projectListID from ProjectList where projectListID = %i",
                                    projectList.projectListID];
   id<ABRecordset> results = [db sqlSelect:sql];
   if (![results eof])
      exists = YES;

   if (exists) {
      NSString * sqlStringSerializationForUpdate = [projectList sqlStringSerializationForUpdate];

      sql = [NSString stringWithFormat:
       @"update ProjectList set %@ where projectListID = %i",
       sqlStringSerializationForUpdate,
       projectList.projectListID];
   } else {
      NSArray * sqlStringSerializationForInsert = [projectList sqlStringSerializationForInsert];

      sql = [NSString stringWithFormat:
       @"insert into ProjectList(projectListID,%@) values(%i,%@)",
       sqlStringSerializationForInsert[0],
       projectList.projectListID,
       sqlStringSerializationForInsert[1]
      ];
   }

   [db sqlExecute:sql];


   [self saveProjectListFileInfosArray:projectList.projectListID withArray:projectList.projectFileInfos];
}


- (void)saveProjectListFileInfosArray:(int)projectListID withArray:(NSMutableArray *)mutableArray {
   NSString * sql;
   if ([mutableArray count] > 0) {
      for (ABProjectFileInfo * projectFileInfo in mutableArray) {
         sql = [NSString stringWithFormat:@"select fileInfoID from ProjectListFileInfos where projectListID = %i and fileInfoID = %i",
                                          projectListID,
                                          projectFileInfo.fileInfoID];
         id<ABRecordset> results = [db sqlSelect:sql];

         if ([results eof]) {
            sql = [NSString stringWithFormat:@"insert into ProjectListFileInfos(projectListID,fileInfoID) values(%i,%i);",
                                             projectListID,
                                             projectFileInfo.fileInfoID];
            [db sqlExecute:sql];
         }
      }
   }
}


- (void)readProjectListFileInfos:(int)projectListID withArray:(NSMutableArray *)mutableArray {
   NSString * sql;
   sql = [NSString stringWithFormat:@"select fileInfoID from ProjectListFileInfos where projectListID = '%i'",
                                    projectListID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      int fileInfoID = [[results fieldWithName:@"fileInfoID"] intValue];

      LocationResultsBlock locationsBlock = ^(NSArray * locations) {
          if (locations.count > 0) {
             ABProjectFileInfo * projectFileInfo = locations[0];
             [mutableArray addObject:projectFileInfo];
          }
      };
      [self readProjectFileInfoListWithResults:locationsBlock withFileInfoID:fileInfoID];

      [results moveNext];
   }
}


- (void)readProjectListsWithResults:(LocationResultsBlock)locationsBlock withProjectListID:(int)projectListID {
   NSMutableArray * projectNameArray = [[NSMutableArray alloc] init];

   NSString * sql = [NSString stringWithFormat:@"select * from ProjectList where projectListID = %i",
                                               projectListID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      ABProjectList * projectName = [[ABProjectList alloc] init];

      projectName.projectListID = [[results fieldWithName:@"projectListID"] intValue];
      projectName.projectListName = [[results fieldWithName:@"projectListName"] stringValue];

      [projectNameArray addObject:projectName];

      [results moveNext];
   }

   locationsBlock(projectNameArray);
}


#pragma mark - ABProjectFileInfo


- (void)saveProjectFileInfo:(ABProjectFileInfo *)fileInfo {
   NSString * sql;
   BOOL exists = NO;

   sql = [NSString stringWithFormat:@"select fileInfoID from ProjectFileInfo where fileInfoID = %i",
                                    fileInfo.fileInfoID];
   id<ABRecordset> results = [db sqlSelect:sql];
   if (![results eof])
      exists = YES;

   if (exists) {
      NSString * sqlStringSerializationForUpdate = [fileInfo sqlStringSerializationForUpdate];

      sql = [NSString stringWithFormat:
       @"update ProjectFileInfo set %@ where fileInfoID = %i",
       sqlStringSerializationForUpdate,
       fileInfo.fileInfoID];
   } else {
      NSArray * sqlStringSerializationForInsert = [fileInfo sqlStringSerializationForInsert];

      sql = [NSString stringWithFormat:
       @"insert into ProjectFileInfo(fileInfoID,%@) values(%i,%@)",
       sqlStringSerializationForInsert[0],
       fileInfo.fileInfoID,
       sqlStringSerializationForInsert[1]
      ];
   }

   [db sqlExecute:sql];
}


- (void)readProjectFileInfoListWithResults:(LocationResultsBlock)locationsBlock withFileInfoID:(int)fileInfoID {
   NSMutableArray * projectNameArray = [[NSMutableArray alloc] init];
   NSString * sql = [NSString stringWithFormat:@"select * from ProjectFileInfo where fileInfoID=%i", fileInfoID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      ABProjectFileInfo * projectName = [[ABProjectFileInfo alloc] init];

      projectName.fileInfoID = [[results fieldWithName:@"fileInfoID"] intValue];
      projectName.fileInforName = [[results fieldWithName:@"fileInforName"] stringValue];
      projectName.subtitleName = [[results fieldWithName:@"subtitleName"] stringValue];
      projectName.abstractFilePath = [[results fieldWithName:@"abstractFilePath"] stringValue];

      [projectNameArray addObject:projectName];

      [results moveNext];
   }

   locationsBlock(projectNameArray);
}


- (void)readFileInfoAbstractPath:(LocationResultsBlock)locationsBlock withFileInfoID:(int)fileInfoID {
   NSMutableArray * projectNameArray = [[NSMutableArray alloc] init];
   NSString * sql = [NSString stringWithFormat:@"select abstractFilePath from ProjectFileInfo where fileInfoID=%i",
                                               fileInfoID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      ABProjectFileInfo * projectName = [[ABProjectFileInfo alloc] init];

      projectName.abstractFilePath = [[results fieldWithName:@"abstractFilePath"] stringValue];

      [projectNameArray addObject:projectName];

      [results moveNext];
   }

   locationsBlock(projectNameArray);
}


#pragma mark - Preferences


- (NSString *)preferenceForKey:(NSString *)key {
   NSString * preferenceValue = @"";

   NSString * sql = [NSString stringWithFormat:@"select value from preferences where property='%@';", key];

   id<ABRecordset> results;
   results = [db sqlSelect:sql];

   if (![results eof]) {
      preferenceValue = [[results fieldWithName:@"value"] stringValue];
   }

   return preferenceValue;
}


- (void)setPreference:(NSString *)value forKey:(NSString *)key {
   if (!value) {
      return;
   }

   NSString * sql = [NSString stringWithFormat:@"select value from preferences where property='%@';", key];

   id<ABRecordset> results;
   results = [db sqlSelect:sql];
   if ([results eof]) {
      sql = [NSString stringWithFormat:@"insert into preferences(property,value) values('%@','%@');",
                                       key,
                                       [self escapeText:value]];
   }
   else {
      sql = [NSString stringWithFormat:@"update preferences set value = '%@' where property = '%@';",
                                       [self escapeText:value],
                                       key];
   }

   [db sqlExecute:sql];
}


#pragma mark - Utilities


- (void)makeDB {
   // ProjectType
   [db sqlExecute:@"create table ProjectType(projectTypeID int, projectTypeName text, primary key(projectTypeID));"];
   [db sqlExecute:@"create table ProjectTypeNames(projectTypeID int, projectNameID int, primary key (projectTypeID,projectNameID));"];

   // ProjectName+ProjectList
   [db sqlExecute:@"create table ProjectName(projectNameID int, projectName text, projectDownloadUrl text, projectAbstractPath text, primary key(projectNameID));"];
   [db sqlExecute:@"create table ProjectList(projectListID int, projectListName text, primary key(projectListID));"];
   [db sqlExecute:@"create table ProjectNameLists(projectNameID int, projectListID int, primary key (projectNameID,projectListID));"];

   // ProjectFileInfo+ProjectList
   [db sqlExecute:@"create table ProjectFileInfo(fileInfoID int, fileInforName text, subtitleName text, abstractFilePath text, primary key(fileInfoID));"];
   [db sqlExecute:@"create table ProjectListFileInfos(projectListID int, fileInfoID int, primary key (projectListID,fileInfoID));"];

   // Internal
   [db sqlExecute:@"create table Preferences(property text, value text, primary key(property));"];

   [self setPreference:@"1" forKey:@"SchemaVersion"];
}


- (void)checkSchema {
   NSString * schemaVersion = [self preferenceForKey:@"SchemaVersion"];

   if ([schemaVersion isEqualToString:@"1"]) {
      // ProjectType
      [db sqlExecute:@"create index idx_projecttypes_projecttypeid on ProjectType(projectTypeID);"];
      [db sqlExecute:@"create index idx_projecttypenames_projectnameid on ProjectTypeNames(projectNameID);"];// one->multiple

      // ProjectName+ProjectList
      [db sqlExecute:@"create index idx_projectnames_projectnameid on ProjectName(projectNameID);"];
      [db sqlExecute:@"create index idx_projectlists_projectlistid on ProjectList(projectListID);"];
      [db sqlExecute:@"create index idx_projectnamelists_projectnameid on ProjectNameLists(projectNameID);"];// one->multiple

      // ProjectFileInfo+ProjectList
      [db sqlExecute:@"create index idx_projectfileinfos_fileinfoid on ProjectFileInfo(fileInfoID);"];
      [db sqlExecute:@"create index idx_projectlistfileinfos_fileinfoid on ProjectListFileInfos(fileInfoID);"];// one->multiple

      schemaVersion = @"2";
   }

   [db sqlExecute:@"ANALYZE"];

   [self setPreference:schemaVersion forKey:@"SchemaVersion"];
}


+ (NSString *)uniqueID {
   CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
   NSString * uuidString = (__bridge_transfer NSString *) CFUUIDCreateString(kCFAllocatorDefault, uuid);
   CFRelease(uuid);

   return uuidString;
}


- (NSString *)escapeText:(NSString *)text {
   NSString * newValue = [text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
   return newValue;
}


- (void)saveForProjectTypeDictionary:(NSMutableDictionary *)dictionary withName:(NSString *)onlineTypeName {
   NSArray * allKeys = dictionary.allKeys;

   // step01: save ABProjectType 
   for (NSString * key in allKeys) {
      ABProjectType * projectType = [dictionary objectForKey:key];
      [self saveProjectType:projectType];

      // step02: save ABProjectName
      NSMutableArray * projectNameArray = projectType.ProjectNameArray;
      for (ABProjectName * projectName in projectNameArray) {
         [self saveProjectName:projectName];

         // step03: save ABProjectList
         NSMutableArray * projectLists = projectName.projectLists;
         for (ABProjectList * projectList in projectLists) {
            [self saveProjectList:projectList];


            // step04: save ABProjectFileInfo
            NSMutableArray * projectLists = projectList.projectFileInfos;
            for (ABProjectFileInfo * projectFileInfo in projectLists) {
               [self saveProjectFileInfo:projectFileInfo];
            }
         }
      }
   }
}


- (NSMutableDictionary *)readDictionaryForProjectType {
   NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];

   LocationResultsBlock LocationResultsBlock = ^(NSArray * locations) {
       for (ABProjectType * projectType in locations) {
          [dictionary setObject:projectType forKey:projectType.projectTypeName];

          [self readProjectTypeNames:projectType.projectTypeID withArray:projectType.ProjectNameArray isReadArray:NO];
       }
   };
   [self readProjectTypeListWithResults:LocationResultsBlock];

   return dictionary;
}

@end
