//
// Created by djzhang on 12/27/14.
//

#import "OnlineVideoProjectListHelper.h"
#import "ABProjectType.h"
#import "ABProjectName.h"
#import "ABProjectList.h"
#import "ABProjectFileInfo.h"
#import "NSString+PJR.h"
#import "MobileBaseDatabase.h"
#import "GenerateThumbnailTask.h"


@implementation OnlineVideoProjectListHelper {

}
- (instancetype)initWithOnlinePath:(NSString *)onlinePath withCacheDirectory:(NSString *)cacheDirectory {
   self = [super init];
   if (self) {
      self.onlinePath = onlinePath;
      self.cacheDirectory = cacheDirectory;
   }

   return self;
}


- (void)makeProjectList:(NSString *)aPath withFullPath:(NSString *)fullPath to:(ABProjectType *)projectType {
   ABProjectName * projectName = [[ABProjectName alloc] initWithProjectName:aPath];
   [projectType appendProjectName:projectName];
   [self analysisProjectList:fullPath to:projectName];
}


- (void)analysisProjectList:(NSString *)appDocDir to:(ABProjectName *)projectName {
   NSArray * contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appDocDir error:NULL];
   for (NSString * aPath in contentOfFolder) {
      NSString * fullPath = [appDocDir stringByAppendingPathComponent:aPath];
      BOOL isDir = NO;
      if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]) {
         if (isDir == YES) {
            ABProjectList * projectList = [[ABProjectList alloc] initWithProjectListName:aPath];
            [projectName appendProjectList:projectList];
            [self analysisProjectNames:fullPath to:projectList];
         }
      }
   }
}


- (void)analysisProjectNames:(NSString *)appDocDir to:(ABProjectList *)projectList {
   NSArray * contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appDocDir error:NULL];
   for (NSString * aPath in contentOfFolder) {
      NSString * fullPath = [appDocDir stringByAppendingPathComponent:aPath];
      BOOL isDir = NO;
      if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]) {
         if (isDir == YES) {
         } else {
            if ([self checkIsMovieFile:aPath]) {
               //"/Volumes/macshare/MacPE/Lynda.com/Adobe.com/@Muse/#Muse Essential Training by Justin Seeley/0. Introduction"
               //"01-Welcome.mp4"
               // /Volumes/macshare/MacPE/Lynda.com/Adobe.com/@Muse/#Muse Essential Training by Justin Seeley/0. Introduction/01-Welcome.mp4
               // /Volumes/macshare/MacPE/Lynda.com/Adobe.com/@Muse/#Muse Essential Training by Justin Seeley/0. Introduction/01-Welcome.mp4

               NSString * fileAbstractPath = [self getFileAbstractPath:appDocDir withPath:aPath];
               //"/Adobe.com/@Muse/#Muse Essential Training by Justin Seeley/0. Introduction/01-Welcome.mp4"
               //http://192.168.1.200:8040/Adobe.com/@Muse/#Muse Essential Training by Justin Seeley/0. Introduction/01-Welcome.mp4
               //http://192.168.1.200:8040/Adobe.com/01-Welcome.mp4
               //http://192.168.1.200:8040/Adobe.com/@Muse/#Muse Essential Training by Justin Seeley/01-Welcome.mp4

               ABProjectFileInfo * projectFileInfo = [[ABProjectFileInfo alloc] initWithFileInforName:aPath
                                                                                     abstractFilePath:fileAbstractPath];
//               NSLog(@"http://192.168.1.200:8040%@", fileAbstractPath);
               [projectList appendFileInfo:projectFileInfo];

               [self generateThumbnail:projectFileInfo.fileInfoID
                               forFile:[NSString stringWithFormat:@"%@/%@", appDocDir, aPath]];
            }
         }
      }
   }
}


- (void)generateThumbnail:(int)fileInfoID forFile:(NSString *)fileAbstractPath {
   NSString * thumbnailName = [MobileBaseDatabase getThumbnailName:fileInfoID];

   NSString * thumbnailCacheDirectory = [NSString stringWithFormat:@"%@/%@", self.cacheDirectory, thumbnailFolder];
//   [GenerateThumbnailTask appendGenerateThumbnailTask:thumbnailName in:fileAbstractPath to:thumbnailCacheDirectory];
}


- (NSString *)getFileAbstractPath:(NSString *)appDocDir withPath:(NSString *)aPath {
   NSString * string = [NSString stringWithFormat:@"%@/%@", appDocDir, aPath];
   return [string replaceCharcter:self.onlinePath withCharcter:@""];
}


- (BOOL)checkIsMovieFile:(NSString *)path {
   NSArray * movieSupportedType = @[ @".mp4", @".mov" ];

   for (NSString * type in movieSupportedType) {
      if ([path containsString:type]) {
         return YES;
      }
   }

   return NO;
}


@end