#import "MSPlayerProgress.h"


@interface MSPlayerProgress ()

// Private interface goes here.

@end


@implementation MSPlayerProgress

#pragma mark - private

+ (id) MR_importFromObject:(id)objectData inContext:(NSManagedObjectContext *)context {
    MSPlayerProgress *newEntity = nil;
    if ([objectData isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *newObjectData = [objectData mutableCopy];
        NSString *idString = [NSString stringWithFormat:@"%@.%@.%@",//player_id.season_id.team_id - format of id
                              [newObjectData valueForKey:@"player_id"],
                              [newObjectData valueForKey:@"season_id"],
                              [newObjectData valueForKey:@"team_id"]];
        [newObjectData setValue:idString forKey:@"id"];
        newEntity = [super MR_importFromObject:newObjectData inContext:context];
    } else {
        NSLog(@"Wrong data for MSPlayerProgress import: %@", objectData);
    }
    
    
    return newEntity;
}

@end
