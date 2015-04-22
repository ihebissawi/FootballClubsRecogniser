//
//  MSFlurryAnalytics.h
//  FlagRecognition
//
//  Created by Michael Murnik on 12/18/14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flurry.h>

extern NSString *const kFlurryScreenTeams;
extern NSString *const kFlurryScreenLeagues;
extern NSString *const kFlurryScreenPlayers;
extern NSString *const kFlurryScreenTeamDetails;
extern NSString *const kFlurryScreenLeagueDetails;
extern NSString *const kFlurryScreenPlayerDetails;
extern NSString *const kFlurryScreenStartRecognition;
extern NSString *const kFlurryScreenSuccessRecognition;

@interface MSFlurryAnalytics : NSObject
+ (void)sendScreenName:(NSString *)name;
+(void)sendScreenName:(NSString *)name withParameters:(NSDictionary*) params;
@end
