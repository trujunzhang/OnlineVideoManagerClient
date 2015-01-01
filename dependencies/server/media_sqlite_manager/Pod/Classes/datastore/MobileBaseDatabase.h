//
// Created by djzhang on 12/31/14.
//

#import <Foundation/Foundation.h>
@protocol ABDatabase;

id<ABDatabase> db;
static NSString * const dataBaseName = @"VideoTrainingDB.db";


@interface MobileBaseDatabase : NSObject {

}


+ (NSString *)uniqueID;
- (void)makeDB;
- (void)checkSchema;
+ (BOOL)checkDBFileExist:(NSString *)filePathName;
@end