//
//  MSLeagueDetailsViewController.h
//  FlagRecognition
//
//  Created by Lexiren on 2/17/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "MSTableViewController.h"
#import "MSNavigationControllerAnimation.h"

@class MSLeague;

@interface MSLeagueDetailsViewController : MSTableViewController <MSNavigationControllerAnimation>

@property (strong, nonatomic) MSLeague *sourceLeague;

@end

extern NSString *const kMSLeagueDetailsPushSegueIdentifier;

