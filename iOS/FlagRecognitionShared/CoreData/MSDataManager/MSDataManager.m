//
//  MSDataManager.m
//  FlagRecognition
//
//  Created by Lexiren on 2/11/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "MSDataManager.h"

#import "MSSettings.h"
#import "HTTPClientManager.h"

#import "MSCountry.h"
#import "MSTeam.h"
#import "MSMatch.h"
#import "MSLeague.h"
#import "MSLeagueTeamResult.h"
#import "MSPlayer.h"
#import "MSPlayerProgress.h"


#define kMSPlayersCommonListDeltaUploadCounter 50

@implementation MSDataManager

#pragma mark - init

+ (instancetype)sharedManager
{
    static MSDataManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
				  ^{
					  dataManager = [MSDataManager new];
					  [[NSNotificationCenter defaultCenter] addObserver:dataManager
															   selector:@selector(rechabilityChangedNotification:)
																   name:kHTTPClientManagerReachabilityStateChangedNotification
																 object:nil];
				  });
    return dataManager;
}

- (void)stopLoading {
    [[self.httpClient operationQueue] cancelAllOperations];
}

#pragma mark - parameters

- (MSSettings *)settings {
    return [MSSettings settings];
}

- (HTTPClientManager *)httpClient {
    return [HTTPClientManager sharedHTTPClient];
}

#pragma mark - private

- (BOOL)isValidaLastUpdateDate:(NSDate *)lastUpdateDate {
    NSTimeInterval intervalSinceUpdate = [[NSDate date] timeIntervalSinceDate:lastUpdateDate];
    return (intervalSinceUpdate < self.settings.dataExpirationTimeInterval);
}

- (BOOL)isValidDataInManagedObject:(MSPerishableEntity *)object {
    if (object) {
        return [self isValidaLastUpdateDate:object.lastUpdateDate];
    }
    return NO;
}

- (void)uploadFavoriteStatusOfTeams
{
	MSTeam *randomTeam = [MSTeam MR_findFirst];
	if ([self isValidDataInManagedObject:randomTeam])
	{
		NSArray *teams = [MSTeam MR_findByAttribute:@"synced"
										  withValue:@NO
										 andOrderBy:@"name"
										  ascending:YES];
		NSMutableArray *teamsToAdd = [NSMutableArray array];
		NSMutableArray *teamsToRemove = [NSMutableArray array];
		for (MSTeam *team in teams)
		{
			if (team.favorite)
				[teamsToAdd addObject:team];
			else
				[teamsToRemove addObject:team];
		}
		
		if (teamsToAdd.count > 0)
		{
			[self updateFavoriteStatus:YES teams:teamsToAdd comletion:
			^(BOOL success, NSError *error)
			{
				if (error != nil)
					NSLog(@"%@",error.localizedDescription);
				
				if (teamsToRemove.count > 0)
					[self updateFavoriteStatus:NO teams:teamsToRemove comletion:nil];
			}];
		}
		else if (teamsToRemove.count > 0)
			[self updateFavoriteStatus:NO teams:teamsToRemove comletion:nil];
	}
}

-(void)updateFavoriteStatus:(BOOL)status teams:(NSArray*)array comletion:(MSCompletionBlock)completion
{
	[self.httpClient updateFavoritesStatus:status
									 teams:array
								completion:
	 ^(BOOL success, NSError *error)
	 {
		 if (success)
		 {
			 for (MSTeam *team in array)
			 {
				 team.syncedValue = YES;
			 }
			 
			 [[array[0] managedObjectContext] MR_saveToPersistentStoreWithCompletion:
			  ^(BOOL success, NSError *error)
			  {
				  performCompletionBlock(completion, success, error);
			  }];
		 }
		 else
			 performCompletionBlock(completion, success, error);
	 }];
}

#pragma mark - MSTableViewController

