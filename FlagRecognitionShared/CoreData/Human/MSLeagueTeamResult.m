#import "MSLeagueTeamResult.h"
#import "NSManagedObject+MagicalDataImport.h"

@interface MSLeagueTeamResult ()

// Private interface goes here.

@end


@implementation MSLeagueTeamResult

// Custom logic goes here.

- (BOOL)importPosition:(id)data {
    if ([data isKindOfClass:[NSString class]] || [data isKindOfClass:[NSNumber class]]) {
        self.positionValue = (int32_t)[data integerValue];
        return YES;
    }
    return NO;
}

@end
