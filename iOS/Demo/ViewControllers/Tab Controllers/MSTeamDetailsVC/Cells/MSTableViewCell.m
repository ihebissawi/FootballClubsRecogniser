//
//  MSTableViewCell.m
//  FlagRecognition
//
//  Created by Lexiren on 2/12/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "MSTableViewCell.h"

@implementation MSTableViewCell

- (void)setupWithSource:(MSPerishableEntity *)source{
    _source = source;
    [self updateUI];
}

#pragma mark - Methods for overwriting

+ (UINib *)MS_cellNib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

+ (NSString *)MS_reuseIdentifier {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSString *)reuseIdentifier {
    return [self.class MS_reuseIdentifier];
}

+ (CGFloat)cellHeight {
    return 44.0;
}

- (void)updateUI {
    [self doesNotRecognizeSelector:_cmd];
}

@end
