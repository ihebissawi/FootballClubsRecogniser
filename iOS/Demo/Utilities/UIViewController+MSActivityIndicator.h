//
//  UIViewController+MSActivityIndicator.h
//  FlagRecognition
//
//  Created by Lexiren on 2/7/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSActivityIndicatorView.h"

@interface UIViewController (MSActivityIndicator)

- (void)showActivityView;
- (void)showActivityViewWithCancelButtonHidden:(BOOL)cancelHidden
                                  cancelAction:(SEL)cancelAction;
- (void)showActivityViewWithText:(NSString *)text
              cancelButtonHidden:(BOOL)cancelHidden
                           frame:(CGRect)frame
                    cancelAction:(SEL)cancelAction;

- (void)hideActivityView;

@end
