//
//  MSTodayTableViewCell.m
//  FlagRecognition
//
//  Created by Alexander Peresadchenko on 4/6/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import "MSTodayTableViewCell.h"
#import  <QuartzCore/QuartzCore.h>

#import "MSMatch.h"
#import "MSTeam.h"

@interface MSTodayTableViewCell()

@property (nonatomic,weak) IBOutlet UIView *ongoingMatchIndicator;
@property (nonatomic,weak) IBOutlet UILabel *teamHomeLabel;
@property (nonatomic,weak) IBOutlet UILabel *teamAwayLabel;
@property (nonatomic,weak) IBOutlet UILabel *vsLabel;
@property (nonatomic,weak) IBOutlet UILabel *matchTime;
@property (nonatomic,weak) IBOutlet UILabel *scoreLabel;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *teamHomeWidthConstraint;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *teamAwayWidthConstraint;

@end

@implementation MSTodayTableViewCell


-(void)awakeFromNib
{
	self.ongoingMatchIndicator.layer.cornerRadius = floor(self.ongoingMatchIndicator.bounds.size.width / 2.0);
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	
	CGFloat maxNamesWidth = self.matchTime.hidden ?
	self.scoreLabel.frame.origin.x - self.teamHomeLabel.frame.origin.x - self.vsLabel.frame.size.width - 10.0:
	self.matchTime.frame.origin.x - self.teamHomeLabel.frame.origin.x - self.vsLabel.frame.size.width - 10.0;
	
	CGFloat teamHomeWidth = [self.teamHomeLabel sizeThatFits:self.bounds.size].width;
	CGFloat teamAwayWidth = [self.teamAwayLabel sizeThatFits:self.bounds.size].width;
	if (teamHomeWidth + teamAwayWidth > maxNamesWidth)
	{
		CGFloat halfMaxNameWidth = floor(maxNamesWidth / 2.0);
		if (teamHomeWidth < halfMaxNameWidth)
		{
			self.teamHomeWidthConstraint.constant = teamHomeWidth;
			self.teamAwayWidthConstraint.constant = maxNamesWidth - teamHomeWidth;
		}
		else if (teamAwayWidth < halfMaxNameWidth)
		{
			self.teamHomeWidthConstraint.constant = maxNamesWidth - teamAwayWidth;
			self.teamAwayWidthConstraint.constant = teamAwayWidth;
		}
		else
		{
			self.teamHomeWidthConstraint.constant = halfMaxNameWidth;
			self.teamAwayWidthConstraint.constant = halfMaxNameWidth;
		}
	}
	else
	{
		self.teamHomeWidthConstraint.constant = teamHomeWidth;
		self.teamAwayWidthConstraint.constant = teamAwayWidth;
	}
}

#pragma mark  - Setters

-(void)setMatch:(MSMatch *)match
{
 	self.ongoingMatchIndicator.hidden = !match.notFinished;
//	if (match.notFinished)
//	{
		NSUInteger minutes = floor(fabs([match.date timeIntervalSinceNow] / 60.0));
//		if (minutes < 180)
//		{
			self.matchTime.text = [NSString stringWithFormat:@"%ld'",minutes];
			self.matchTime.hidden = NO;
//		}
//		else
//			self.matchTime.hidden = YES;
//	}
//	else
//		self.matchTime.hidden = YES;

	NSString *teamHomeName = match.teamHome.shortName;
	if (teamHomeName == nil)
		teamHomeName = match.teamHomeName;
	self.teamHomeLabel.text = teamHomeName;
	NSString *teamAwayName = match.teamAway.shortName;
	if (teamAwayName == nil)
		teamAwayName = match.teamAwayName;
	self.teamAwayLabel.text = teamAwayName;

	self.scoreLabel.text = [match.score stringByReplacingOccurrencesOfString:@"-" withString:@":"];
	
	[self setNeedsLayout];
}

@end