//
//  MSLeagueRatingCell.m
//  FlagRecognition
//
//  Created by Lexiren on 2/13/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#define kMSAdditionalViewPortraitWidth 0
#define kMSAdditionalViewLandscapeWidth 172

#import "MSLeagueRatingCell.h"
#import "MSLeagueTeamResult.h"



@interface MSLeagueRatingCell ()

@property (weak, nonatomic) IBOutlet UILabel *posLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gpLabel;
@property (weak, nonatomic) IBOutlet UILabel *ptsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *additionalInfoViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *wLabel;
@property (weak, nonatomic) IBOutlet UILabel *dLabel;
@property (weak, nonatomic) IBOutlet UILabel *lLabel;
@property (weak, nonatomic) IBOutlet UILabel *gaLabel;
@property (weak, nonatomic) IBOutlet UILabel *gfLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;

@end


@implementation MSLeagueRatingCell

+ (NSString *)MS_reuseIdentifier {
    return @"LeagueRatingCellIdentifier";
}

+ (CGFloat)cellHeight {
    static CGFloat _cellHeight = 0.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MSLeagueRatingCell *tempCell = [MSLeagueRatingCell MS_loadViewFromNIB];
        _cellHeight = tempCell.bounds.size.height;
    });
    
    return _cellHeight;
}

- (void)updateUI {
    if (![self.source isKindOfClass:[MSLeagueTeamResult class]]) return;
    
    MSLeagueTeamResult *result = (MSLeagueTeamResult *)self.source;

    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.additionalInfoViewWidth.constant = kMSAdditionalViewLandscapeWidth;
        self.wLabel.text = result.win;
        self.dLabel.text = result.draw;
        self.lLabel.text = result.loose;
        self.gfLabel.text = result.goalsFor;
        self.gaLabel.text = result.goalsAgainst;
    } else {
        self.additionalInfoViewWidth.constant = kMSAdditionalViewPortraitWidth;
    }
    
    self.gpLabel.text = result.played;
    self.ptsLabel.text = result.pts;
    self.posLabel.text = [result.position stringValue];
    self.teamNameLabel.text = result.teamName;
    
    UIColor * textColor = [result.teamID isEqualToString:self.userTeamID] ? self.colorScheme.textColorSelected : [UIColor blackColor];
    self.gpLabel.textColor = self.ptsLabel.textColor = self.posLabel.textColor = self.teamNameLabel.textColor = textColor;
    
    if ([result.teamID isEqualToString:self.userTeamID]){
        self.backgroundColor = self.colorScheme.backColor;
    }
    
    
    
    [self.wLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.dLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.lLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.gfLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.gaLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    
    
    [self.gpLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.ptsLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:12.0f]];
    [self.posLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.teamNameLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:12.0f]];

    
    [self.teamNameLabel setNeedsLayout];
    [self.teamNameLabel setNeedsDisplay];
}

-(void)setSelected:(BOOL)selected
{
    self.gpLabel.highlightedTextColor = [UIColor whiteColor];
    self.ptsLabel.highlightedTextColor = [UIColor whiteColor];
    self.posLabel.highlightedTextColor = [UIColor whiteColor];
    self.teamNameLabel.highlightedTextColor = [UIColor whiteColor];

}


@end
