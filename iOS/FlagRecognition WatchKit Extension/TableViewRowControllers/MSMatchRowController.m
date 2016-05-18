//
//  MSMatchRowController.m
//  FlagRecognition
//
//  Created by Alexander Peresadchenko on 4/2/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import "MSMatchRowController.h"

#import "MSMatch.h"
#import "MSTeam.h"

@interface MSMatchRowController ()

@property (nonatomic,weak) IBOutlet WKInterfaceGroup *stateGroup;
@property (nonatomic,weak) IBOutlet WKInterfaceLabel *teamHomeLabel;
@property (nonatomic,weak) IBOutlet WKInterfaceLabel *teamAwayLabel;
@property (nonatomic,weak) IBOutlet WKInterfaceLabel *timeLabel;

@end

@implementation MSMatchRowController

-(void)setMatch:(MSMatch *)match
{
	UIColor *color = [match.matchStatus isEqualToString:@"live"] ? [UIColor redColor] : [UIColor lightGrayColor];
	[self.stateGroup setBackgroundColor:color];
	
    [self.teamHomeLabel setText:[match.teamHome shortNameOrName]];
    [self.teamAwayLabel setText:[match.teamAway shortNameOrName]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM"];
    NSString * formattedDateString = [dateFormatter stringFromDate:match.date];
    self.timeLabel.text = formattedDateString;
    /*
	if (match.notFinished)
	{
		NSUInteger minutes = floor(fabs([match.date timeIntervalSinceNow] / 60.0));
		if (minutes < 180)
		{
			self.timeLabel.text = [NSString stringWithFormat:@"%ld'",minutes];
			self.timeLabel.hidden = NO;
		}
        else{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd MMM"];
            NSString * formattedDateString = [dateFormatter stringFromDate:match.date];
            self.timeLabel.text = formattedDateString;
        }
	}
	else
		self.timeLabel.hidden = YES;
     */
}

@end