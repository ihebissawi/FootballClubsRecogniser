//
//  MSDataManager.h
//  FlagRecognition
//
//  Created by Lexiren on 2/11/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSSettings;
@class MSCountry;
@class MSTeam;
@class MSMatch;
@class MSPlayer;

@interface MSDataManager : NSObject

@property (nonatomic, strong, readonly) MSSettings *settings;

+ (instancetype)sharedManager;

- (void)stopLoading;

//for MSTableViewController
- (void)requestSettingsCurrentCountryWithCompletion:(MSCompletionBlock)completion;

//for MSTeamsTableViewController
- (void)requestTeamsPlayingInCountry:(MSCountry *)country
               forceUpdateFromServer:(BOOL)forceUpdateFromServer
                      withCompletion:(MSCompletionBlockWithData)completion;

- (void)updateFavoriteStatusForTeam:(MSTeam*)team
					 withCompletion:(MSCompletionBlock)completion;

//for MSTeamDetailsViewController
- (void)requestLastMatchesResultsForTeam:(MSTeam *)team
                   forceUpdateFromServer:(BOOL)forceUpdateFromServer
                          withCompletion:(MSCompletionBlockWithData)completion;
- (void)requestPlayersOfTeam:(MSTeam *)team
       forceUpdateFromServer:(BOOL)forceUpdateFromServer
              withCompletion:(MSCompletionBlockWithData)completion;
- (void)requestRatingOfLeagueWithId:(NSString *)leagueID
              forceUpdateFromServer:(BOOL)forceUpdateFromServer
                     withCompletion:(MSCompletionBlockWithData)completion;
- (void)requestTeamWithID:(NSString *)teamID withCompletion:(MSCompletionBlockWithData)completion;

- (void)requestEventWithID:(NSString *)eventID withCompletion:(MSCompletionBlockWithData)completion;

//for MSLeaguesTableViewController
- (void)requestLeaguesOfCountry:(MSCountry *)country
          forceUpdateFromServer:(BOOL)forceUpdateFromServer
                 withCompletion:(MSCompletionBlockWithData)completion;

//for MSPlayersTableViewController
- (void)requestPlayersInCountry:(MSCountry *)country
                     fromOffset:(NSInteger)offset
          forceUpdateFromServer:(BOOL)forceUpdateFromServer
                 withCompletion:(MSCompletionBlockWithData)completion;
- (void)requestForSearchPlayersByName:(NSString *)playerName
                       withCompletion:(MSCompletionBlockWithData)completion;

//for MSPlayerDetailsViewController
- (void)requestStatisticsForPlayer:(MSPlayer *)player
             forceUpdateFromServer:(BOOL)forceUpdateFromServer
                    withCompletion:(MSCompletionBlockWithData)completion;

//for Extesnions
- (void)requestLastMatchesForFavoriteTeamsForceUpdateFromServer:(BOOL)forceUpdateFromServer
												 withCompletion:(MSCompletionBlockWithData)completion;


- (void)requestEventsForMatch:(MSMatch *)match
                   forceUpdateFromServer:(BOOL)forceUpdateFromServer
                          withCompletion:(MSCompletionBlockWithData)completion;
@end
