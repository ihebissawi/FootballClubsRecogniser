//
//  UIViewController+MSActivityIndicator.m
//  FlagRecognition
//
//  Created by Lexiren on 2/7/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "UIViewController+MSActivityIndicator.h"
#import "UIView+MSNib.h"
#import "MSCommonDefines.h"

@implementation UIViewController (MSActivityIndicator) 

- (void)showActivityView {
    [self showActivityViewWithCancelButtonHidden:NO cancelAction:nil];
}

- (void)showActivityViewWithCancelButtonHidden:(BOOL)cancelHidden
                                  cancelAction:(SEL)cancelAction
{
    CGRect defaultFrame = self.view.bounds;

    [self showActivityViewWithText:nil
                cancelButtonHidden:cancelHidden
                             frame:defaultFrame
                      cancelAction:cancelAction];
}

- (void)showActivityViewWithText:(NSString *)text
              cancelButtonHidden:(BOOL)cancelHidden
                           frame:(CGRect)frame
                    cancelAction:(SEL)cancelAction
{
    [self hideActivityView]; //hide activity view if one has been already presented
    MSActivityIndicatorView *activityView = [MSActivityIndicatorView MS_loadViewFromNIBWithFrame:frame];
    activityView.cancelButton.hidden = cancelHidden;
    if (text)    activityView.messageLabel.text = text;
    if (!cancelAction) cancelAction = @selector(didTapCancelActivityIndicatorViewDefaultAction:);
    [activityView.cancelButton addTarget:self
                                  action:cancelAction
                        forControlEvents:UIControlEventTouchUpInside];
    
//    if ([self isKindOfClass:[UITableViewController class]]) {
//        [((UITableViewController *)self).navigationController.view addSubview:activityView];
//        [((UITableViewController *)self).navigationController.view bringSubviewToFront:activityView];
//    } else {
        [self.view addSubview:activityView];
    [self.view bringSubviewToFront:activityView];
//    }
}

- (void)hideActivityView {
    NSArray *subviews = nil;
//    if ([self isKindOfClass:[UITableViewController class]]) {
//        subviews = [((UITableViewController *)self).navigationController.view subviews];
//    } else {
        subviews = self.view.subviews;
//    }
    
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[MSActivityIndicatorView class]]) {
            [subview removeFromSuperview];
        }
    }
}

#pragma mark - MSActivityIndicatorViewDelegate
- (void)didTapCancelActivityIndicatorViewDefaultAction:(id)sender {
    [self hideActivityView];
}

@end
