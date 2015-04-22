//
//  MSDataTableViewCell.m
//  FlagRecognition
//
//  Created by Viktor Levschanov on 24.03.14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import "MSDataTableViewCell.h"
#import "MSSettings.h"
#import "MSRoundedImageView.h"

@interface MSDataTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leagueNameLabel;
@property (weak, nonatomic) IBOutlet MSRoundedImageView *logoBackVIew;

@end

@implementation MSDataTableViewCell

+ (NSString *)MS_reuseIdentifier {
    return NSStringFromClass([self class]);
}

+ (CGFloat)cellHeight{
    return 65.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.teamNameLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:18.0f]];
    [self.leagueNameLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    //self.separatorView.hidden = _separatorHidden;
    
    self.logoBackVIew.borderWidth = 1.5;
    self.logoBackVIew.borderColor = [UIColor colorWithWhite:205.0f/255.0f alpha:1];
    self.logoBackVIew.backgroundColor = [UIColor whiteColor];
}

- (void)setSeparatorHidden:(BOOL)separatorHidden {
    _separatorHidden = separatorHidden;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)prepareForReuse{
    [self.logoBackVIew cancelLoadingImage];
}

- (void) setViewObject:(MSShowableData *)viewObject{
    _viewObject = viewObject;
    [self updateUI];
}

- (void) updateUI{
    self.teamNameLabel.text = self.viewObject.title;
    self.leagueNameLabel.attributedText = self.viewObject.subtitle;
    [self.logoBackVIew setImageWithUrlPath:self.viewObject.imageUrl];
}

@end
