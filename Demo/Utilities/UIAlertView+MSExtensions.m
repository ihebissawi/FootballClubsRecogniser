//
//  UIAlertView+MSExtensions.m
//  FlagRecognition
//
//  Created by Lexiren on 2/12/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "UIAlertView+MSExtensions.h"

@implementation UIAlertView (MSExtensions)

+ (void)MS_showAlertWithTitle:(NSString *)title message:(NSString *)message andCancelButton:(NSString *)buttonTitle {
    performBlockOnMaintMainThread(^{
        [[[UIAlertView alloc] initWithTitle:title
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:buttonTitle
                          otherButtonTitles:nil] show];
    });
}

+ (void)MS_showSimpleAlertWithTitle:(NSString *)title message:(NSString *)message {
    [self MS_showAlertWithTitle:title message:message andCancelButton:@"OK"];
}

+ (void)MS_showSimpleAlertWithTitle:(NSString *)title {
    [UIAlertView MS_showSimpleAlertWithTitle:title message:nil];
}

+ (void)MS_showSimpleAlertWithMessage:(NSString *)message {
    [UIAlertView MS_showSimpleAlertWithTitle:nil message:message];
}

+ (void)MS_showErrorAlertWithMessage:(NSString *)message {
    [UIAlertView MS_showSimpleAlertWithTitle:@"Error"
                                     message:message];
}

+ (void)MS_showComingSoonAlert {
    [UIAlertView MS_showSimpleAlertWithTitle:@"Under development." message:nil];
}

+ (void)MS_showErrorAlertWithError:(NSError *)error
{
    [UIAlertView MS_showErrorAlertWithMessage:[error localizedDescription]];
}

@end
