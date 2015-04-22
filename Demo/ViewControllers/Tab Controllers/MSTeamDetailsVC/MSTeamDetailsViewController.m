//
//  MSTeamDetailsViewController.m
//  FlagRecognition
//
//  Created by Lexiren on 2/10/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "MSTeamDetailsViewController.h"
#import "MSPlayerCell.h"
#import "MSMatchCell.h"
#import "MSLeagueRatingCell.h"
#import "MSLeagueRaitingHeader.h"
#import "MSPlayerDetailsViewController.h"
#import "MSTabBarController.h"

#import "UIImageView+AFNetworking.h"
#import "UIColor+MSCustomization.h"
#import "UIView+MSNib.h"

#import "MSTeam.h"
#import "MSCountry.h"
#import "MSLeagueTeamResult.h"
#import "MSMatch.h"

#import "MSNavigationControllerOrientation.h"
#import "HMSegmentedControl.h"
#import "MSRoundedImageView.h"

#import "MSTabBarController.h"
NSString *const kMSTeamDetailsPushSegueIdentifier = @"pushTeamDetailSegue";
NSString *const kMSTeamDetailsPushFromLeagueSegueIdentifier = @"pushTeamDetailsFromLeagueSegue";
NSString *const kMSTeamDetailsVCIdentifier = @"TeamDetailsVC";
NSInteger const kMSTeamBaseInfoViewDefaultHeight = 78;

typedef enum {
    MSSegmentIndexMatches = 1,
    MSSegmentIndexPlayers = 0,
    MSSegmentIndexInfo = 2
} MSSegmentIndex;


@interface MSTeamDetailsViewController () <UITableViewDataSource, UITableViewDelegate, MSNavigationControllerOrientation>

@property (weak, nonatomic) IBOutlet UILabel *noAvailableDataLabel;

@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MSRoundedImageView *logoBackView;

@property (weak, nonatomic) IBOutlet UILabel *foundedValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *stadiumValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *coachNameValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *leagueNameValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coachTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stadiumTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (strong, nonatomic) UIColor *themeColor;

@property (strong, nonatomic) NSArray *contentArray;

@property (strong, nonatomic) NSArray *matchesArray;
@property (strong, nonatomic) NSArray *playersArray;
@property (strong, nonatomic) NSArray *leagueResultsArray;

@property (assign, nonatomic) MSSegmentIndex selectedIndexToDisplay;
@property (strong, nonatomic) MSPlayer *selectedPlayer;

@property (nonatomic) NSMutableArray *tableOffsets;

@end


@implementation MSTeamDetailsViewController

#pragma mark - setup functions

- (void)updateColorScheme:(UIColor*)color {
    if (!self.colorScheme){
        self.colorScheme = [MSColorScheme sharedInstance];
    }
    else
    {
        [MSColorScheme customScheme:color];
    }
    
    self.segmentedControl.textColor = self.colorScheme.backColor;
    self.segmentedControl.selectionIndicatorColor = self.colorScheme.semiMainColor;
    [(MSTabBarController*)self.tabBarController setColorScheme:self.colorScheme];
    
}
#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSValue *zeroOffset = [NSValue valueWithCGPoint:CGPointZero];
    self.tableOffsets = [NSMutableArray arrayWithObjects:zeroOffset, zeroOffset, zeroOffset, nil];
    
    NSAssert(self.sourceTeam, @"Source team should not be nil here");
    //TODO: add refresh control
    self.title = [self.sourceTeam shortNameOrName];
    
