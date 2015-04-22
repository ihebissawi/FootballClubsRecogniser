//
//  MSMatchCell.m
//  FlagRecognition
//
//  Created by Lexiren on 2/12/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "MSMatchCell.h"
#import "MSMatch.h"
#import "MSTeam.h"
#import "NSDate+MSExtensions.h"
#import "MSColorScheme.h"
@interface MSMatchCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeLeagueLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamLeagueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *homeTeamDigitsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *awayTeamDigitImageView;

@end

@implementation MSMatchCell

+ (NSString *)MS_reuseIdentifier {
    return @"MatchCellIdentifier";
}

+ (CGFloat)cellHeight {
    static CGFloat _cellHeight = 0.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MSMatchCell *tempCell = [MSMatchCell MS_loadViewFromNIB];
        _cellHeight = tempCell.bounds.size.height;
    });
    
    return _cellHeight;
}

- (void)awakeFromNib{
    self.homeTeamLabel.font = self.awayTeamLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:14];
    self.homeLeagueLabel.font = self.awayTeamLeagueLabel.font = [UIFont fontWithName:@"OpenSans" size:12];

    self.dateLabel.font = [UIFont fontWithName:@"OpenSans" size:10];
    self.scoreLabel.font = [UIFont fontWithName:@"OpenSans" size:24];
}

- (NSString *)shortNameForTeamWithID:(NSString *)teamID {
    NSString *result = nil;
    if (teamID.length) {
        MSTeam *team = [MSTeam MR_findFirstByAttribute:@"iD" withValue:teamID];
        result = [team shortNameOrName];
    }
    return result;
}

- (void)updateUI {
    if (![self.source isKindOfClass:[MSMatch class]]) return;
    
    MSMatch *match = (MSMatch *)self.source;
    
    NSDate *matchDate = [match date];
    self.dateLabel.text = stringFromDate(matchDate, @"dd.MM.yy, HH:mm");
    
    MSMatchID *sourceId = [match objectID];

    __weak MSMatchCell *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MSMatchCell *strongSelf = weakSelf;
        if(!strongSelf) return;

        NSError *error;
        MSMatch *match = (MSMatch *)[[NSManagedObjectContext MR_contextForCurrentThread] existingObjectWithID:sourceId error:&error];
        if(!match || error) {
            DLog(@"%@", error);
            return;
        }
        NSString *home = [strongSelf shortNameForTeamWithID:match.teamHomeID] ?: match.teamHomeName;
        
        NSString *away = [strongSelf shortNameForTeamWithID:match.teamAwayID] ?: match.teamAwayName;
        if([self.teamId isEqualToString:match.teamHomeID])
        {
            self.homeTeamLabel.textColor = [MSColorScheme sharedInstance].mainColor;
            self.awayTeamLabel.textColor = [UIColor blackColor];
        }
        else
        {
            self.awayTeamLabel.textColor = [MSColorScheme sharedInstance].mainColor;
            self.homeTeamLabel.textColor = [UIColor blackColor];
        }
        dispatch_async(dispatch_get_main_queue(), ^{

            strongSelf.homeTeamLabel.text = home;
            strongSelf.awayTeamLabel.text = away;
            strongSelf.homeLeagueLabel.text = strongSelf.awayTeamLeagueLabel.text = match.leagueName;
        });
    });
 
    if ([match notFinished]) {
        self.scoreLabel.text = @"-    -";
    } else {
        self.scoreLabel.text = match.score ? [match.score stringByReplacingOccurrencesOfString:@"-" withString:@""] : @"N  A";
    }
    
    if ([self.scoreLabel.text rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location == NSNotFound){
        self.homeTeamDigitsImageView.hidden = NO;
        self.awayTeamDigitImageView.hidden = NO;
        self.scoreLabel.textColor = [UIColor whiteColor];
    } else {
        self.homeTeamDigitsImageView.hidden = YES;
        self.awayTeamDigitImageView.hidden = YES;
        self.scoreLabel.textColor = [UIColor blackColor];
        self.scoreLabel.text = [self.scoreLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }

    [self.scoreLabel sizeToFit];
    [self.scoreLabel layoutIfNeeded];
}

- (IBAction)didTapAwayButton:(id)sender {
    performButtonHandleBlockWithData(self.didTapTeamInfoButton, sender, ((MSMatch *)self.source).teamAwayID);
}

- (IBAction)didTapHomeButton:(id)sender {
    performButtonHandleBlockWithData(self.didTapTeamInfoButton, sender, ((MSMatch *)self.source).teamHomeID);
}

@end
