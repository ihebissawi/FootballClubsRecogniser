//
//  UIColor+MSCustomization.h
//  FlagRecognition
//
//  Created by Lexiren on 2/10/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MSCustomization)

- (UIColor *)MS_darkerColor;
- (UIColor *)MS_lighterColor;
- (UIImage *)MS_pixelImage;
+ (UIColor *)MS_imageAverageColor:(UIImage *)image;

- (UIColor *)MS_validatedColor;

@end
