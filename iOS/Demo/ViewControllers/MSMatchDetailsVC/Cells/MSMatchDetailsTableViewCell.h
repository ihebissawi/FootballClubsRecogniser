//
//  MSMatchDetailsTableViewCell.h
//  FlagRecognition
//
//  Created by Mykyta Karpyshyn on 1/14/16.
//  Copyright © 2016 DataArt Solutions, Inc. All rights reserved.
//

#import "MSTableViewCell.h"

@interface MSMatchDetailsTableViewCell : MSTableViewCell
- (void)setEventTitle:(NSString *)title description:(NSString *)desc time:(NSString *)time teamColor:(UIColor *)teamColor;

@end
