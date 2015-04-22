//
//  MSTeamDetailsViewController.h
//  FlagRecognition
//
//  Created by Lexiren on 2/10/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSColorScheme.h"

@class MSTeam;

@interface MSTeamDetailsViewController : UIViewController

@property (nonatomic, strong) MSTeam *sourceTeam;
@property (nonatomic, strong) MSColorScheme * colorScheme;

@end

extern NSString *const kMSTeamDetailsPushSegueIdentifier;
extern NSString *const kMSTeamDetailsPushFromLeagueSegueIdentifier;
extern NSString *const kMSTeamDetailsVCIdentifier;
