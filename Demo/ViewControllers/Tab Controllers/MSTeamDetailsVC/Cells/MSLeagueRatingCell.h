//
//  MSLeagueRatingCell.h
//  FlagRecognition
//
//  Created by Lexiren on 2/13/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "MSTableViewCell.h"
#import "MSColorScheme.h"

@interface MSLeagueRatingCell : MSTableViewCell

@property (strong, nonatomic) NSString *userTeamID;
@property (nonatomic, strong) MSColorScheme * colorScheme;

@end
