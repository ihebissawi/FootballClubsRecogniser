//
//  MSTableViewController.m
//  FlagRecognition
//
//  Created by Lexiren on 2/6/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "MSTableViewController.h"
#import "MSSettings.h"
#import "MSDataTableViewCell.h"
#import "MSCommonDefines.h"

@interface MSTableViewController () <UISearchDisplayDelegate>{
    BOOL isFilterShowed;
    MSFilterView * filterView_;
}

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MSTableViewController

#pragma mark - Lifecycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[MSDataTableViewCell MS_cellNib] forCellReuseIdentifier:[MSDataTableViewCell MS_reuseIdentifier]];
//    self.searchDisplayController.searchBar.barTintColor = [UIColor whiteColor];
    self.searchDisplayController.searchBar.tintColor = self.view.tintColor;
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.customTabbarController.colorScheme = [MSColorScheme sharedInstance];
    
    if (self.isFilterEnabled){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(didTapFilterButton:)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([self deselectCellOnWillAppear]) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    }
}

- (void)reloadUI {
    [self.tableView reloadData];
}

- (BOOL)deselectCellOnWillAppear {
    return YES;
}

- (void) didTapFilterButton: (UIBarButtonItem *) sender{
    if (isFilterShowed){
        [self hideFilterView];
        [sender setTitle:@"Filter"];
        [sender setImage:nil];
    } else {
        [self showFilterView];
        [sender setTitle:@""];
        [sender setImage:[UIImage imageNamed:@"cancel"]];
    }
}

- (BOOL) isFilterEnabled{
    return NO;
}

- (MSFilterView *)filterView{
    return nil;
}

- (void) showFilterView{
    
    if (!filterView_){
        filterView_ = self.filterView;
    }
    
    CGFloat height = [filterView_ heightForView];
    CGRect filterViewRect = filterView_.frame;
    filterViewRect.size.height = 0;
    filterView_.frame = filterViewRect;
    
    if (!filterView_.superview){
        [[UIApplication sharedApplication].keyWindow addSubview:filterView_];
        [[UIApplication sharedApplication].keyWindow sendSubviewToBack:filterView_];
    }
    
    [UIView animateWithDuration:.3 animations:^{
        CGRect frame = self.navigationController.view.frame;
        frame.origin.y += height;
        self.navigationController.view.frame = frame;
        
        frame = filterViewRect;
        frame.size.height = height;
        filterView_.frame = frame;
    }];
    isFilterShowed = YES;
}

- (void) hideFilterView{
    [UIView animateWithDuration:.3 animations:^{
        CGRect frame = self.navigationController.view.frame;
        frame.origin.y = .0;
        self.navigationController.view.frame = frame;
        
        frame = filterView_.frame;
        frame.size.height = 0;
        filterView_.frame = frame;
    }];
    isFilterShowed = NO;
}

#pragma mark - UITableViewDataSource & Delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MSDataTableViewCell cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.filteredContentArray.count;
    } else {
        return self.contentArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    MSDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MSDataTableViewCell MS_reuseIdentifier]];
    cell.backgroundColor = (indexPath.row %2) ? [UIColor whiteColor] : [UIColor colorWithRed:(237 / 255.0f)
                                                                                       green:(237 / 255.0f)
                                                                                        blue:(237 / 255.0f)
                                                                                       alpha:1.0f];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if ([self.searchDisplayController isActive])
    {
       //e [self.searchDisplayController setActive:NO animated:YES];
    }
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@ OR shortName contains[cd] %@", searchString,searchString];
    self.filteredContentArray = [self.contentArray filteredArrayUsingPredicate:resultPredicate];
    
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    [self.searchDisplayController.searchResultsTableView registerNib:[MSDataTableViewCell MS_cellNib] forCellReuseIdentifier:[MSDataTableViewCell MS_reuseIdentifier]];
    self.tableView.hidden = YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    self.tableView.hidden = NO;
}

- (BOOL)isSearchTable:(UITableView *)tableView {
    return tableView == self.searchDisplayController.searchResultsTableView;
}

@end
