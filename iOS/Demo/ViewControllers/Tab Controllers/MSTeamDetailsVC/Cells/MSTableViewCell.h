//
//  MSTableViewCell.h
//  FlagRecognition
//
//  Created by Lexiren on 2/12/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+MSNib.h"

@class MSPerishableEntity;

@interface MSTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) MSPerishableEntity *source;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) UIColor *themeColor;

//methods for overwriting
+ (UINib *)MS_cellNib;
+ (NSString *)MS_reuseIdentifier;
+ (CGFloat)cellHeight;

- (void)setupWithSource:(MSPerishableEntity *)source;

@end
