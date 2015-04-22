//
//  MSLeagueTableHeaderView.m
//  FlagRecognition
//
//  Created by Lexiren on 2/17/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#define kMSAdditionalViewPortraitWidth 0
#define kMSAdditionalViewLandscapeWidth 172

#import "MSLeagueTableHeaderView.h"
#import "UIView+MSNib.h"
#import "MSCommonDefines.h"

@interface MSLeagueTableHeaderView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *additionalInfoViewWidth;
@property (weak, nonatomic) IBOutlet UIToolbar *bgToolBar;
@property (weak, nonatomic) IBOutlet UILabel *posLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UILabel *gpLabel;
@property (weak, nonatomic) IBOutlet UILabel *ptsLabal;
@property (weak, nonatomic) IBOutlet UILabel *wLabel;
@property (weak, nonatomic) IBOutlet UILabel *dLabel;
@property (weak, nonatomic) IBOutlet UILabel *lLabel;
@property (weak, nonatomic) IBOutlet UILabel *gaLabel;
@property (weak, nonatomic) IBOutlet UILabel *gfLabel;
@end

@implementation MSLeagueTableHeaderView

+ (CGFloat)viewDefaultHeight {
    static CGFloat _viewHeight = 0.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MSLeagueTableHeaderView *view = [MSLeagueTableHeaderView MS_loadViewFromNIB];
        _viewHeight = view.bounds.size.height;
        
    });
    
    return _viewHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self updateUI];
    }
    return self;
}



- (void)updateUI {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    self.additionalInfoViewWidth.constant = (UIDeviceOrientationIsLandscape(orientation)) ? kMSAdditionalViewLandscapeWidth :  kMSAdditionalViewPortraitWidth;
    
    [self layoutIfNeeded];
}


//TO DO CREATE NEW HEADERVIEWCELL!!
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [self.gpLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.posLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.teamLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.ptsLabal setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    
    
    [self.wLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.dLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.lLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.gaLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.gfLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    if(self.isForTeam)
    {
        self.backgroundColor = [UIColor colorWithRed:244/255.0f green:220/255.0f blue:59/255.0f alpha:1.0f];
        self.gpLabel.textColor = [UIColor colorWithRed:127/255.0f green:118/255.0f blue:19/255.0f alpha:1.0f];
        self.posLabel.textColor = [UIColor colorWithRed:127/255.0f green:118/255.0f blue:19/255.0f alpha:1.0f];
        self.teamLabel.textColor = [UIColor colorWithRed:127/255.0f green:118/255.0f blue:19/255.0f alpha:1.0f];
        self.ptsLabal.textColor = [UIColor colorWithRed:127/255.0f green:118/255.0f blue:19/255.0f alpha:1.0f];
        
    }
}

@end
