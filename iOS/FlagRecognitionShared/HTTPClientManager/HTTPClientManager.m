//
//  HTTPClientManager.m
//  FlagRecognition
//
//  Created by Vyacheslav Nechiporenko on 8/5/13.
//  Copyright (c) 2013 Moodstocks. All rights reserved.
//

#import "HTTPClientManager.h"
#import "AFNetworking.h"

#ifndef AF_APP_EXTENSIONS
#import "AFNetworkActivityIndicatorManager.h"
#endif

#import "AFNetworkReachabilityManager.h"
#import "MSAppDelegate.h"

#import "CoreData+MagicalRecord.h"
#import "NSUserDefaults+AppGroup.h"

#import "MSCountry.h"
#import "MSLeague.h"
#import "MSTeam.h"
#import "MSMatch.h"
#import "MSPlayer.h"
#import "MSLeagueTeamResult.h"
#import "MSPlayerProgress.h"
#import "MSEvent.h"

@interface HTTPClientManager ()

@property (nonatomic,strong) NSString *userId;

@end

//static NSString * const kBaseURLString = @"http://vmfootbalclubs.kha.dataart.net";
static NSString * const kBaseURLString = @"http://91.247.221.248/api/public";// test server
//static NSString * const kBaseURLString = @"http://91.247.221.210/api/public";

//static NSString * const kBaseURLString = @"http://91.247.221.248/api/public";
static NSString * const kCountries = @"countries";
static NSString * const kTeamsOfCountry = @"teamsofcountry/";
static NSString * const kTeam = @"team/";
static NSString * const kEvent = @"event/";
static NSString * const kCountry = @"country/";
static NSString * const kLastMatches = @"last_matches/";
static NSString * const kSquad = @"squad/";
static NSString * const kLeague = @"league/";
static NSString * const kPlayersOfCountry = @"playersofcountry/";
static NSString * const kOffset = @"offset/";
static NSString * const kLimit = @"limit/";
static NSString * const kPlayersByName = @"getplayerbyname/";
static NSString * const kTournament = @"tournament/";
static NSString * const kPlayer = @"player/";
static NSString * const kSuccess = @"success";
static NSString * const kFalse = @"false";
static NSString * const kUserID = @"UserId";
//static NSUInteger const kImagesArrayCount = 6;

static NSString * const kHTTPClientManagerKeychainIdentifier = @"FlagRecognition";
static NSString * const kHTTPClientManagerKeychainAccessGroup = @"com.dataart.moodstocks";

NSString * const kHTTPClientManagerReachabilityStateChangedNotification = @"kHTTPClientManagerReachabilityStateChangedNotification";

@implementation HTTPClientManager

#pragma mark - Team info requests

/*
- (void) requestForTeamInfoWithTeam : (NSString *) teamName completion:(void (^)(id)) callback {
    NSURLRequest * request = [self requestWithMethod:@"GET" path:@"" parameters:@{@"team": [teamName lowercaseString]}];
    [self requestForJSONDataWithRequest:request completion:^(id json) {
        callback(json);
    }];
}

- (void) requestForPlayerInfoWithPlayer : (NSString *) player completion:(void (^)(id)) callback {
//    NSURLRequest * request = [self requestWithMethod:@"GET" path:@"" parameters:@{@"player_id": [player lowercaseString]}];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://vmfootbalclubs.kha.dataart.net/?player_id=2" ]];
    [self requestForJSONDataWithRequest:request completion:^(id json) {
        callback(json);
    }];
}

- (void) requestForLeagueTableDataWithLeagueName : (NSString *) leagueName completion : (void (^)(NSArray *)) leagueTable {
    NSURLRequest * request = [self requestWithMethod:@"GET" path:@"" parameters:@{@"league": [leagueName lowercaseString]}];
    
    [self requestForJSONDataWithRequest:request completion:^(id json) {
        leagueTable(json);
    }];
}

- (void) requestForAllAvaiableTeamsWithCompletion : (void (^)(NSArray *)) allTeams {
    NSURLRequest * request = [self requestWithMethod:@"GET" path:@"" parameters:@{@"teams": @""}];
    
    [self requestForJSONDataWithRequest:request completion:^(id json) {
        allTeams(json);
    }];
}

- (void) requestForAllLeaguesWithCompletion : (void (^)(NSArray *)) allTeams {
    NSURLRequest * request = [self requestWithMethod:@"GET" path:@"" parameters:@{@"leagues": @""}];
    
    [self requestForJSONDataWithRequest:request completion:^(id json) {
        allTeams(json);
    }];
}

 */

