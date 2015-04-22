//
//  MSLeagueDetailsViewController.m
//  FlagRecognition
//
//  Created by Lexiren on 2/17/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "MSLeagueDetailsViewController.h"
#import "MSLeagueRatingCell.h"
#import "MSLeagueTableHeaderView.h"
#import "MSTeamDetailsViewController.h"

#import "MSLeagueTeamResult.h"
#import "MSLeague.h"
#import "MSTeam.h"
#import "MSCommonDefines.h"


NSString *const kMSLeagueDetailsPushSegueIdentifier = @"pushLeagueDetailSegue";


@interface MSLeagueDetailsViewController () {
    MSLeagueTableHeaderView *_tableSectionHeader;
    UIInterfaceOrientation _orientation;
}


@property (strong, nonatomic) MSTeam *selectedTeam;

@end

@implementation MSLeagueDetailsViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSParameterAssert(self.sourceLeague);
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MSLeagueRatingCell class]) bundle:nil] forCellReuseIdentifier:[MSLeagueRatingCell MS_reuseIdentifier]];
    
    self.title = self.sourceLeague.name;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.translucent = NO;
    NSDictionary *params = @{@"League_Name":self.sourceLeague.name};
    [MSFlurryAnalytics sendScreenName:kFlurryScreenLeagueDetails withParameters:params];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    if(_orientation != self.interfaceOrientation) {
        [self.tableView reloadData];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];

    if (self.navigationController.navigationBar.hidden == NO)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.tabBarController.tabBar setHidden:YES];
        self.extendedLayoutIncludesOpaqueBars =  YES;
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }
    else if (self.navigationController.navigationBar.hidden == YES)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.tabBarController.tabBar setHidden:NO];
        self.tableView.contentOffset = CGPointZero;
        
        
    }
    [self.tableView reloadData];
}


#pragma mark MSNavigationControllerAnimation

- (CAAnimation *)popAnimation {
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    return transition;
}

#pragma mark - UIinterfaceOrientation

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
}


#pragma mark MSNavigationControllerAnimation


#pragma mark - Overwriting super methods

- (void)loadContentArray
{
    [self showActivityViewWithCancelButtonHidden:YES cancelAction:nil];
    [self.dataManager requestRatingOfLeagueWithId:self.sourceLeague.iD
                            forceUpdateFromServer:NO
                                   withCompletion:^(BOOL success, NSError *error, id data) {
                                   [self hideActivityView];
                                   [self completeSettingContentArrayWithArray:data
                                                                      success:success
                                                                        error:error];
                               }];
}

- (void)refreshContentArray {
    [self.dataManager requestRatingOfLeagueWithId:self.sourceLeague.iD
                            forceUpdateFromServer:YES
                                   withCompletion:^(BOOL success, NSError *error, id data) {
                                       [self.refreshControl endRefreshing];
                                       [self completeSettingContentArrayWithArray:data
                                                                          success:success
                                                                            error:error];
                                   }];}



#pragma mark - UITableViewDataSource & Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSLeagueRatingCell *cell = [tableView dequeueReusableCellWithIdentifier:[MSLeagueRatingCell MS_reuseIdentifier]];
    MSLeagueTeamResult *leagueResult = (tableView == self.searchDisplayController.searchResultsTableView) ? self.filteredContentArray[indexPath.row] : self.contentArray[indexPath.row];
    cell.backgroundColor = (indexPath.row %2) ? [UIColor whiteColor] : [UIColor colorWithRed:(237 / 255.0f)
                                                                                       green:(237 / 255.0f)
                                                                                        blue:(237 / 255.0f)
                                                                                       alpha:1.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:(104 / 255.0f)
                                                        green:(104 / 255.0f)
                                                        blue:(104 / 255.0f)
                                                        alpha:1.0f];
    [cell setSelectedBackgroundView:bgColorView];
    
    [cell setupWithSource:leagueResult];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    MSLeagueTeamResult *teamResult =  (tableView == self.searchDisplayController.searchResultsTableView) ? self.filteredContentArray[indexPath.row] : self.contentArray[indexPath.row];
    [self showActivityViewWithText:nil cancelButtonHidden:YES frame:self.tableView.bounds cancelAction:nil];
    [self.dataManager requestTeamWithID:teamResult.teamID
                         withCompletion:^(BOOL success, NSError *error, id data) {
                             [self hideActivityView];
                             if (success) {
                                 self.selectedTeam = data;
                                 [self performSegueWithIdentifier:kMSTeamDetailsPushFromLeagueSegueIdentifier sender:self];
                             } else {
                                 [UIAlertView MS_showErrorAlertWithError:error];
                             }
                         }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MSLeagueRatingCell cellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(!_tableSectionHeader) {
        _tableSectionHeader = [MSLeagueTableHeaderView MS_loadViewFromNIB];
    }
    [_tableSectionHeader updateUI];
    return _tableSectionHeader;
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MSTeamDetailsViewController *controller = (MSTeamDetailsViewController *)segue.destinationViewController;
    controller.sourceTeam = self.selectedTeam;
    controller.colorScheme = self.customTabbarController.colorScheme;
    

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tabBarController.tabBar setHidden:NO];
    
    self.tabBarController.tabBar.translucent = NO;
}
 
@end
