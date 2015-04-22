//
//  UIView+MSNib.h
//  FlagRecognition
//
//  Created by Lexiren on 2/7/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MSNib)

+ (id)MS_loadViewFromNIB;
+ (id)MS_loadViewFromNIBWithFrame:(CGRect)frame;

@end
