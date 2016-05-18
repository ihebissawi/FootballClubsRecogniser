//
//  MSTabBarController.m
//  FlagRecognition
//
//  Created by Vyacheslav Nechiporenko on 10/25/13.
//  Copyright (c) 2013 Moodstocks. All rights reserved.
//

#import "MSTabBarController.h"
#import "MSNavigationController.h"
#import <objc/message.h>

@interface MSTabBarController () <UITabBarControllerDelegate>

@property (nonatomic, strong) UIView * strokeView;

@end

@implementation MSTabBarController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        self.delegate = self;
        CGFloat itemSize = CGRectGetWidth([UIScreen mainScreen].bounds) / (CGFloat)self.viewControllers.count;
        self.strokeView = [[UIView alloc] initWithFrame:CGRectMake(0, -3, itemSize, 3)];
        self.strokeView.backgroundColor = [UIColor clearColor];
        [self.tabBar addSubview:self.strokeView];
        
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:10.0f],
                                                            } forState:UIControlStateSelected];
        
        
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:10.0f],
                                                            } forState:UIControlStateNormal];
        
        
    }
    return self;
}

#pragma mark - Properties

- (void)setColorScheme:(MSColorScheme *)colorScheme{
    _colorScheme = colorScheme;
    

    //self.tabBar.layer.borderWidth = 0.0;
    [self.tabBar setBackgroundImage:[self imageWithColor:_colorScheme.backColor isForBackground:YES]];
    [self.tabBar setSelectionIndicatorImage:[self imageWithColor:_colorScheme.mainColor isForBackground:NO] ];
    self.strokeView.backgroundColor = _colorScheme.semiMainColor;
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    self.tabBar.tintColor = _colorScheme.tabBarColor;
    [(MSNavigationController *)self.selectedViewController updateColorScheme:_colorScheme];
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.09){
        NSLog(@"%f", [UIDevice currentDevice].systemVersion.floatValue);
        NSInteger currentIndex = self.selectedIndex;
        NSInteger newIndex = currentIndex - 1;
        if (newIndex < 0){
            newIndex = currentIndex + 1;
        }
        self.selectedIndex = newIndex;
        self.selectedIndex = currentIndex;
    }
}

#pragma mark - Device orientations

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate
{
    
    [self.tabBar setBackgroundImage:[self imageWithColor:_colorScheme.backColor isForBackground:YES]];
    [self.tabBar setSelectionIndicatorImage:[self imageWithColor:_colorScheme.mainColor isForBackground:NO] ];
    CGFloat itemSize = CGRectGetWidth([UIScreen mainScreen].bounds) / (CGFloat)self.viewControllers.count;
    self.strokeView.frame = CGRectMake(0, -3, itemSize, 3);
//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//    if (UIDeviceOrientationIsLandscape(orientation)) {
        CGFloat originX = itemSize * self.selectedIndex;
        CGRect strokeRange = self.strokeView.frame;
        strokeRange.origin.x = originX;
        self.strokeView.frame = strokeRange;
//    }

    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self changeOrientationIfNeeded];
    
    CGFloat itemSize = CGRectGetWidth([UIScreen mainScreen].bounds) / (CGFloat)self.viewControllers.count;
    
    //self.strokeView.frame = CGRectMake(0, -3, itemSize, 3);
    CGFloat originX = itemSize * self.selectedIndex;
    [UIView animateWithDuration:.2 animations:^{
        CGRect strokeRange = self.strokeView.frame;
        strokeRange.origin.x = originX;
        self.strokeView.frame = strokeRange;
    }];
}

#pragma mark - UITabBarDelegate overwriting

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    //[self setDefaultColorScheme];
}

#pragma mark - pdrivate

- (void)setDefaultColorScheme {
    [(MSNavigationController *)self.selectedViewController updateColorScheme:self.colorScheme];
}

- (void)changeOrientationIfNeeded {
    [(MSNavigationController *)self.selectedViewController correctCurrentViewControllerOrientationIfNedded];
}

- (UIImage *)imageWithColor:(UIColor *)color isForBackground:(BOOL) isBackground  {
    CGRect rect;
    if(isBackground)
    {
         rect = CGRectMake(0.0f, 0.0f, 1, CGRectGetHeight(self.tabBar.bounds));
    }
    else
    {
         rect = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tabBar.bounds)/self.tabBar.items.count, CGRectGetHeight(self.tabBar.bounds));
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)popAllControllers{
    [((MSNavigationController *)self.viewControllers[self.selectedIndex]) popToRootViewControllerAnimated:NO];
}

@end
