//
//  MSNavigationController.h
//  FlagRecognition
//
//  Created by Vyacheslav Nechiporenko on 10/25/13.
//  Copyright (c) 2013 Moodstocks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSColorScheme.h"
@interface MSNavigationController : UINavigationController


@property (nonatomic, strong)  MSColorScheme * colorScheme;

- (void)setDefaultColorScheme;

- (void)correctCurrentViewControllerOrientationIfNedded;
-(void)updateColorScheme:(MSColorScheme*)newColorScheme;
@end