/********************* new api ***************/
//- (void)performBlock:(void (^)(id))block withParameter:(id)parameter {
//    if (block) {
//        block(parameter);
//    }
//}

- (void)requestCountriesWithCompletion:(MSCompletionBlockWithData)completion
{
    [self GET:kCountries parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *countries = nil;
        
        if (responseObject) {
            countries = [MSCountry MR_importFromArray:responseObject[@"data"]];
        }
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
        
        performCompletionBlockWithData(completion, YES, nil, countries);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        performCompletionBlockWithData(completion, NO, error, nil);
    }];
}

- (void)requestTeamsPlayingInCountry:(MSCountry *)country withCompletion:(MSCompletionBlockWithData)completion
{
    NSParameterAssert(country);
    
    NSString *path = [NSString stringWithFormat:@"%@%@", kTeamsOfCountry, country.iD];
    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *teams = nil;
        if (responseObject) {
            teams = [MSTeam MR_importFromArray:responseObject[@"data"]];
        }
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
        
        performCompletionBlockWithData(completion, YES, nil, teams);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        performCompletionBlockWithData(completion, NO, error, nil);
    }];
}

- (void)requestTeamDetailsForTeamWithID:(NSString *)teamID withCompletion:(MSCompletionBlockWithData)completion {
    NSParameterAssert(teamID);
    
    NSString *path = [NSString stringWithFormat:@"%@%@", kTeam, teamID];

    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id teamJSON) {
        MSTeam *team = nil;
        BOOL success = YES;
        NSError * error = nil;
        if (teamJSON) {
            id currentLeagueID = [teamJSON valueForKey:@"current_league_id"];
            if ([currentLeagueID respondsToSelector:@selector(firstObject)] && ![[currentLeagueID firstObject] isKindOfClass:[NSNull class]]) {
                team = [MSTeam MR_importFromObject:teamJSON[@"data"]];
            } else {
                NSLog(@"wrong teamJSON : %@", [teamJSON description]);
                NSMutableDictionary *details = [NSMutableDictionary dictionary];
                [details setValue:@"Cann't find a valid info about this team" forKey:NSLocalizedDescriptionKey];
                error = [NSError errorWithDomain:@"Oops!" code:200 userInfo:details];
                success = NO;
            }
            
        }
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
        
        performCompletionBlockWithData(completion, success, error, team);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        performCompletionBlockWithData(completion, NO, error, nil);
    }];
}

- (void)requestEventDetailsForEventWithID:(NSString *)eventID withCompletion:(MSCompletionBlockWithData)completion {
    NSParameterAssert(eventID);
    
    NSString *path = [NSString stringWithFormat:@"%@%@", kEvent, eventID];
    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id eventJSON) {
        MSEvent *event = nil;
        BOOL success = YES;
        NSError * error = nil;
        if (eventJSON) {
            // operate with relationship data from json

        }
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
        
        performCompletionBlockWithData(completion, success, error, event);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        performCompletionBlockWithData(completion, NO, error, nil);
    }];
}

- (void)requestLeaguesForCountry:(MSCountry *)country withCompletion:(MSCompletionBlockWithData)completion
{
    NSParameterAssert(country);
    
    NSString *path = [NSString stringWithFormat:@"%@%@",kCountry, country.iD];
    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id leaguesJSON) {
        NSArray *leagues = nil;
        
        if (leaguesJSON) {
            leagues = [MSLeague MR_importFromArray:leaguesJSON[@"data"]];
            [country setLeagues:[NSSet setWithArray:leagues]];
        }
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
        
        performCompletionBlockWithData(completion, YES, nil, leagues);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        performCompletionBlockWithData(completion, NO, error, nil);
    }];
}

- (void)requestLastMatchesForTeam:(MSTeam *)team withCompletion:(MSCompletionBlockWithData)completion
{
    NSParameterAssert(team);
    
    NSString *path = [NSString stringWithFormat:@"%@%@/%@", kTeam, team.iD, kLastMatches];
    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id matchesJSON) {
        NSArray *matches = nil;
        
        if (matchesJSON) {
            matches = [MSMatch MR_importFromArray:matchesJSON[@"data"]];
        }
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
        
        performCompletionBlockWithData(completion, YES, nil, matches);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        performCompletionBlockWithData(completion, NO, error, nil);
    }];
}

