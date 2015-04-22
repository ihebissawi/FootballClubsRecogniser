#import "MSTeam.h"
#import "MSPlayer.h"

#define kMSTeamDefaultLogoName @"goodBallLogo.png"

@interface MSTeam ()

// Private interface goes here.

@end


@implementation MSTeam

// Custom logic goes here.

#pragma mark - public

- (NSString *)shortNameOrName {
    if (self.shortName.length) {
        return self.shortName;
    }
    return self.name;
}

-(NSString *)teamColorHex
{
    if(self.teamColor)
    {
        self.teamColor = [self.teamColor substringFromIndex:[self.teamColor length]-6];
        self.teamColor = [NSString stringWithFormat:@"0x%@",self.teamColor];
    }
    return self.teamColor;
}

- (UIImage *)logoImage {
    if (self.imageFilePath) {
        return [UIImage imageWithContentsOfFile:self.imageFilePath];
    }
    if (!self.logo) {
        return [UIImage imageNamed:kMSTeamDefaultLogoName];
    }
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.logo]];
    
    if (!imageData) {
        return [UIImage imageNamed:kMSTeamDefaultLogoName];
    }
    
    UIImage *image = [UIImage imageWithData:imageData];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
        [self cacheImage:image withImageName:[self shortNameOrName]];
    });
    return image;
}


- (NSArray *)players {
    if (!self.squad.count) return nil;
    NSArray *teamPlayers = [self.squad allObjects];

    teamPlayers = [teamPlayers sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        MSPlayer *player1 = (MSPlayer *)obj1;
        MSPlayer *player2 = (MSPlayer *)obj2;
        
        //if there is no shirt number then player goes last in position group
        NSNumber *plNumber1 = (player1.shirtNumber.length) ? @([player1.shirtNumber integerValue]) : @(INT32_MAX);
        NSNumber *plNumber2 = (player2.shirtNumber.length) ? @([player2.shirtNumber integerValue]) : @(INT32_MAX);
        
        //!!!:order of if sequence is important
        //sorting by shirt number if positions are same
        if ([player1.positionNameShort isEqualToString:player2.positionNameShort]) {
            return [plNumber1 compare:plNumber2];
        }

        if ([player1.positionNameShort isEqualToString:@"G"]) { //1 == G   2 == doesn't metter
            return NSOrderedAscending;
        }
        if ([player2.positionNameShort isEqualToString:@"G"]) { //1 != G   2 == G
            return NSOrderedDescending;
        }
        if ([player1.positionNameShort isEqualToString:@"D"]) { //1 == D   2 != G
            return NSOrderedAscending;
        }
        if ([player2.positionNameShort isEqualToString:@"D"]) { //1 != G,D   2 == D
            return NSOrderedDescending;
        }
        if ([player1.positionNameShort isEqualToString:@"M"]) { //1 == M   2 != G,D
            return NSOrderedAscending;
        }
        if ([player2.positionNameShort isEqualToString:@"M"]) { //1 != G,D,M   2 == M
            return NSOrderedDescending;
        }
        if ([player1.positionNameShort isEqualToString:@"A"]) { //1 == A   2 != G,D,M
            return NSOrderedAscending;
        }
        if ([player2.positionNameShort isEqualToString:@"A"]) { //1 != G,D,M,A   2 == A
            return NSOrderedDescending;
        }
        
        return NSOrderedSame; //1 == cch  2 == cch
    }];
    
    NSMutableArray *teamPlayersMutable = [teamPlayers mutableCopy];
    [teamPlayersMutable removeLastObject];
    return teamPlayersMutable;
}

- (MSShowableData *)viewObject{
    NSAttributedString * resultString = [[NSAttributedString alloc] initWithString:self.currentLeagueName attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12.0f]}];
    return [MSShowableData objectWith:self.shortNameOrName subtitle:resultString imageUrl:self.logo checked:self.favorite.boolValue];
}

@end
