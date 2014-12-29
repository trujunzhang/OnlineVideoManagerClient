#import "ABProjectType.h"
#import "MobileDB.h"


@interface ABProjectType ()<NSCoding>

@end


@implementation ABProjectType

#define DEG2RAD(degrees) (degrees * 0.01745327) // degrees * pi over 180


- (instancetype)init {
   self = [super init];
   if (self) {
      self.ProjectNameArray = [[NSMutableArray alloc] init];
   }

   return self;
}


- (instancetype)initWithProjectTypeID:(int)projectTypeID projectTypeName:(NSString *)projectTypeName {
   self = [self init];
   if (self) {
      self.projectTypeID = projectTypeID;
      self.projectTypeName = projectTypeName;
   }

   return self;
}


- (instancetype)initWithProjectType:(NSString *)projectName {
   self = [self init];
   if (self) {
      self.projectTypeID = [MobileDB uniqueID];
      self.projectTypeName = projectName;
   }

   return self;
}


- (BOOL)isEqual:(id)object {
   ABProjectType * compareLocation = object;

   return self.projectTypeID == compareLocation.projectTypeID;
}


#pragma mark - 
#pragma mark ABSqliteObject


- (NSMutableDictionary *)getUpdateDictionary {
   NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
   [dictionary setObject:self.projectTypeName forKey:@"projectTypeName"];

   return dictionary;
}


- (NSMutableDictionary *)getInsertDictionary {

   return [self getUpdateDictionary];
}


- (void)appendProjectName:(ABProjectName *)projectName {
   [self.ProjectNameArray addObject:projectName];
}


+ (NSMutableDictionary *)getAllProjectNames:(NSMutableDictionary *)projectTypesDictionary {
   NSMutableDictionary * projectNamesDictionary = [[NSMutableDictionary alloc] init];

   for (ABProjectType * projectType in projectTypesDictionary.allValues) {
      NSString * projectTypeName = projectType.projectTypeName;

      for (ABProjectName * abProjectName in projectType.ProjectNameArray) {
         NSString * projectName = abProjectName.projectName;

         [projectNamesDictionary setObject:projectName forKey:projectTypeName];
      }
   }

   return projectNamesDictionary;
}

@end
