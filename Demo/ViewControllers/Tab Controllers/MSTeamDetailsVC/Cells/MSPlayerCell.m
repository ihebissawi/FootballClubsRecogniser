//
//  MSPlayerCell.m
//  FlagRecognition
//
//  Created by Lexiren on 2/12/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "MSPlayerCell.h"
#import "MSPlayer.h"
#import "UIImage+MSUtils.h"
#import "MSRoundedImageView.h"

@interface MSPlayerCell ()

@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerShirtImageView;
@property (weak, nonatomic) IBOutlet MSRoundedImageView *flagRoundedImageView;

@end

@implementation MSPlayerCell

+ (NSString *)MS_reuseIdentifier {
    return @"PlayerCellIdentifier";
}

+ (CGFloat)cellHeight {
    static CGFloat _cellHeight = 0.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MSPlayerCell *tempCell = [MSPlayerCell MS_loadViewFromNIB];
        _cellHeight = tempCell.bounds.size.height;
    });

    return _cellHeight;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.flagRoundedImageView.backgroundColor = [UIColor whiteColor];
    self.flagRoundedImageView.disableImageSizeAdjusting = YES;
    self.flagRoundedImageView.imageView.contentMode = UIViewContentModeCenter;
    self.flagRoundedImageView.imageView.layer.cornerRadius = CGRectGetWidth(self.flagRoundedImageView.imageView.bounds) / 2;
    self.flagRoundedImageView.borderWidth = 2.0;
    self.flagRoundedImageView.borderColor = [UIColor colorWithWhite:205.0f/255.0f alpha:1];
    
    
    self.playerNameLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    self.playerPositionLabel.font = [UIFont fontWithName:@"OpenSans" size:12];
    self.playerNumberLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:14];
}

- (void)updateUI {
    if(![self.source isKindOfClass:[MSPlayer class]]) return;
    
    MSPlayer *player = (MSPlayer *)self.source;
    
    self.playerNameLabel.text = [player shortNameOrName];
    self.playerPositionLabel.text = [player positionName];
    self.playerNumberLabel.text = [player shirtNumber] ?: @"-";
    self.flagRoundedImageView.image = [UIImage MS_imageFromCountryName:player.countryName];
}

- (UIColor *)positionColor {
    if([self.source isKindOfClass:[MSPlayer class]]) {
    
        MSPlayer *player = (MSPlayer *)self.source;
        
        if ([[player positionNameShort] isEqualToString:@"G"]) {
            return [UIColor orangeColor];
        } else if ([[player positionNameShort] isEqualToString:@"D"]) {
            return [UIColor blueColor];
        } else if ([[player positionNameShort] isEqualToString:@"M"]) {
            return [UIColor colorWithRed:0.0 green:130.0/255.0 blue:0.0 alpha:1.0];
        } else if ([[player positionNameShort] isEqualToString:@"A"]) {
            return [UIColor redColor];
        }
    }
    return [UIColor blackColor];
}

@end
