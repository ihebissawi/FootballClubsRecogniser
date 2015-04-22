//
//  MSLeagueDetailsSegue.m
//  FlagRecognition
//
//  Created by Viktor Levschanov on 18.03.14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import "MSLeagueDetailsSegue.h"
#import "MSLeaguesCollectionViewController.h"
#import "MSLeagueDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+MSUtils.h"
#import "MSCommonDefines.h"

@implementation MSLeagueDetailsSegue

- (void)perform {
    MSLeaguesCollectionViewController *srcVC = self.sourceViewController;
    MSLeagueDetailsViewController     *dstVC = self.destinationViewController;
//    
//    UIView *whiteView = [[UIView alloc] initWithFrame:srcVC.view.bounds];
//    whiteView.backgroundColor = [UIColor whiteColor];
//    whiteView.alpha           = 0.0;
//    
//    [srcVC.view addSubview:whiteView];
//    
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.srcRect];
//    imgView.backgroundColor = [UIColor clearColor];
//    imgView.contentMode     = UIViewContentModeScaleAspectFit;
//    imgView.image           = self.srcImage;
//    
//    [srcVC.view addSubview:imgView];
//    
//    [dstVC view];
//    if(MS_isIOS7) {
//        dstVC.tableView.contentInset = UIEdgeInsetsMake(srcVC.topLayoutGuide.length, 0, srcVC.bottomLayoutGuide.length, 0);
//        if([dstVC.tableView numberOfRowsInSection:0]) {
//            [dstVC.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//        }
//        dstVC.tableView.frame = dstVC.view.bounds;
//    }
//    
//    UIImageView *dstSnapshot = [[UIImageView alloc] initWithImage:[UIImage MS_imageFromView:dstVC.view]];
//    dstSnapshot.contentMode  = UIViewContentModeTopLeft;
//    dstSnapshot.alpha        = 0.0;
//    
//    dstVC.tableView.contentInset = UIEdgeInsetsZero;
//    
//    [srcVC.view addSubview:dstSnapshot];
//    
//    CGRect imgFrame = srcVC.view.bounds;
//    if(MS_isIOS7) {
//        imgFrame.origin.y += 7; //to smooth the image transition
//    }
//    
//    void (^animation)() = ^{
//        whiteView.alpha   = 0.7;
//        imgView.frame     = imgFrame;
//        imgView.alpha     = 0.5;
//        dstSnapshot.alpha = 0.9;
//    };
//    
//    void (^completion)(BOOL) = ^(BOOL finished) {
//        [srcVC.navigationController pushViewController:dstVC animated:NO];
//        [imgView removeFromSuperview];
//        [whiteView removeFromSuperview];
//        [dstSnapshot removeFromSuperview];
//    };
    
    [UIView transitionWithView:srcVC.navigationController.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [srcVC.navigationController pushViewController:dstVC animated:NO];
                    }
                    completion:nil];
    //[srcVC.navigationController pushViewController:dstVC animated:NO];
    //[UIView animateWithDuration:0.5 animations:animation completion:completion];
}

@end