//    [self.teamLogoImageView setImageWithURL:[NSURL URLWithString:self.sourceTeam.logo]];
    [self.logoBackView setImageWithUrlPath:self.sourceTeam.logo];
    self.logoBackView.borderWidth = 4.0f;
    self.coachTitleLabel.font = [UIFont fontWithName:@"OpenSans" size:10];
    self.stadiumTitleLabel.font = [UIFont fontWithName:@"OpenSans" size:10];
    self.coachNameValueLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:11];
    self.stadiumValueLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:11];
    self.teamNameLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18];
    self.segmentedControl.sectionTitles = @[@"Players", @"Last Matches", @"Standings"];
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.segmentedControl.font = [UIFont fontWithName:@"OpenSans" size:14];
    self.segmentedControl.selectedTextFont = [UIFont fontWithName:@"OpenSans-Bold" size:14];
    self.foundedValueLabel.font = [UIFont fontWithName:@"OpenSans" size:10];
    self.foundedValueLabel.text = [NSString stringWithFormat:@"%@, %@, %@", self.sourceTeam.currentLeagueName ?: @"-", self.sourceTeam.homeCountryName ?: @"-", self.sourceTeam.founded ?: @"-"];
    self.stadiumValueLabel.text = self.sourceTeam.stadium ?: @"-";
    
    self.coachNameValueLabel.text = self.sourceTeam.coach ?: @"-";

    self.leagueNameValueLabel.text = self.sourceTeam.currentLeagueName ?: @"-";
    self.teamNameLabel.text = [self.sourceTeam shortNameOrName];
    
    self.infoView.hidden = YES;
    
    [self.tableView registerNib:[MSLeagueRatingCell MS_cellNib] forCellReuseIdentifier:[MSLeagueRatingCell MS_reuseIdentifier]];
    [self.tableView registerNib:[MSPlayerCell MS_cellNib] forCellReuseIdentifier:[MSPlayerCell MS_reuseIdentifier]];
    [self.tableView registerNib:[MSMatchCell MS_cellNib] forCellReuseIdentifier:[MSMatchCell MS_reuseIdentifier]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary *params = @{@"Team_Name":self.sourceTeam.name};
    [MSFlurryAnalytics sendScreenName:kFlurryScreenTeamDetails withParameters:params];
    [self.view layoutIfNeeded];
    UIColor *newColor = [MSColorScheme colorWithHexString:self.sourceTeam.teamColorHex];
    newColor = [MSColorScheme getCorrectColor:newColor];
   
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [self updateColorScheme:newColor];
    [self reloadDataAnimated:YES];
    
    
//    self.teamNameLabel.text = [self.sourceTeam name];
//    self.teamDetailLabel.text = self.sourceTeam.playingCountryName;
}

-(void)viewDidAppear:(BOOL)animated
{

}

#pragma mark - UIinterfaceOrientation

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
#pragma mark - MSNavigationControllerOrientation

- (BOOL)shouldCorrectInterfaceOrientation {
    return YES;
}

#pragma mark - private

- (MSDataManager *)dataManager {
    return [MSDataManager sharedManager];
}

- (void)reloadDataAnimated:(BOOL)animated {
    NSInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
    
    __weak MSTeamDetailsViewController *weakSelf = self;
    [self updateTableViewContentByIndex:selectedIndex withCompletion:[^{
        MSTeamDetailsViewController *strongSelf = weakSelf;
        if(!strongSelf) return;
        
        strongSelf.infoView.hidden = NO;
        
        void (^update)() = ^{
            [strongSelf.view layoutIfNeeded];
        };
        
        if(animated) {
            [UIView animateWithDuration:0.3 animations:update];
        }
        else {
            update();
        }
    } copy]];
}

- (NSInteger) getClosestMatch: (NSArray *) matches{
    NSInteger currentDateRowIndex = 0;
    CGFloat diffTime = MAXFLOAT;
    for (NSInteger i = 0; i < matches.count; i++){
        MSMatch * match = matches[i];
        CGFloat diffFromNow = match.date.timeIntervalSinceNow;
        if (diffFromNow > 0 && diffFromNow < diffTime){
            diffTime = diffFromNow;
            currentDateRowIndex = i;
        }
    }
    return currentDateRowIndex;
}

