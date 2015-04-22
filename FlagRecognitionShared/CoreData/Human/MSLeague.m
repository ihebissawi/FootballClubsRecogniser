#import "MSLeague.h"


@interface MSLeague ()

// Private interface goes here.

@end


@implementation MSLeague

// Custom logic goes here.

- (UIImage *)leagueImage {
    return [UIImage imageNamed:[NSString stringWithFormat:@"leagueLogo_%@", self.iD]];
}

@end
