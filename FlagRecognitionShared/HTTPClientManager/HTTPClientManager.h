//
//  HTTPClientManager.h
//  FlagRecognition
//
//  Created by Vyacheslav Nechiporenko on 8/5/13.
//  Copyright (c) 2013 Moodstocks. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@class MSCountry;
@class MSTeam;

extern NSString *const kHTTPClientManagerReachabilityStateChangedNotification;

@interface HTTPClientManager : AFHTTPSessionManager

+ (instancetype) sharedHTTPClient;

//- (void) requestForTeamInfoWithTeam : (NSString *) teamName completion:(void (^)(id)) callback;
//- (void) teamImageWithTeam : (NSString *) teamName completion:(void (^)(UIImage *)) callback;
//- (void) requestForAllAvaiableTeamsWithCompletion : (void (^)(NSArray *)) allTeams;
//- (void) requestForLeagueTableDataWithLeagueName : (NSString *) leagueName completion : (void (^)(NSArray *)) leagueTable;
//- (void) requestForAllLeaguesWithCompletion : (void (^)(NSArray *)) allTeams;
//- (void) requestForPlayerInfoWithPlayer : (NSString *) player completion:(void (^)(id)) callback;


- (void)requestCountriesWithCompletion:(MSCompletionBlockWithData)completion;
- (void)requestTeamsPlayingInCountry:(MSCountry *)country withCompletion:(MSCompletionBlockWithData)completion;
- (void)requestTeamDetailsForTeamWithID:(NSString *)teamID withCompletion:(MSCompletionBlockWithData)completion;
- (void)requestLeaguesForCountry:(MSCountry *)country withCompletion:(MSCompletionBlockWithData)completion;
- (void)requestLastMatchesForTeam:(MSTeam *)team withCompletion:(MSCompletionBlockWithData)completion;
- (void)requestSquadForTeam:(MSTeam *)team withCompletion:(MSCompletionBlockWithData)completion;
- (void)requestRatingForLeagueWithID:(NSString *)leagueID
                          andCountry:(MSCountry *)country
                      withCompletion:(MSCompletionBlockWithData)completion;
- (void)requestPlayersInCountry:(MSCountry *)country
                     fromOffset:(NSInteger)offset
                      withLimit:(NSInteger)limit
                     completion:(MSCompletionBlockWithData)completion;
- (void)requestPlayersWithNamePattern:(NSString *)namePattern
                           completion:(MSCompletionBlockWithData)completion;
- (void)requestStatisticForPlayer:(MSPlayer *)player completion:(MSCompletionBlockWithData)completion;
//
//Registration
- (BOOL)isRegistered;
- (void)requestUserIDIfNeededWithCompletion:(MSCompletionBlock)completion;
- (void)registerForPushNotificationsWithDeviceToken:(NSData*)token completion:(MSCompletionBlock)completion;
//
//Favorites
- (void)updateFavoritesStatusForTeam:(MSTeam*)team completion:(MSCompletionBlock)completion;
- (void)updateFavoritesStatus:(BOOL)favorite teams:(NSArray*)teams completion:(MSCompletionBlock)completion;
//
//Extension
- (void)requestLastMatchesForFavoriteTeamsWithCompletion:(MSCompletionBlockWithData)completion;

@end