- (void)updateTableViewContentByIndex:(NSInteger)index withCompletion:(void (^)())compleion {
    if(self.selectedIndexToDisplay != index) {
        self.tableOffsets[self.selectedIndexToDisplay] = [NSValue valueWithCGPoint:self.tableView.contentOffset];
    }
    self.selectedIndexToDisplay = (MSSegmentIndex)index;
    self.tableView.allowsSelection = (index != MSSegmentIndexMatches);
    
    //TODO: refactor it
    switch (index) {
        case MSSegmentIndexMatches: {
            if (self.matchesArray.count) {
                self.contentArray = self.matchesArray;
                [self.tableView reloadData];
                self.noAvailableDataLabel.hidden = (self.contentArray.count > 0);
                self.tableView.contentOffset = [self.tableOffsets[self.selectedIndexToDisplay] CGPointValue];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self getClosestMatch:self.matchesArray] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                compleion();
            } else {
                [self showActivityViewWithText:nil cancelButtonHidden:YES frame:self.tableView.frame cancelAction:nil];
                self.view.userInteractionEnabled = NO;
                self.tableView.hidden = YES;
                
                __weak MSTeamDetailsViewController *weakSelf = self;
                [self.dataManager requestLastMatchesResultsForTeam:self.sourceTeam
                                             forceUpdateFromServer:NO
                                                    withCompletion:^(BOOL success, NSError *error, id data) {
                                                        MSTeamDetailsViewController *strongSelf = weakSelf;
                                                        if(!strongSelf) return;
                                                        
                                                        strongSelf.view.userInteractionEnabled = YES;
                                                        strongSelf.tableView.hidden = NO;
                                                        [strongSelf hideActivityView];
                                                        strongSelf.matchesArray = (NSArray *)data;
                                                        [strongSelf updateTableViewContentByIndex:index withCompletion:compleion];
                                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                            [strongSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[strongSelf getClosestMatch:data] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                                        });
                                                    }];
            }
        }
            break;
        case MSSegmentIndexPlayers: {
            if (self.playersArray.count) {
                self.contentArray = self.playersArray;
                [self.tableView reloadData];
                self.noAvailableDataLabel.hidden = (self.contentArray.count > 0);
                self.tableView.contentOffset = [self.tableOffsets[self.selectedIndexToDisplay] CGPointValue];
                compleion();
            } else {
                //[self.view layoutIfNeeded]; //update info view height constraint in case it was shown
                [self showActivityViewWithText:nil cancelButtonHidden:YES frame:self.tableView.frame cancelAction:nil];
                self.view.userInteractionEnabled = NO;
                self.tableView.hidden = YES;
                
                __weak MSTeamDetailsViewController *weakSelf = self;
                [self.dataManager requestPlayersOfTeam:self.sourceTeam
                                 forceUpdateFromServer:NO
                                        withCompletion:^(BOOL success, NSError *error, id data) {
                                            MSTeamDetailsViewController *strongSelf = weakSelf;
                                            if(!strongSelf) return;
                                            
                                            strongSelf.view.userInteractionEnabled = YES;
                                            strongSelf.tableView.hidden = NO;
                                            [strongSelf hideActivityView];
                                            strongSelf.playersArray = (NSArray *)data;
                                            [strongSelf updateTableViewContentByIndex:index withCompletion:compleion];
                                        }];
            }
        }
            break;
        case MSSegmentIndexInfo: {
            if (self.leagueResultsArray.count) {
                self.contentArray = self.leagueResultsArray;
                [self.tableView reloadData];
                self.noAvailableDataLabel.hidden = (self.contentArray.count > 0);
                NSInteger indexOfCurrentTeam = [self indexOfCurrentTeamInLeagueResults:self.leagueResultsArray];
                if (indexOfCurrentTeam != NSNotFound) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexOfCurrentTeam inSection:0]
                                          atScrollPosition:UITableViewScrollPositionTop
                                                  animated:YES];
                } else {
                    NSAssert(NO, @"This shouldn't happen: league must contains current team");
                }
                compleion();
            } else {
                [self showActivityViewWithText:nil cancelButtonHidden:YES frame:self.tableView.frame cancelAction:nil];
                self.view.userInteractionEnabled = NO;
                self.tableView.hidden = YES;
                
                __weak MSTeamDetailsViewController *weakSelf = self;
                [self.dataManager requestRatingOfLeagueWithId:self.sourceTeam.currentLeagueID
                                        forceUpdateFromServer:NO
                                               withCompletion:^(BOOL success, NSError *error, id data) {
                                                   MSTeamDetailsViewController *strongSelf = weakSelf;
                                                   if(!strongSelf) return;
                                                   
                                                   strongSelf.view.userInteractionEnabled = YES;
                                                   strongSelf.tableView.hidden = NO;
                                                   [strongSelf hideActivityView];
                                                   strongSelf.leagueResultsArray = (NSArray *)data;
                                                   [strongSelf updateTableViewContentByIndex:index withCompletion:compleion];
                                               }];
            }
        }
            break;
            
        default:
            NSAssert(NO, @"Wrong index in [MSTeamDetailsViewController updateTableViewContentByIndex:animated:]");
            break;
    }
}

- (NSInteger)indexOfCurrentTeamInLeagueResults:(NSArray *)leagueResults {
    for (int i = 0; i < leagueResults.count; ++i) {
        MSLeagueTeamResult *leagueResult = leagueResults[i];
        if ([leagueResult.teamID isEqualToString:self.sourceTeam.iD]) {
            return i;
        }
    }
    return NSNotFound;
}

