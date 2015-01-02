#import <Foundation/Foundation.h>
#import "ABProjectName.h"
@class ABProjectFileInfo;


@interface ABProjectList : ABSqliteObject<MKAnnotation>

@property(assign) int projectListID;
@property(strong) NSMutableArray * projectFileInfos;

@property(copy) NSString * projectListName;
- (instancetype)initWithProjectListName:(NSString *)projectListName;


+ (ABProjectList *)reportFromJSON:(NSString *)json;
+ (NSArray *)reportsFromJSON:(NSString *)json;
- (NSString *)JSONValue;

- (void)appendFileInfo:(id)fileInfo;
- (ABProjectFileInfo *)getFirstABProjectFileInfo;

@end
