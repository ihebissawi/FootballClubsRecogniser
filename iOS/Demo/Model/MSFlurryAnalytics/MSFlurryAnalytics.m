//
//  MSFlurryAnalytics.m
//  FlagRecognition
//
//  Created by Michael Murnik on 12/18/14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import "MSFlurryAnalytics.h"

NSString *const kFlurryScreenTeams = @"show TeamsScreen";
NSString *const kFlurryScreenLeagues = @"show LeaguesScreen";
NSString *const kFlurryScreenPlayers = @"show PlayerScreen";
NSString *const kFlurryScreenTeamDetails = @"show TeamDetailsScreen";
NSString *const kFlurryScreenLeagueDetails = @"show LegueDetailsScreen";
NSString *const kFlurryScreenPlayerDetails = @"show PlayerDetailsScreen";
NSString *const kFlurryScreenStartRecognition = @"start Recognition";
NSString *const kFlurryScreenSuccessRecognition = @"success Recognition";
@implementation MSFlurryAnalytics
+(void)sendScreenName:(NSString *)name
{
    [Flurry logEvent:name];
}


+(void)sendScreenName:(NSString *)name withParameters:(NSDictionary*) params
{
    [Flurry logEvent:name withParameters:params];
}

@end
