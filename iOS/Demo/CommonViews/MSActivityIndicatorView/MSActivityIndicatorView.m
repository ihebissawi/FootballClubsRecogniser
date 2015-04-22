//
//  MSActivityIndicatorView.m
//  FlagRecognition
//
//  Created by Lexiren on 2/7/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "MSActivityIndicatorView.h"

#define kMSActivityAnimationBaseImageName @"foto240x320_"
#define kMSActivityAnimationImagesCount 47

@interface MSActivityIndicatorView()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MSActivityIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    self.imageView.animationImages = [self loadAnimationImages];
    self.imageView.animationDuration = 5.0f;
    [self.imageView startAnimating];
}

- (NSArray *)loadAnimationImages {
    NSMutableArray *imagesM = [NSMutableArray array];
    for (int i = 0; i < kMSActivityAnimationImagesCount; ++i) {
        NSString *imageName = [NSString stringWithFormat:@"%@%d.jpg",kMSActivityAnimationBaseImageName, i];
        UIImage *image = [UIImage imageNamed:imageName];
        [imagesM addObject:image];
    }
    return imagesM;
}

@end
