#import "MSPerishableEntity.h"


@interface MSPerishableEntity ()

// Private interface goes here.

@end


@implementation MSPerishableEntity

#pragma mark - public

- (void)cacheImage:(UIImage *)image withImageName:(NSString *)imageName {
    NSLog(@"Caching image");
    
    imageName = [imageName stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString * pathToWrite = [NSString stringWithFormat:@"%@.png",[self pathToCacheForFile:imageName]];
    
    if ([[NSFileManager defaultManager] createFileAtPath:pathToWrite contents:nil attributes:nil]) {
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:pathToWrite atomically:YES];
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageFilePath = pathToWrite;
            [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
        });
        NSLog(@"Image cached and saved");
    }
}

#pragma mark - private

+ (id) MR_importFromObject:(id)objectData inContext:(NSManagedObjectContext *)context {
    MSPerishableEntity *newEntity = [super MR_importFromObject:objectData inContext:context];
    
    newEntity.lastUpdateDate = [NSDate date];
    
    return newEntity;
}


- (BOOL)isFileExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (NSString *)pathToCacheForFile:(NSString *)name {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * folderPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Images"];
    
    if (![self isFileExistsAtPath:folderPath]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:&error];
    }
    
    NSString * imagePath = [folderPath stringByAppendingPathComponent:name];
    return imagePath;
}




@end
