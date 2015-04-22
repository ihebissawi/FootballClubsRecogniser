//
//  MSLeagueRaitingHeader.m
//  FlagRecognition
//
//  Created by Michael Murnik on 12/25/14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import "MSLeagueRaitingHeader.h"

@implementation MSLeagueRaitingHeader

+ (CGFloat)viewDefaultHeight {
    static CGFloat _viewHeight = 0.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MSLeagueRaitingHeader *view = [MSLeagueRaitingHeader MS_loadViewFromNIB];
        _viewHeight = view.bounds.size.height;
        
    });
    
    return _viewHeight;
}

- (void)awakeFromNib {
    //[self setFrame:CGRectMake(0, 0, 0, self.bounds.size.height)];
    [self.gpLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.posLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.teamLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.ptsLabal setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];

    self.backgroundColor = [UIColor colorWithRed:244/255.0f green:220/255.0f blue:59/255.0f alpha:1.0f];
    self.gpLabel.textColor = [UIColor colorWithRed:127/255.0f green:118/255.0f blue:19/255.0f alpha:1.0f];
    self.posLabel.textColor = [UIColor colorWithRed:127/255.0f green:118/255.0f blue:19/255.0f alpha:1.0f];
    self.teamLabel.textColor = [UIColor colorWithRed:127/255.0f green:118/255.0f blue:19/255.0f alpha:1.0f];
    self.ptsLabal.textColor = [UIColor colorWithRed:127/255.0f green:118/255.0f blue:19/255.0f alpha:1.0f];
    

}


@end
