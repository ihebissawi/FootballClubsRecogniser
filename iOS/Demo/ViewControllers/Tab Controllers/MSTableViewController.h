//
//  MSTableViewController.h
//  FlagRecognition
//
//  Created by Lexiren on 2/6/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSBaseDataViewController.h"
#import "MSFilterView.h"

@interface MSTableViewController : MSBaseDataViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *filteredContentArray;

@property (nonatomic, strong, readonly) UIRefreshControl *refreshControl;

- (BOOL)isSearchTable:(UITableView *)tableView;
- (BOOL) isFilterEnabled;
- (MSFilterView *) filterView;


@end
