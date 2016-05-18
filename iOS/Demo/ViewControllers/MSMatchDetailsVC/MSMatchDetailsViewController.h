//
//  MSMatchDetailsViewController.h
//  FlagRecognition
//
//  Created by Mykyta Karpyshyn on 1/14/16.
//  Copyright © 2016 DataArt Solutions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSMatch.h"

@interface MSMatchDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) MSMatch * sourceMatch;
+ (instancetype)loadFromStoryBoard;
@end
