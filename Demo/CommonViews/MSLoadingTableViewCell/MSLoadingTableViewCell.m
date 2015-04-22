//
//  MSLoadingTableViewCell.m
//  FlagRecognition
//
//  Created by Viktor Levschanov on 24.03.14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import "MSLoadingTableViewCell.h"

static NSString * const kAnimationKey = @"rotation";

@interface MSLoadingTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MSLoadingTableViewCell

@synthesize imageView = _imageView;

+ (CGFloat)cellHeight {
    return 60;
}

+ (NSString *)MS_reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self.contentView setNeedsLayout];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.contentView setNeedsLayout];
}

- (void)startAnimating {
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue   = @0.0;
    rotation.toValue     = @(2.0 * M_PI);
    rotation.duration    = 1.5;
    rotation.repeatCount = FLT_MAX; // Repeat forever.
    [self.imageView.layer addAnimation:rotation forKey:kAnimationKey];
}

- (void)stopAnimating {
    [self.imageView.layer removeAnimationForKey:kAnimationKey];
}

@end