- (void)requestSettingsCurrentCountryWithCompletion:(MSCompletionBlock)completion {
    MSCountry *country = [MSCountry MR_findFirstByAttribute:@"iD"
                                                  withValue:kMSCountryDefaultID];
    if ([self isValidDataInManagedObject:country]) {
        self.settings.currentCountry = country;
    } else {
        [self.httpClient requestCountriesWithCompletion:^(BOOL success, NSError *error, id data) {
            if (success && !error) {
                if([data isKindOfClass:[NSArray class]]) {
                    NSArray *countries = (NSArray *)data;
                    if (countries.count) {
                        self.settings.currentCountry = [countries firstObject];
                    } else {
                        success = NO;
                        NSDictionary *details = [NSMutableDictionary dictionary];
                        [details setValue:@"Wrong number of available countries in response" forKey:NSLocalizedDescriptionKey];
                        error = [NSError errorWithDomain:@"Server error" code:200 userInfo:details];
                    }
                } else {
                    success = NO;
                    NSDictionary *details = [NSMutableDictionary dictionary];
                    [details setValue:@"Wrong response format" forKey:NSLocalizedDescriptionKey];
                    error = [NSError errorWithDomain:@"Server error" code:200 userInfo:details];
                }
            }
            performCompletionBlock(completion, success, error);
        }];
    }
}

#pragma mark - MSTeamsTableViewController

- (void)requestTeamsPlayingInCountry:(MSCountry *)country
               forceUpdateFromServer:(BOOL)forceUpdateFromServer
                      withCompletion:(MSCompletionBlockWithData)completion;
{
    NSParameterAssert(country);

    NSArray *resultArray = nil;
	MSTeam *randomTeam = [MSTeam MR_findFirst];
    if ([self isValidDataInManagedObject:randomTeam] && !forceUpdateFromServer)
    {
        NSArray *teams = [MSTeam MR_findByAttribute:@"playingCountryID"
                                          withValue:self.settings.currentCountry.iD
                                         andOrderBy:@"name"
                                          ascending:YES];
        NSIndexSet *validTeams = [teams indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            MSTeam *team = (MSTeam *)obj;
            return (team.currentLeagueID.length);
        }];
        resultArray = [teams objectsAtIndexes:validTeams];
        performCompletionBlockWithData(completion, YES, nil, resultArray);
    } else {
        [self.httpClient requestTeamsPlayingInCountry:[[MSSettings settings] currentCountry]
									   withCompletion:^(BOOL success, NSError *error, id data)
          {
              NSArray *resultArray = nil;
              if (success) {
                  NSArray *teams = (NSArray *)data;
                  NSIndexSet *validTeams = [teams indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                      MSTeam *team = (MSTeam *)obj;
                      return (team.currentLeagueID.length);
                  }];
                  resultArray = [teams objectsAtIndexes:validTeams];
              }
              performCompletionBlockWithData(completion, success, error, resultArray);
          }];
    }
}

- (void)updateFavoriteStatusForTeam:(MSTeam*)team
					 withCompletion:(MSCompletionBlock)completion
{
	[self.httpClient updateFavoritesStatusForTeam:team
									   completion:
	 ^(BOOL success, NSError *requestError)
	 {
		 team.syncedValue = success;
		 [team.managedObjectContext MR_saveToPersistentStoreWithCompletion:
		  ^(BOOL success, NSError *error)
		  {
			  if (completion != nil)
				  completion(error == nil, error);
		  }];
	 }];
}

#pragma mark - MSTeamDetailsViewController
- (void)requestLastMatchesResultsForTeam:(MSTeam *)team
                   forceUpdateFromServer:(BOOL)forceUpdateFromServer
                          withCompletion:(MSCompletionBlockWithData)completion
{
    NSParameterAssert(team);
    NSArray *teamMatches = [MSMatch MR_findAllSortedBy:@"timestamp" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"teamAwayID == %@ || teamHomeID == %@", team.iD,  team.iD]];
    
    if ([self isValidaLastUpdateDate:team.matchesLastUpdateDate] && !forceUpdateFromServer)
    {
        teamMatches = [teamMatches sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            MSMatch *m1 = (MSMatch *)obj1;
            MSMatch *m2 = (MSMatch *)obj2;
            return [m2.date compare:m1.date]; //last match goes first
        }];
		NSLog(@"%@ - %lu",team.name , (unsigned long)teamMatches.count);
        performCompletionBlockWithData(completion, YES, nil, teamMatches);
    } else {
        [self.httpClient requestLastMatchesForTeam:team
                                    withCompletion:^(BOOL success, NSError *error, id data) {
                                        if(success && !error) {
                                            team.matchesLastUpdateDate = [NSDate date];
                                        }
                                        performCompletionBlockWithData(completion, success, error, data);
                                    }];
    }
}

