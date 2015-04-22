//
//  UIViewController+MSNavigationItem.m
//  FlagRecognition
//
//  Created by Lexiren on 2/7/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "UIViewController+MSNavigationItem.h"

@implementation UIViewController (MSNavigationItem)

- (void)showRightScanBarButton:(BOOL)showRightScanBarButton {
    if (showRightScanBarButton) {
        self.navigationItem.rightBarButtonItem = [self rightScanBarButtonItem];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }

}

//TODO:delete this if not needed
- (UIBarButtonItem *)rightScanBarButtonItem {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                         target:self
                                                         action:@selector(scanButtonDidPress:)];
}

- (IBAction)scanButtonDidPress:(id)sender
{
    [UIAlertView MS_showComingSoonAlert];
}

@end
