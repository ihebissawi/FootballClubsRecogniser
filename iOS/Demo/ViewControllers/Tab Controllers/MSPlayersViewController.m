//
//  MSPlayersViewController.m
//  FlagRecognition
//
//  Created by Lexiren on 2/17/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "MSPlayersViewController.h"
#import "MSPlayerDetailsViewController.h"
#import "MSLoadingTableViewCell.h"
#import "MSDataTableViewCell.h"
#import "SVProgressHUD.h"
#import "MSPlayer.h"

static const int   MSMinSearchLength = 3;
static const float MSSearchDelay     = 1.5;

@interface MSPlayersViewController ()<UISearchDisplayDelegate> {
    NSString *_previousSearchString;
    BOOL _additionalLoadingStarted;
}

@property (strong, nonatomic) MSPlayer *selectedPlayer;

@end

@implementation MSPlayersViewController



#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[MSLoadingTableViewCell MS_cellNib] forCellReuseIdentifier:[MSLoadingTableViewCell MS_reuseIdentifier]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _additionalLoadingStarted = NO;
    
 
    [MSFlurryAnalytics sendScreenName:kFlurryScreenPlayers];
}

#pragma mark - Overwriting super methods


- (void)loadContentArray
{
    [self showActivityViewWithCancelButtonHidden:YES cancelAction:nil];
    [self.dataManager requestPlayersInCountry:self.dataManager.settings.currentCountry
                                   fromOffset:0
                        forceUpdateFromServer:NO
                               withCompletion:^(BOOL success, NSError *error, id data) {
                                   [self hideActivityView];
                                   [self completeSettingContentArrayWithArray:data
                                                                      success:success
                                                                        error:error];
                               }];
}

- (void)refreshContentArray {
    [self.dataManager requestPlayersInCountry:self.dataManager.settings.currentCountry
                                   fromOffset:0
                        forceUpdateFromServer:YES
                               withCompletion:^(BOOL success, NSError *error, id data) {
                                   [self.refreshControl endRefreshing];
                                   [self completeSettingContentArrayWithArray:data
                                                                      success:success
                                                                        error:error];
                               }];
}

- (void)loadAdditionalDataToContentArray {
    if (_additionalLoadingStarted) return;
    
    _additionalLoadingStarted = YES;
    __weak MSPlayersViewController *weakSelf = self;
    [self.dataManager requestPlayersInCountry:self.dataManager.settings.currentCountry
                                   fromOffset:self.contentArray.count
                        forceUpdateFromServer:NO
                               withCompletion:^(BOOL success, NSError *error, id data)
     {
         MSPlayersViewController *strongSelf = weakSelf;
         if(!strongSelf) return;
         
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[strongSelf tableView:strongSelf.tableView numberOfRowsInSection:0] inSection:0];
         
         [strongSelf completeSettingContentArrayWithArray:data success:success error:error];
         
         if(success && !error) {
             [strongSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
         }
         
         strongSelf->_additionalLoadingStarted = NO;
     }];
}

#pragma mark - UITableViewDataSource & Delegate


- (BOOL)isLoadingCell:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView{
    return ![self isSearchTable:tableView] && indexPath.row == self.contentArray.count - 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView      :(NSInteger)section {
    if([self isSearchTable:tableView]) {
        return self.filteredContentArray.count;
    }
    NSInteger number = self.contentArray.count;
    if(number > 0) {
        number++; //1 row for loading cell;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"ROW :%ld",(long)indexPath.row);
    if([self isLoadingCell:indexPath inTableView:tableView]) {
        MSLoadingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MSLoadingTableViewCell MS_reuseIdentifier]];
        return cell;
    }
    else {
        MSDataTableViewCell *cell = (MSDataTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
        
        MSPlayer *player = tableView == self.searchDisplayController.searchResultsTableView ? self.filteredContentArray[indexPath.row] : self.contentArray[indexPath.row];
        cell.viewObject = player.viewObject;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self isLoadingCell:indexPath inTableView:tableView]) return;
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    self.selectedPlayer = (tableView == self.searchDisplayController.searchResultsTableView) ? self.filteredContentArray[indexPath.row] : self.contentArray[indexPath.row];
    
    //allow to show selection at once
    self.tableView.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.userInteractionEnabled = YES;
        [self performSegueWithIdentifier:kMSPushPlayerDetailsSegueIdentifier sender:self];
    });
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self isLoadingCell:indexPath inTableView:tableView]) {
        
        [(MSLoadingTableViewCell *)cell startAnimating];
        [self loadAdditionalDataToContentArray];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if([cell isKindOfClass:[MSLoadingTableViewCell class]]) {
        [(MSLoadingTableViewCell *)cell stopAnimating];
    }
}

#pragma mark - UISearchDisplayDelegate

- (void)doSearch:(NSString *)searchString {
    _previousSearchString = searchString;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    __weak MSPlayersViewController *weakSelf = self;
    [self.dataManager requestForSearchPlayersByName:searchString
                                     withCompletion:^(BOOL success, NSError *error, id data) {
                                         MSPlayersViewController *strongSelf = weakSelf;
                                         if(!strongSelf) return;
                                         
                                         strongSelf.filteredContentArray = (NSArray *)data;
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [SVProgressHUD dismiss];
                                         });
                                         [strongSelf.searchDisplayController.searchResultsTableView reloadData];
                                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                     }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (!searchString.length) return NO;
    
    NSArray *players = [MSPlayer MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"firstName contains [cd] %@ || lastName contains [cd] %@", searchString, searchString]];
    self.filteredContentArray = players;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doSearch:) object:_previousSearchString];
    
    if(searchString.length >= MSMinSearchLength) {
        [SVProgressHUD show];
        [self performSelector:@selector(doSearch:) withObject:searchString afterDelay:MSSearchDelay];
    }
    
    return YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MSPlayerDetailsViewController *controller = (MSPlayerDetailsViewController *)segue.destinationViewController;
    controller.sourcePlayer = self.selectedPlayer;
    controller.colorScheme = self.customTabbarController.colorScheme;
}

@end
