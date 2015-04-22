//
//  MSNavigationController.m
//  FlagRecognition
//
//  Created by Vyacheslav Nechiporenko on 10/25/13.
//  Copyright (c) 2013 Moodstocks. All rights reserved.
//

#import "MSNavigationController.h"
#import "MSTeamDetailsViewController.h"
#import "MSLeagueDetailsViewController.h"
#import "MSNavigationControllerAnimation.h"
#import "MSNavigationControllerOrientation.h"
#import "UIImage+MSUtils.h"
#import "Flurry.h"

///fake view controller that pops out as soon as it's added to the controllers stack and causing a previous controller to update its orientation
@interface MSFakeViewController : UIViewController

@end

@implementation MSFakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController popViewControllerAnimated:NO];
}

@end

@implementation MSNavigationController

- (void)setDefaultColorScheme {
    
    if (!self.colorScheme){
        self.colorScheme = [MSColorScheme sharedInstance];
    }
    
    [self.navigationBar setTitleTextAttributes:@{
                                                NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Bold" size:15.0f],
                                                NSForegroundColorAttributeName: self.colorScheme.textColor,
                                                }];
    self.navigationBar.barTintColor = self.colorScheme.mainColor;
    self.navigationBar.tintColor = self.colorScheme.textColor;

}


-(void)updateColorScheme:(MSColorScheme*)newColorScheme
{
    self.colorScheme = newColorScheme;
    self.navigationBar.barTintColor = self.colorScheme.mainColor;
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.09){
        self.navigationBar.translucent = NO;
    }
    self.navigationBar.tintColor = self.colorScheme.textColor;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : self.colorScheme.textColor};
}



- (void)viewDidLoad {
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setDefaultColorScheme];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    if([self.topViewController respondsToSelector:@selector(popAnimation)]) {
        CAAnimation *animation = [(id<MSNavigationControllerAnimation>)self.topViewController popAnimation];
        assert(animation);
        [self.view.layer addAnimation:animation forKey:kCATransition];
        return [super popToRootViewControllerAnimated:NO];
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *poppedController;
    
    if([self.topViewController respondsToSelector:@selector(popAnimation)]) {
        CAAnimation *animation = [(id<MSNavigationControllerAnimation>)self.topViewController popAnimation];
        assert(animation);
        [self.view.layer addAnimation:animation forKey:kCATransition];

        poppedController = [super popViewControllerAnimated:NO];
    }
    else {
        poppedController = [super popViewControllerAnimated:animated];
    }
    
    
    
    return poppedController;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if([self shouldCorrectOrientationForController:viewController]) {
        //a hack to restore view controller orientation to preferred value
        [self pushViewControllerCorrectingOrientation:viewController];
        //[super pushViewController:viewController animated:NO];
    }
    else {
        [super pushViewController:viewController animated:animated];
    }
}

#pragma mark - Device Orientations

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (BOOL)shouldCorrectOrientationForController:(UIViewController *)viewController {
    return ([viewController respondsToSelector:@selector(shouldCorrectInterfaceOrientation)] &&
            [(id<MSNavigationControllerOrientation>)viewController shouldCorrectInterfaceOrientation] &&
            self.interfaceOrientation != viewController.preferredInterfaceOrientationForPresentation);
}

- (void)pushViewControllerCorrectingOrientation:(UIViewController *)viewController {
    //create snapshot of the current screen
    UIWindow *w = [[UIApplication sharedApplication] keyWindow];
    UIImageView *snapshot = [[UIImageView alloc] initWithImage:[UIImage MS_imageFromView:w]];
    
    [super pushViewController:viewController animated:NO];
    
    //hide incorrect start of the shown screen with the snapshot of previous screen
    [w addSubview:snapshot];
    
    //separate controllers stack changes in different runloops to avoid appearance transition conflicts
    dispatch_async(dispatch_get_main_queue(), ^{
        [self restoreOrientationToPreferredValue];
        //remove snapshot
        [snapshot removeFromSuperview];
    });
}

- (void)restoreOrientationToPreferredValue {
    DLog(@"");
    //push fake controller that will pop immediately and cause orientation update of the given view controller
    MSFakeViewController *vc = [[MSFakeViewController alloc] initWithNibName:nil bundle:nil];
    [self pushViewController:vc animated:NO];
}

- (void)correctCurrentViewControllerOrientationIfNedded {
    UIViewController *vc = self.topViewController;
    if(vc.interfaceOrientation != vc.preferredInterfaceOrientationForPresentation) {
        [self restoreOrientationToPreferredValue];
    }
}

@end
