//
//  MSBaseDataViewController.m
//  FlagRecognition
//
//  Created by Viktor Levschanov on 18.03.14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import "MSBaseDataViewController.h"
#import "MSCommonDefines.h"
#import <Availability.h>

#define kMSParallaxBoundValue 30

@interface MSBaseDataViewController () 

@end

@implementation MSBaseDataViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
    

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)reloadData {
    // Do any additional setup after loading the view.
    if (![[self.dataManager settings] currentCountry]) {
        [self showActivityViewWithCancelButtonHidden:YES cancelAction:nil];
        [self.dataManager requestSettingsCurrentCountryWithCompletion:^(BOOL success, NSError *error) {
            [self hideActivityView];
            if (success) {
                [self loadContentArray];
            } else {
                [UIAlertView MS_showErrorAlertWithError:error];
            }
        }];
    } else {
        [self loadContentArray];
    }
}

#pragma mark - lazy initialization

- (MSDataManager *)dataManager {
    return [MSDataManager sharedManager];
}

- (MSTabBarController *)customTabbarController{
    return (MSTabBarController *) self.tabBarController;
}

#pragma mark - Public

- (void)completeSettingContentArrayWithArray:(NSArray *)array success:(BOOL)isSuccessUpdate error:(NSError *)error
{
    if (isSuccessUpdate) {
        self.contentArray = array;
        [self reloadUI];
    } else {
        [UIAlertView MS_showErrorAlertWithError:error];
    }
}


#pragma mark - Rotation

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


#pragma mark - Override

- (void)reloadUI {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)loadContentArray {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)refreshContentArray {
    [self doesNotRecognizeSelector:_cmd];
}


@end
