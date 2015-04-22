//
//  MSLeagueTableHeaderView.h
//  FlagRecognition
//
//  Created by Lexiren on 2/17/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLeagueTableHeaderView : UIView

- (void)updateUI;
+ (CGFloat)viewDefaultHeight;
@property(nonatomic) BOOL isForTeam;
@end
