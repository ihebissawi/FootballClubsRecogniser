//
//  MSTeamTableViewCell.m
//  FlagRecognition
//
//  Created by Alexander Peresadchenko on 3/18/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import "MSTeamTableViewCell.h"

@interface MSTeamTableViewCell ()
@property (nonatomic,weak) IBOutlet UIButton *favoritesButton;
@end

@implementation MSTeamTableViewCell

-(IBAction)favoritesTapAction:(UIButton*)button
{
	self.viewObject.checked = !self.viewObject.checked;
	self.favoritesButton.selected = self.viewObject.checked;
	[self.delegate teamTableViewCell:self setFavoritesState:self.viewObject.checked];
}

-(void)updateUI
{
	[super updateUI];
	self.favoritesButton.selected = self.viewObject.checked;
}

@end
