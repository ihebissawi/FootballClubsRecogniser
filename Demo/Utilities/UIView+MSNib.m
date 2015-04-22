//
//  UIView+MSNib.m
//  FlagRecognition
//
//  Created by Lexiren on 2/7/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "UIView+MSNib.h"

@implementation UIView (MSNib)

#pragma mark - public
+ (id)MS_loadViewFromNIB {
    NSString *nibName = NSStringFromClass([self class]);
    return [self loadViewFromMSNIBWithName:nibName];
}

+ (id)MS_loadViewFromNIBWithFrame:(CGRect)frame {
    id view = [self MS_loadViewFromNIB];
    [view setFrame:frame];
//    [view layoutIfNeeded];
    return view;
}

#pragma mark - private
+ (id)loadViewFromMSNIBWithName:(NSString *)name {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:name
                                                         owner:nil
                                                       options:nil];
    
    for (UIView *view in nibContents) {
        if ([view isKindOfClass:[self class]]) {
            return view;
        }
    }
    NSAssert(NO, @"Attempt to load view from wrong or corrupted NIB");
    return nil;
}

@end
