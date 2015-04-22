//
//  MSPlayerStatisticCell.m
//  FlagRecognition
//
//  Created by Lexiren on 2/20/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "MSPlayerStatisticCell.h"
#import "MSPlayerProgress.h"

@interface MSPlayerStatisticCell ()
@property (weak, nonatomic) IBOutlet UILabel *tornamentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gLabel;
@property (weak, nonatomic) IBOutlet UILabel *aLabel;
@property (weak, nonatomic) IBOutlet UILabel *ycLabel;
@property (weak, nonatomic) IBOutlet UILabel *rcLabel;

@end

@implementation MSPlayerStatisticCell

+ (NSString *)MS_reuseIdentifier {
    return @"PlayerStatisticCellIdentifier";
}

+ (CGFloat)cellHeight {
    static CGFloat _cellHeight = 0.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MSPlayerStatisticCell *tempCell = [MSPlayerStatisticCell MS_loadViewFromNIB];
        _cellHeight = tempCell.bounds.size.height;
    });
    
    return _cellHeight;
}

- (void)updateUI {
    if (![self.source isKindOfClass:[MSPlayerProgress class]]) return;
    
    MSPlayerProgress *player = (MSPlayerProgress *)self.source;
    
    
    [self.tornamentNameLabel setFont:[UIFont fontWithName:@"OpenSans" size:11.0f]];
    [self.gLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:12.0f]];
    [self.aLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:12.0f]];
    [self.ycLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:12.0f]];
    [self.rcLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:12.0f]];
    
    NSRange range = [player.seasonName rangeOfString:@"/"];
    NSString *season = player.seasonName;
    if (range.length >0) {
        season = [player.seasonName substringWithRange:NSMakeRange(range.location-2,range.location-1)];
        season = [season stringByAppendingString:[player.seasonName substringWithRange:NSMakeRange(player.seasonName.length - 2,2)]];
    }
    else {
        season = [player.seasonName substringWithRange:NSMakeRange(player.seasonName.length - 2,2)];
    }
    

    self.tornamentNameLabel.text = [NSString stringWithFormat:@"%@ %@", player.leagueName, season];

    
    self.gLabel.text = player.goal;
    self.aLabel.text = player.appearances;
    self.ycLabel.text = player.yellowCard;
    self.rcLabel.text = player.redCard;
}

@end
