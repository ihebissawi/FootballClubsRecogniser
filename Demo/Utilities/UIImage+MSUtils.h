//
//  MSBaseDataViewController.h
//  FlagRecognition
//
//  Created by Viktor Levschanov on 18.03.14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MSUtils)

+ (UIImage *)MS_imageFromView:(UIView *)view;
+ (UIImage *)MS_shirtImageWithColor:(UIColor *)color fromImage: (UIImage *) image;
+ (UIImage *)MS_imageFromCountryName: (NSString *) countryName;

@end
