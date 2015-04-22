//
//  MSLeaguesTableViewController.m
//  FlagRecognition
//
//  Created by Lexiren on 2/7/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "MSLeaguesTableViewController.h"
#import "MSLeagueDetailsViewController.h"
#import "MSLeague.h"


@interface MSLeaguesTableViewController ()

@property (strong, nonatomic) MSLeague *selectedLeague;

@end

@implementation MSLeaguesTableViewController

#pragma mark - View life cycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MSFlurryAnalytics sendScreenName:kFlurryScreenLeagues];
    
}

#pragma mark - Overwriting super methods

- (void)loadContentArray
{
    [self showActivityViewWithCancelButtonHidden:YES cancelAction:nil];
    [self.dataManager requestLeaguesOfCountry:self.dataManager.settings.currentCountry
                        forceUpdateFromServer:NO
                               withCompletion:^(BOOL success, NSError *error, id data) {
                                   [self hideActivityView];
                                   [self completeSettingContentArrayWithArray:data
                                                                      success:success
                                                                        error:error];
                               }];
}

- (void)refreshContentArray {
    [self.dataManager requestLeaguesOfCountry:self.dataManager.settings.currentCountry
                        forceUpdateFromServer:YES
                               withCompletion:^(BOOL success, NSError *error, id data) {
                                   [self.refreshControl endRefreshing];
                                   [self completeSettingContentArrayWithArray:data
                                                                      success:success
                                                                        error:error];
                               }];
    
}




#pragma mark - UITableViewDataSource & Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    MSLeague *league = tableView == self.searchDisplayController.searchResultsTableView ? self.filteredContentArray[indexPath.row] : self.contentArray[indexPath.row];
    
    cell.textLabel.text = league.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    self.selectedLeague = (tableView == self.searchDisplayController.searchResultsTableView) ? self.filteredContentArray[indexPath.row] : self.contentArray[indexPath.row];
    [self performSegueWithIdentifier:kMSLeagueDetailsPushSegueIdentifier sender:self];
}


 #pragma mark - Navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MSLeagueDetailsViewController *controller = (MSLeagueDetailsViewController *)segue.destinationViewController;
    controller.sourceLeague = self.selectedLeague;
    
}



@end
