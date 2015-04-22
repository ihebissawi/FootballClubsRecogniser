//
//  MSMatchCell.h
//  FlagRecognition
//
//  Created by Lexiren on 2/12/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "MSTableViewCell.h"

@interface MSMatchCell : MSTableViewCell

@property (copy, nonatomic) MSButtonHandleBlockWithData didTapTeamInfoButton;
@property (strong, nonatomic) NSString *userTeamID;

@end
