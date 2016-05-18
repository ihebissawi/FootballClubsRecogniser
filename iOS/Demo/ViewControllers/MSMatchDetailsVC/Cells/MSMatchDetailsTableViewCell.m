//
//  MSMatchDetailsTableViewCell.m
//  FlagRecognition
//
//  Created by Mykyta Karpyshyn on 1/14/16.
//  Copyright © 2016 DataArt Solutions, Inc. All rights reserved.
//

#import "MSMatchDetailsTableViewCell.h"

@interface MSMatchDetailsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *cellContent;
@property (weak, nonatomic) IBOutlet UIView *coloredLine;


@end

@implementation MSMatchDetailsTableViewCell

+ (NSString *)MS_reuseIdentifier {
    return @"MSMatchDetailsTableViewCellIdentifier";
}

+ (CGFloat)cellHeight {
    return 75;
}

-(void)layoutSubviews{
    self.cellContent.layer.cornerRadius = 5;
    self.cellContent.layer.masksToBounds = YES;
    
    self.coloredLine.layer.cornerRadius = 3;
    self.coloredLine.layer.masksToBounds = YES;
}

- (void)setEventTitle:(NSString *)title description:(NSString *)desc time:(NSString *)time teamColor:(UIColor *)teamColor{
    self.eventNameLabel.text = title;
    self.eventDescriptionLabel.text = desc;
    self.timeLabel.text = time;
    
    if(teamColor){
        self.coloredLine.backgroundColor = teamColor;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