- (void)requestSquadForTeam:(MSTeam *)team withCompletion:(MSCompletionBlockWithData)completion {
    NSParameterAssert(team);
    
    NSString *path = [NSString stringWithFormat:@"%@%@/%@", kTeam, team.iD, kSquad];
    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id playersJSON) {
        NSArray *players = nil;
        
        if (playersJSON) {
            players = [MSPlayer MR_importFromArray:playersJSON[@"data"]];
            [team setSquad:[NSSet setWithArray:players]];
        }
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
        
        performCompletionBlockWithData(completion, YES, nil, players);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        performCompletionBlockWithData(completion, NO, error, nil);
    }];
}

- (void)requestRatingForLeagueWithID:(NSString *)leagueID
                          andCountry:(MSCountry *)country
                      withCompletion:(MSCompletionBlockWithData)completion
{
    NSParameterAssert(leagueID.length && country);
    
    NSString *path = [NSString stringWithFormat:@"%@%@/%@%@", kCountry, country.iD, kLeague, leagueID];
    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id teamResultsJSON) {
        NSArray *teamResults = nil;
        
        if (teamResultsJSON) {
            teamResults = [MSLeagueTeamResult MR_importFromArray:teamResultsJSON[@"data"]];
            teamResults = [teamResults sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                MSLeagueTeamResult *firstResult = (MSLeagueTeamResult *)obj1;
                MSLeagueTeamResult *secondResult = (MSLeagueTeamResult *)obj2;
                
                return [firstResult.position compare:secondResult.position];
            }];
        }
        
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
        
        performCompletionBlockWithData(completion, YES, nil, teamResults);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        performCompletionBlockWithData(completion, NO, error, nil);
    }];
}

- (void)requestPlayersInCountry:(MSCountry *)country
                     fromOffset:(NSInteger)offset
                      withLimit:(NSInteger)limit
                     completion:(MSCompletionBlockWithData)completion
{
    NSParameterAssert(country);

    NSString *path = [NSString stringWithFormat:@"%@%@/%@%ld/%@%ld", kPlayersOfCountry, country.iD, kOffset, (long)offset, kLimit, (long)limit];
    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id playersJSON) {
        NSArray *players = nil;
        
        if (playersJSON) {
            players = [MSPlayer MR_importFromArray:playersJSON[@"data"]];
        }
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
        
        performCompletionBlockWithData(completion, YES, nil, players);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        performCompletionBlockWithData(completion, NO, error, nil);
    }];
}

- (void)requestPlayersWithNamePattern:(NSString *)namePattern
                           completion:(MSCompletionBlockWithData)completion
{
    NSParameterAssert(namePattern.length);

    NSString *path = [NSString stringWithFormat:@"%@%@", kPlayersByName, namePattern];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id playersJSON) {
        NSArray *players = nil;
        
        if (playersJSON) {
            players = [MSPlayer MR_importFromArray:playersJSON[@"data"]];
        }
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
        
        performCompletionBlockWithData(completion, YES, nil, players);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        performCompletionBlockWithData(completion, NO, error, nil);
    }];
}

- (void)requestStatisticForPlayer:(MSPlayer *)player completion:(MSCompletionBlockWithData)completion {
    NSParameterAssert(player);

    NSString *path = [NSString stringWithFormat:@"%@%@/%@", kPlayer, player.iD, kTournament];
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id resultsJSON) {
        NSArray *results = nil;
        
        if (resultsJSON) {
            results = [MSPlayerProgress MR_importFromArray:resultsJSON[@"data"]];
            results = [results sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                MSPlayerProgress *result1 = (MSPlayerProgress *)obj1;
                MSPlayerProgress *result2 = (MSPlayerProgress *)obj2;
                return [result1.seasonID compare:result2.seasonID];
            }];
        }
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
        
        performCompletionBlockWithData(completion, YES, nil, results);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        performCompletionBlockWithData(completion, NO, error, nil);
    }];
}

#pragma mark - Registration

-(void)requestUserIDIfNeededWithCompletion:(MSCompletionBlock)completion
{
	if (self.userId == nil || self.userId.length == 0)
		[self requestUserIDWithCompletion:completion];
	else
		performCompletionBlock(completion, YES, nil);
}