- (void)requestPlayersOfTeam:(MSTeam *)team
       forceUpdateFromServer:(BOOL)forceUpdateFromServer
              withCompletion:(MSCompletionBlockWithData)completion
{
    NSParameterAssert(team);

    if ([self isValidaLastUpdateDate:team.playersLastUpdateDate] && !forceUpdateFromServer) {
        performCompletionBlockWithData(completion, YES, nil, team.players);
    } else {
        [self.httpClient requestSquadForTeam:team withCompletion:^(BOOL success, NSError *error, id data) {
            NSArray *teamPlayers = nil;
            if (success) {
                teamPlayers = team.players;
                team.playersLastUpdateDate = [NSDate date];
            }
            performCompletionBlockWithData(completion, success, error, teamPlayers);
        }];
    }
}

- (void)requestRatingOfLeagueWithId:(NSString *)leagueID
              forceUpdateFromServer:(BOOL)forceUpdateFromServer
                     withCompletion:(MSCompletionBlockWithData)completion
{
    NSParameterAssert(leagueID.length);
    
    NSArray *teamsResults = [MSLeagueTeamResult MR_findByAttribute:@"leagueID"
                                                         withValue:leagueID
                                                        andOrderBy:@"position"
                                                         ascending:YES];
    if ([self isValidDataInManagedObject:[teamsResults firstObject]] && !forceUpdateFromServer) {
        performCompletionBlockWithData(completion, YES, nil, teamsResults);
    } else {
        [self.httpClient requestRatingForLeagueWithID:leagueID
                                           andCountry:self.settings.currentCountry
                                       withCompletion:completion];
    }
}

- (void)requestTeamWithID:(NSString *)teamID withCompletion:(MSCompletionBlockWithData)completion {
    NSParameterAssert(teamID);
    
    MSTeam *team = [MSTeam MR_findFirstByAttribute:@"iD" withValue:teamID];
    if ([self isValidDataInManagedObject:team]) {
        performCompletionBlockWithData(completion, YES, nil, team);
    } else {
        [self.httpClient requestTeamDetailsForTeamWithID:teamID
                                          withCompletion:completion];
    }
}

#pragma mark - MSLeaguesTableViewController
- (void)requestLeaguesOfCountry:(MSCountry *)country
          forceUpdateFromServer:(BOOL)forceUpdateFromServer
                 withCompletion:(MSCompletionBlockWithData)completion
{
    NSParameterAssert(country);
    
    void (^returnLeagues)(NSArray *) = ^(NSArray *source){
        NSArray *leagues = [source sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            MSLeague *l1 = (MSLeague *)obj1;
            MSLeague *l2 = (MSLeague *)obj2;
            return [l1.iD compare:l2.iD];
        }];
        performCompletionBlockWithData(completion, YES, nil, leagues);
    };
    
    NSArray *leagues = [country.leagues allObjects];
    if ([self isValidDataInManagedObject:[leagues firstObject]] && !forceUpdateFromServer) {
        returnLeagues(leagues);
    } else {
        [self.httpClient requestLeaguesForCountry:country withCompletion:^(BOOL success, NSError *error, id data) {
            returnLeagues(data);
        }];
    }
}

