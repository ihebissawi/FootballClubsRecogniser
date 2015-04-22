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
	UIColor *color = match.notFinished ? [UIColor redColor] : [UIColor lightGrayColor];
	[self.stateGroup setBackgroundColor:color];
	

	if (match.teamHome.shortName != nil && match.teamHome.shortName.length > 0)
		[self.teamHomeLabel setText:match.teamHome.shortName];
	else
		[self.teamHomeLabel setText:match.teamHomeName];
		
	if (match.teamAway.shortName != nil && match.teamAway.shortName.length > 0)
		[self.teamAwayLabel setText:match.teamAway.shortName];
	else
		[self.teamAwayLabel setText:match.teamAwayName];

	if (match.notFinished)
	{
		NSUInteger minutes = floor(fabs([match.date timeIntervalSinceNow] / 60.0));
		if (minutes < 180)
		{
			self.timeLabel.text = [NSString stringWithFormat:@"%ld'",minutes];
			self.timeLabel.hidden = NO;
		}
		else
			self.timeLabel.hidden = YES;
	}
	else
		self.timeLabel.hidden = YES;
}

@end