//
//  UIAlertView+MSExtensions.h
//  FlagRecognition
//
//  Created by Lexiren on 2/12/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (MSExtensions)

+ (void)MS_showComingSoonAlert;
+ (void)MS_showErrorAlertWithMessage:(NSString *)message;
+ (void)MS_showErrorAlertWithError:(NSError *)error;
+ (void)MS_showSimpleAlertWithTitle:(NSString *)title;
+ (void)MS_showSimpleAlertWithMessage:(NSString *)message;
+ (void)MS_showSimpleAlertWithTitle:(NSString *)title message:(NSString *)message;
+ (void)MS_showAlertWithTitle:(NSString *)title message:(NSString *)message andCancelButton:(NSString *)buttonTitle;

@end