#pragma mark - MSPlayersTableViewController
- (void)requestPlayersInCountry:(MSCountry *)country
                     fromOffset:(NSInteger)offset
          forceUpdateFromServer:(BOOL)forceUpdateFromServer
                 withCompletion:(MSCompletionBlockWithData)completion
{
    NSParameterAssert(country);
    
    NSArray *players = [MSPlayer MR_findByAttribute:@"playsForCountryID"
                                          withValue:country.iD
                                         andOrderBy:@"lastName"
                                          ascending:YES];
    if ((players.count >= offset + kMSPlayersCommonListDeltaUploadCounter) &&
        [self isValidDataInManagedObject:[players firstObject]] && !forceUpdateFromServer)
    {
        performCompletionBlockWithData(completion, YES, nil, players);
    } else {
        [self.httpClient requestPlayersInCountry:country
                                      fromOffset:offset
                                       withLimit:kMSPlayersCommonListDeltaUploadCounter
                                      completion:^(BOOL success, NSError *error, id data) {
                                          NSArray *allPlayers = [MSPlayer MR_findByAttribute:@"playsForCountryID"
                                                                                withValue:country.iD
                                                                               andOrderBy:@"lastName"
                                                                                ascending:YES];
                                          performCompletionBlockWithData(completion, YES, nil, allPlayers);
                                      }];
    }
}

- (void)requestForSearchPlayersByName:(NSString *)playerName
                       withCompletion:(MSCompletionBlockWithData)completion
{
    [self.httpClient requestPlayersWithNamePattern:playerName
                                        completion:completion];
}

#pragma mark - MSPlayerDetailsViewController
- (void)requestStatisticsForPlayer:(MSPlayer *)player
             forceUpdateFromServer:(BOOL)forceUpdateFromServer
                    withCompletion:(MSCompletionBlockWithData)completion
{
    NSArray *playerResults = [player.seasonsResults allObjects];
    playerResults = [playerResults sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        MSPlayerProgress *result1 = (MSPlayerProgress *)obj1;
        MSPlayerProgress *result2 = (MSPlayerProgress *)obj2;
        return [result1.seasonID compare:result2.seasonID];
    }];
    if ([self isValidDataInManagedObject:[playerResults firstObject]] && !forceUpdateFromServer) {
        performCompletionBlockWithData(completion, YES, nil, playerResults);
    } else {
        [self.httpClient requestStatisticForPlayer:player completion:completion];
    }
}

-(void)requestLastMatchesForFavoriteTeamsForceUpdateFromServer:(BOOL)forceUpdateFromServer withCompletion:(MSCompletionBlockWithData)completion
{
//	NSArray *resultArray = nil;
//	MSMatch *randomMatch = [MSMatch MR_findFirst];
//	if ([self isValidDataInManagedObject:randomTeam] && !forceUpdateFromServer)
//	{
//		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teamAway.favorite == %@ OR teamHome.favorite == %@", @YES, @YES];
//		NSArray *matches = [MSMatch MR_findAllWithPredicate:predicate];
//		NSIndexSet *validMatches = [matches indexesOfObjectsPassingTest:
//									^BOOL(id obj, NSUInteger idx, BOOL *stop)
//									{
//										MSMatch *match = (MSMatch *)obj;
//
//										return (match.leagueID.length);
//									}];
//		resultArray = [matches objectsAtIndexes:validMatches];
//		performCompletionBlockWithData(completion, YES, nil, resultArray);
//	}
//	else {
		[self.httpClient requestLastMatchesForFavoriteTeamsWithCompletion:
		 ^(BOOL success, NSError *error, id data)
		 {
			 if (success)
			 {
				 NSArray *matches = (NSArray *)data;
				 matches = [matches sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
					 MSMatch *m1 = (MSMatch *)obj1;
					 MSMatch *m2 = (MSMatch *)obj2;
					 return [m2.date compare:m1.date]; //last match goes first
				 }];
				 performCompletionBlockWithData(completion, success, error, matches);
			 }
		 }];
//	}
}

#pragma mark - Notification

- (void)rechabilityChangedNotification:(NSNotification*)notification
{
	AFNetworkReachabilityStatus status = [[notification object] integerValue];
	if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
	{
		
	}
}

@end
