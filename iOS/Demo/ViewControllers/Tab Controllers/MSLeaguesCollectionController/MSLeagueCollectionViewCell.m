//
//  MSLeagueCollectionViewCell.m
//  FlagRecognition
//
//  Created by Viktor Levschanov on 17.03.14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import "MSLeagueCollectionViewCell.h"
#import "MSLeague.h"

@interface MSLeagueCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property (nonatomic, weak) MSLeague *league;

@end

@implementation MSLeagueCollectionViewCell

+ (UINib *)loadNib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (NSString *)reuseIdentifier {
    return [self.class reuseIdentifier];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
#pragma mark -

- (UIImageView *)leagueImageView {
    return self.imageView;
}

- (void)setupWithLeague:(MSLeague *)league {
    self.league = league;
    

    [self.imageView setImage: [league leagueImage]];
    self.imageView.layer.cornerRadius = 10.0;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, [league leagueImage].size.width, [league leagueImage].size.height);



}

@end
