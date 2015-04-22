//
//  MSRoundedImage.m
//  FlagRecognition
//
//  Created by Igor Litvinenko on 12/16/14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import "MSRoundedImageView.h"
#import "UIImageView+AFNetworking.h"

@implementation MSRoundedImageView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self initialize];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initialize];
    }
    return self;
}

- (void) initialize{
    self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2;
    self.layer.masksToBounds = YES;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 4, 4)];
    _imageView.autoresizingMask = UIViewAutoresizingNone;
    _imageView.layer.masksToBounds = YES;
    [self addSubview:self.imageView];
    
    [self setupDefaultValues];
}

- (void) setupDefaultValues{
    self.borderColor = [UIColor colorWithWhite:92.0f/255.0f alpha:1];
    self.borderWidth = 2;
    self.backgroundColor = [UIColor colorWithWhite:255.0f/255.0f alpha:1];
}

- (void) setImage:(UIImage *)image{
    self.imageView.hidden = image == nil;
    
    if (image && !self.disableImageSizeAdjusting){
        CGSize originalSize = image.size;
        CGFloat circumscribedСircleRadius = sqrtf(originalSize.width * originalSize.width + originalSize.height * originalSize.height) / 2;
        CGFloat currentRadius = CGRectGetWidth(self.bounds) / 2;
        CGFloat scaleCoef = currentRadius / circumscribedСircleRadius;
        
        CGRect imageViewFrame = self.imageView.frame;
        imageViewFrame.size = CGSizeMake(originalSize.width * scaleCoef - 2, originalSize.height * scaleCoef - 2);
        imageViewFrame.origin = CGPointMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(imageViewFrame)) / 2, (CGRectGetHeight(self.bounds) - CGRectGetHeight(imageViewFrame)) / 2);
        self.imageView.frame = imageViewFrame;
    }
    
    self.imageView.image = image;
}

- (UIImage *)image{
    return self.imageView.image;
}

- (void)cancelLoadingImage{
    [self.imageView cancelImageRequestOperation];
}

- (void) setImageWithUrlPath:(NSString *)urlPath{
    __weak MSRoundedImageView * weakSelf = self;
    [self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlPath]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [weakSelf setImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        DLog(@"Rounded image error %@", error.localizedDescription);
    }];
}

- (void) setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat) borderWidth{
    return self.layer.borderWidth;
}

- (void) setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *) borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

@end