-(void)requestUserIDWithCompletion:(MSCompletionBlock)completion
{
	NSString *path  = [NSString stringWithFormat:@"/api/registration/device_id/%@",[HTTPClientManager deviceId]];
	[self GET:path
   parameters:nil
	  success:
	 ^(NSURLSessionDataTask *task, id responseObject)
	 {
		 BOOL success = [responseObject objectForKey:kSuccess] != kFalse;
		 if (success)
		 {
			 NSDictionary *data = [responseObject objectForKey:@"data"];
			 self.userId = [data objectForKey:@"user_id"];
			 if (self.userId != nil)
			 {
				 [[NSUserDefaults sharedUserDefaults] setObject:self.userId forKey:kUDFlagRecognizerUserID];
				 [[NSUserDefaults sharedUserDefaults] synchronize];
			 }
		 }
		 performCompletionBlock(completion, success, nil);
	 }
	  failure:
	 ^(NSURLSessionDataTask *task, NSError *error)
	 {
		 performCompletionBlock(completion, NO, error);
	 }];
}

- (void)registerForPushNotificationsWithDeviceToken:(NSData *)token completion:(MSCompletionBlock)completion
{
	NSString *tokenString = [[token description] stringByReplacingOccurrencesOfString:@" " withString:@""];
	tokenString = [tokenString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	NSString *path  = [NSString stringWithFormat:@"/api/savedevicetoken/user/%@/device/%@/token/%@", self.userId,[HTTPClientManager deviceId],tokenString];
	[self GET:path
   parameters:nil
	  success:
	 ^(NSURLSessionDataTask *task, id responseObject)
	 {
		 BOOL success = [responseObject objectForKey:kSuccess] != kFalse;
		 performCompletionBlock(completion, success, nil);
	 }
	  failure:
	 ^(NSURLSessionDataTask *task, NSError *error)
	 {
		 performCompletionBlock(completion, NO, error);
	 }];
}

#pragma mark - Favorites

- (void)updateFavoritesStatusForTeam:(MSTeam *)team completion:(MSCompletionBlock)completion
{
	if (self.userId == nil)
		return;
	
	NSString *path  = [NSString stringWithFormat:@"/api/favouriteteam/user/%@/team/%@/status/%D", self.userId, team.iD, team.favoriteValue ? 1 : 0];
	[self GET:path
   parameters:nil
	  success:
	 ^(NSURLSessionDataTask *task, id responseObject)
	 {
		 BOOL success = [responseObject objectForKey:kSuccess] != kFalse;
		 performCompletionBlock(completion, success, nil);
	 }
	  failure:
	 ^(NSURLSessionDataTask *task, NSError *error)
	 {
		 performCompletionBlock(completion, NO, error);
	 }];
}

- (void)updateFavoritesStatus:(BOOL)favorite teams:(NSArray *)teams completion:(MSCompletionBlock)completion
{
	if (self.userId == nil || teams == nil || teams.count == 0)
		return;
	
	NSString *teamIDs = nil;
	for (MSTeam *team in teams)
	{
		if (teamIDs == nil)
			teamIDs = team.iD;
		else
			teamIDs = [teamIDs stringByAppendingString:[NSString stringWithFormat:@"|%@",team.iD]];
	}
	NSString *path = [NSString stringWithFormat:@"/api/favouriteteam/user/%@/team/%@/status/%d", self.userId, teams, favorite];
	[self GET:path
   parameters:nil
	  success:
	 ^(NSURLSessionDataTask *task, id responseObject)
	 {
		 BOOL success = [responseObject objectForKey:kSuccess] != kFalse;
		 performCompletionBlock(completion, success, nil);
	 }
	  failure:
	 ^(NSURLSessionDataTask *task, NSError *error)
	 {
		 performCompletionBlock(completion, NO, error);
	 }];
}

#pragma mark - common request

- (void)requestForJSONDataWithRequest:(NSURLRequest *)request completion:(MSCompletionBlockWithData)callback {
#ifndef AF_APP_EXTENSIONS
    if (![[UIApplication sharedApplication]canOpenURL:request.URL]) {
        callback(NO, nil, nil);
        return;
    }
#endif
    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id JSON, NSError *error) {
        
        if (error){
            NSLog(@"%@", [error localizedDescription]);
            callback(NO, error, nil);
            return ;
        }
        
        if ([[JSON valueForKey:kSuccess] isEqualToString:kFalse]) {
            NSArray *errorMessages = [[JSON valueForKey:@"error"] valueForKey:@"messages"];
            NSDictionary *details = [NSMutableDictionary dictionary];
            [details setValue:[errorMessages firstObject] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"Server error" code:200 userInfo:details];
            callback(NO, error, nil);
        } else {
            if ([JSON valueForKey:@"data"]){
                callback(YES, nil, [JSON valueForKey:@"data"]);
            } else {
                NSDictionary *details = [NSMutableDictionary dictionary];
                [details setValue:@"Wrong response format" forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"Server error" code:200 userInfo:details];
                callback(NO, error, nil);
            }
        }
    }];
    
    [dataTask resume];
}

