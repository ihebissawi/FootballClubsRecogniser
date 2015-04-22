//
//  MSLeagueCollectionViewCell.h
//  FlagRecognition
//
//  Created by Viktor Levschanov on 17.03.14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSLeague;

@interface MSLeagueCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak, readonly) MSLeague *league;
@property (nonatomic, weak, readonly) UIImageView *leagueImageView;


+ (UINib *)loadNib;
+ (NSString *)reuseIdentifier;

- (void)setupWithLeague:(MSLeague *)league;

@end
