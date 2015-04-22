//
//  MSBaseDataViewController.h
//  FlagRecognition
//
//  Created by Viktor Levschanov on 18.03.14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSTabBarController.h"

@interface MSBaseDataViewController : UIViewController

@property (nonatomic, strong) NSArray *contentArray;

@property (nonatomic, strong, readonly) MSDataManager *dataManager;

@property (nonatomic, readonly) BOOL isViewJustLoaded;
@property (nonatomic, readonly) MSTabBarController * customTabbarController;

- (void)completeSettingContentArrayWithArray:(NSArray *)array success:(BOOL)isSuccessUpdate error:(NSError *)error;

//methods for overwriting
- (void)reloadUI;
- (void)loadContentArray;
- (void)refreshContentArray;

@end