#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSTableViewCell *cell = [self tableView:tableView
                      cellForRowAtIndexPath:indexPath
                                   withType:self.selectedIndexToDisplay];
    cell.themeColor = self.themeColor;
    cell.backgroundColor = (indexPath.row %2) ? [UIColor whiteColor] : [UIColor colorWithRed:(237 / 255.0f)
                                                                                       green:(237 / 255.0f)
                                                                                        blue:(237 / 255.0f)
                                                                                       alpha:1.0f];
    [cell setupWithSource:self.contentArray[indexPath.row]];
    cell.teamId = self.sourceTeam.iD;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.selectedIndexToDisplay) {
        case MSSegmentIndexInfo: {
            MSLeagueTeamResult *teamResult = self.contentArray[indexPath.row];
            [self showDetailsForTeamWithID:teamResult.teamID];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
            break;
        case MSSegmentIndexPlayers: {
            self.selectedPlayer = self.contentArray[indexPath.row];
            [self performSegueWithIdentifier:kMSPushPlayerDetailsFromTeamSegueIdentifier sender:self];
        }
            break;
            
        default:
            break;
    }
}

- (void)loadingCancelButtonAction {
    [self.dataManager stopLoading];
}

- (MSTableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                      withType:(MSSegmentIndex)typeIndex
{
    MSTableViewCell *cell = nil;
    switch (typeIndex) {
        case MSSegmentIndexInfo:{
            cell = [tableView dequeueReusableCellWithIdentifier:[MSLeagueRatingCell MS_reuseIdentifier]];
            [(MSLeagueRatingCell *)cell setUserTeamID:self.sourceTeam.iD];
            [(MSLeagueRatingCell *)cell setColorScheme:self.colorScheme];
        }
            break;
            
        case MSSegmentIndexPlayers: {
            cell = [tableView dequeueReusableCellWithIdentifier:[MSPlayerCell MS_reuseIdentifier]];
        }
            break;
            
        case MSSegmentIndexMatches: {
            cell = [tableView dequeueReusableCellWithIdentifier:[MSMatchCell MS_reuseIdentifier]];
            if (!((MSMatchCell *)cell).didTapTeamInfoButton) {
                __weak MSTeamDetailsViewController *weakSelf = self;
                ((MSMatchCell *)cell).didTapTeamInfoButton = ^(id sender, id data) {
                    [weakSelf showDetailsForTeamWithID:data];
                };
            }
            [(MSMatchCell *)cell setUserTeamID:self.sourceTeam.iD];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.selectedIndexToDisplay) {
        case MSSegmentIndexInfo:    return [MSLeagueRatingCell cellHeight];
        case MSSegmentIndexPlayers: return [MSPlayerCell cellHeight];
        case MSSegmentIndexMatches: return [MSMatchCell cellHeight];
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.selectedIndexToDisplay == MSSegmentIndexInfo) {
        MSLeagueRaitingHeader *headerView = [MSLeagueRaitingHeader MS_loadViewFromNIB];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.selectedIndexToDisplay == MSSegmentIndexInfo) {
        return [MSLeagueRaitingHeader viewDefaultHeight];
    }
    return 0.0;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kMSPushPlayerDetailsFromTeamSegueIdentifier]) {
        MSPlayerDetailsViewController *controller = (MSPlayerDetailsViewController *)segue.destinationViewController;
        controller.sourcePlayer = self.selectedPlayer;
    }
}

#pragma mark - IBActions
- (IBAction)didChangeValueSegmentedControll:(id)sender {
    [self reloadDataAnimated:YES];
}

- (void)showDetailsForTeamWithID:(NSString *)teamID {
    if ([teamID isEqualToString:self.sourceTeam.iD]) {
//        [UIAlertView MS_showSimpleAlertWithMessage:@"You are already watching about this team"];
        return;
    }
    [self showActivityViewWithText:nil
                cancelButtonHidden:NO
                             frame:self.view.bounds
                      cancelAction:@selector(loadingCancelButtonAction)];
    [self.dataManager requestTeamWithID:teamID
                         withCompletion:^(BOOL success, NSError *error, id data) {
                             [self hideActivityView];
                             if (success) {
                                 MSTeamDetailsViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier:kMSTeamDetailsVCIdentifier];
                                 newController.sourceTeam = data;
                                 newController.colorScheme = self.colorScheme;
                                 //                                        [self.navigationController setViewControllers:@[newController] animated:YES];
                                 if (self.navigationController.viewControllers.count < 10) {
                                     [self.navigationController pushViewController:newController animated:YES];
                                 }
                             } else {
                                 [UIAlertView MS_showErrorAlertWithError:error];
                             }
                         }];
}

@end
