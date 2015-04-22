//
//  MSTodayTableViewCell.h
//  FlagRecognition
//
//  Created by Alexander Peresadchenko on 4/6/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSMatch;

@interface MSTodayTableViewCell : UITableViewCell

// Setters
-(void)setMatch:(MSMatch*)match;

@end
