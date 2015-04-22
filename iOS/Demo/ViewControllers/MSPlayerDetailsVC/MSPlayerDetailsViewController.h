//
//  MSPlayerDetailsViewController.h
//  FlagRecognition
//
//  Created by Lexiren on 2/19/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSColorScheme.h"
@class MSPlayer;

@interface MSPlayerDetailsViewController : UIViewController

@property (strong, nonatomic) MSPlayer *sourcePlayer;
@property (nonatomic, strong) MSColorScheme * colorScheme;

@end

extern NSString *const kMSPushPlayerDetailsSegueIdentifier; 
extern NSString *const kMSPushPlayerDetailsFromTeamSegueIdentifier;
