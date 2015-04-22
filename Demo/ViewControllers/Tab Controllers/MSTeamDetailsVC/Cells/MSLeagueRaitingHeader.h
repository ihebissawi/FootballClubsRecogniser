//
//  MSLeagueRaitingHeader.h
//  FlagRecognition
//
//  Created by Michael Murnik on 12/25/14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSTableViewCell.h"
@interface MSLeagueRaitingHeader : UIView

+ (CGFloat)viewDefaultHeight;
@property (weak, nonatomic) IBOutlet UILabel *posLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UILabel *gpLabel;
@property (weak, nonatomic) IBOutlet UILabel *ptsLabal;

@end