#pragma mark - Extension

- (void)requestLastMatchesForFavoriteTeamsWithCompletion:(MSCompletionBlockWithData)completion
{
	NSString *path = [NSString stringWithFormat:@"/api/favouriteteamsnearestmarch/user/%@", self.userId];
	
	[self GET:path
   parameters:nil
	  success:
	 ^(NSURLSessionDataTask *task, id matchesJSON)
	 {
		 NSArray *matches = nil;
		 id data = matchesJSON[@"data"];
		 if ([data isKindOfClass:[NSDictionary class]])
			 data = [data allValues];
		 if (matchesJSON)
			 matches = [MSMatch MR_importFromArray:data];
		 
		 performCompletionBlockWithData(completion, YES, nil, matches);
	 }
	  failure:
	 ^(NSURLSessionDataTask *task, NSError *error)
	 {
		 performCompletionBlockWithData(completion, NO, error, nil);
	 }];
}

#pragma mark - Image Request

- (void) teamImageWithTeam : (NSString *) teamName completion:(void (^)(UIImage *)) callback {
    if (!teamName) {
        callback(nil);
        return;
    }
   
    NSURL * correctURL = [self urlForImagesRequestWithQuery:[self correctGoogleTextWithTeamName:teamName]];;
   
    NSURLRequest * request = [NSURLRequest requestWithURL:correctURL];
    NSURLSessionTask * dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id JSON, NSError *error) {
        if (error || !JSON){
            callback(nil);
            return ;
        }
        
        NSString * imageUrlString = nil;
        id array = [[JSON valueForKey:@"responseData"]valueForKey:@"results"];
        if ([array respondsToSelector:@selector(objectAtIndex:)]) {
            
            if ([array count]>0) {
                imageUrlString = [[array objectAtIndex:0]valueForKey:@"url"];
                [self teamLogoImageWithImageUrlString:imageUrlString completion:^(UIImage * image) {
                    callback(image);
                }];
            }
            else {
                callback(nil);
            }
        }
        else {
            callback(nil);
        }
    }];
    
    [dataTask resume];
}

- (void) teamLogoImageWithImageUrlString:(NSString *)url completion:(void (^)(UIImage *)) callback {   
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:imageRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil);
    }];
    [requestOperation start];
}

- (NSString *) correctGoogleTextWithTeamName : (NSString *) name {
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    return [NSString stringWithFormat:@"%@+fc+club+logo",[name lowercaseString]];
}

- (NSURL *) urlForImagesRequestWithQuery : (NSString *) query {
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=6&q=%@&start=0&&imgsz=medium",query]];
}

#pragma mark - Singleton methods

+ (HTTPClientManager *) sharedHTTPClient {
    
    static HTTPClientManager * _shared = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 0;
//        config.HTTPMaximumConnectionsPerHost = 3;
        _shared = [[super alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString] sessionConfiguration:config];
        _shared.requestSerializer = [AFJSONRequestSerializer serializer];
        _shared.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
		_shared.userId = [[NSUserDefaults sharedUserDefaults] objectForKey:kUDFlagRecognizerUserID];

#ifndef AF_APP_EXTENSIONS
		[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
#endif
		[[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:
		 ^(AFNetworkReachabilityStatus status)
		 {
			 if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown)
				 return;
			 
			 [_shared requestUserIDIfNeededWithCompletion:
			  ^(BOOL success, NSError *error)
			  {
				  if (success)
					  [[NSNotificationCenter defaultCenter] postNotificationName:kHTTPClientManagerReachabilityStateChangedNotification object:[NSNumber numberWithInteger:status]];
			  }];
		 }];
	});
    return _shared;
}

+ (NSString*)deviceId
{
	return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

@end
