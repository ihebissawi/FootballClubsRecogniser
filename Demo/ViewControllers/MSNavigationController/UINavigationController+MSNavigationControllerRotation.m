//
//  UINavigationController+MSNavigationControllerRotation.m
//  FlagRecognition
//
//  Created by Michael Murnik on 12/26/14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import "UINavigationController+MSNavigationControllerRotation.h"

@implementation UINavigationController (MSNavigationControllerRotation)

-(BOOL)shouldAutorotate {
    return [[self.viewControllers lastObject] shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
