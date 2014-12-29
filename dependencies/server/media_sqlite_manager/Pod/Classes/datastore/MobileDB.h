#import <Foundation/Foundation.h>
#import <media_sqlite_manager/MobileDB.h>
#import "ABProjectName.h"
#import "ABProjectList.h"

typedef void(^ReportResultsBlock)(NSArray* reports);
typedef void(^LocationResultsBlock)(NSArray* locations);


@interface MobileDB : NSObject


#pragma mark - Base
+ (MobileDB *)dbInstance;
+ (MobileDB *)dbInstance:(NSString *)path;

- (id) initWithFile: (NSString*) filePathName;
- (void) close;


- (void)readProjectNameLists:(int)projectNameID withArray:(NSMutableArray *)mutableArray isReadArray:(BOOL)isReadArray;
#pragma mark - Locations
-(void) locationsForReport:(ABProjectList *) report Results:(LocationResultsBlock) locationsBlock;
-(void) fillDetailsForLocations:(NSArray*) locations;
-(void) saveLocation:(ABProjectName *) location;

#pragma mark - Reports
-(void) saveReport:(ABProjectList *) report;
-(void) allReports:(ReportResultsBlock) reportsBlock;
-(void) allReportsWithLocations:(ReportResultsBlock) reportsBlock;

#pragma mark - Preferences
- (void)readFileInfoAbstractPath:(LocationResultsBlock)locationsBlock withFileInfoID:(int)fileInfoID;
- (NSString*) preferenceForKey: (NSString*) key;
- (void) setPreference: (NSString*) value  forKey: (NSString*) key;

#pragma mark - Utilities
- (void)saveForProjectTypeDictionary:(NSMutableDictionary *)dictionary;
- (NSMutableDictionary *)readDictionaryForProjectType;
+(NSString *)uniqueID;

@end


