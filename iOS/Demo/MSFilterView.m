//
//  MSFilterView.m
//  FlagRecognition
//
//  Created by Igor Litvinenko on 12/5/14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import "MSFilterView.h"

@implementation MSFilterView

+ (instancetype)loadFromNib{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (CGFloat) heightForView{
    return 380;
}

- (IBAction)didTapSearchButton:(UIBarButtonItem *)sender {
}



@end
