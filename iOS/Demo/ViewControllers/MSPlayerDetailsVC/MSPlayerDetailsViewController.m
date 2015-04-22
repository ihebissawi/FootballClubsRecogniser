//
//  MSPlayerDetailsViewController.m
//  FlagRecognition
//
//  Created by Lexiren on 2/19/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "MSPlayerDetailsViewController.h"

#import "MSPlayer.h"
#import "MSTeam.h"
#import "MSPlayerProgress.h"
#import "MSTabBarController.h"
#import "MSRoundedImageView.h"
#import "MSPlayerStatisticCell.h"
#import "MSTeamDetailsViewController.h"
#import "UIImage+MSUtils.h"

#import <QuartzCore/QuartzCore.h>
NSString *const kMSPushPlayerDetailsFromTeamSegueIdentifier = @"pushPlayerDetailsFromTeamSegue";
NSString *const kMSPushPlayerDetailsSegueIdentifier = @"pushPlayerDetailSegue";

@interface MSPlayerDetailsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet MSRoundedImageView *avatarRoundedImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet MSRoundedImageView *flagRoundedView;
@property (weak, nonatomic) IBOutlet MSRoundedImageView *teamLogoRoundedView;

@property (weak, nonatomic) IBOutlet UITableView *statisticsTableView;
@property (weak, nonatomic) IBOutlet UILabel *tournamentLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *aLabel;
@property (weak, nonatomic) IBOutlet UILabel *ycLabel;
@property (weak, nonatomic) IBOutlet UILabel *rcLabel;

@property (strong, nonatomic) NSArray *contentArray;

@end

@implementation MSPlayerDetailsViewController

#pragma mark - setup functions

- (void)updateColorScheme:(UIColor*)color {
    if (!self.colorScheme){
        self.colorScheme = [MSColorScheme sharedInstance];
    }
    else
    {
        [MSColorScheme customScheme:color];
    }
    
    [(MSTabBarController*)self.tabBarController setColorScheme:self.colorScheme];
    
}

- (MSDataManager *)dataManager {
    return [MSDataManager sharedManager];
}

- (NSArray *)buildArrayFromSource:(NSArray *)sourceObjects {
    if (!sourceObjects.count) return nil;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:sourceObjects];
//    for (MSPlayerProgress *result in sourceObjects) {
//        NSArray *seasonResults = [array lastObject];
//
//        NSMutableArray *newResults = (seasonResults.count && [((MSPlayerProgress *)[seasonResults lastObject]).seasonName isEqualToString:result.seasonName]) ?
//        [seasonResults mutableCopy] : [NSMutableArray array];
//
//        [newResults addObject:result];
//        [array addObject:(NSArray *)newResults];
//    }
    return array;
}

#pragma mark - setup

- (void)setupCommonInfoUI {
    
    self.avatarRoundedImageView.disableImageSizeAdjusting = YES;
    self.flagRoundedView.disableImageSizeAdjusting = YES;
    self.avatarRoundedImageView.imageView.layer.cornerRadius = CGRectGetWidth(self.avatarRoundedImageView.imageView.bounds) / 2;
    self.flagRoundedView.imageView.layer.cornerRadius = CGRectGetWidth(self.flagRoundedView.imageView.bounds) / 2;
    self.flagRoundedView.backgroundColor = [UIColor blackColor];
    
    [self.avatarRoundedImageView setImageWithUrlPath:self.sourcePlayer.photoLink];
    self.nameLabel.text = [self.sourcePlayer fullName];
    self.positionLabel.text = self.sourcePlayer.positionName;
    self.dateLabel.text = self.sourcePlayer.birth;
    self.title = self.sourcePlayer.shortNameOrName;
    
    self.teamLogoRoundedView.image = self.sourcePlayer.team.logoImage;
    self.teamLogoRoundedView.hidden = (self.teamLogoRoundedView.image == nil);
    self.flagRoundedView.image = [UIImage MS_imageFromCountryName:self.sourcePlayer.countryName];
    self.flagRoundedView.imageView.backgroundColor = [UIColor greenColor];
    
    [self.nameLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:18.0f]];
    [self.dateLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:9.0f]];
    [self.positionLabel setFont:[UIFont fontWithName:@"OpenSans" size:11.0f]];
    
    [self.tournamentLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.goalLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.aLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.ycLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    [self.rcLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
    
    UIColor *newColor = [MSColorScheme colorWithHexString:self.sourcePlayer.team.teamColorHex];
    newColor = [MSColorScheme getCorrectColor:newColor];
    
    
    [self updateColorScheme:newColor];
}

- (void)loadSourceArray {
    CGRect animationFrame = self.statisticsTableView.frame;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    animationFrame.size = CGSizeMake(screenSize.width, screenSize.height - CGRectGetMinY(animationFrame));
    [self showActivityViewWithText:nil
                cancelButtonHidden:YES
                             frame:animationFrame
                      cancelAction:nil];
    [self.dataManager requestStatisticsForPlayer:self.sourcePlayer
                           forceUpdateFromServer:NO
                                  withCompletion:^(BOOL success, NSError *error, id data) {
                                      self.contentArray = [self buildArrayFromSource:data];
                                      [self hideActivityView];
                                      [self.statisticsTableView reloadData];
                                  }];
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.avatarRoundedImageView.layer.cornerRadius = self.avatarRoundedImageView.frame.size.width/2;
    self.avatarRoundedImageView.layer.masksToBounds = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetailsForTeamWithID)];
    singleTap.numberOfTapsRequired = 1;
    [self.teamLogoRoundedView setUserInteractionEnabled:YES];
    [self.teamLogoRoundedView addGestureRecognizer:singleTap];

    [self.statisticsTableView registerNib:[MSPlayerStatisticCell MS_cellNib] forCellReuseIdentifier:[MSPlayerStatisticCell MS_reuseIdentifier]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSAssert(_sourcePlayer, @"source player shouldn't be nil");
    
    [self setupCommonInfoUI];
    [self loadSourceArray];
    NSDictionary *params = @{@"Player_Name":self.sourcePlayer.fullName};
    [MSFlurryAnalytics sendScreenName:kFlurryScreenPlayerDetails withParameters:params];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showDetailsForTeamWithID {
    [self showActivityViewWithText:nil
                cancelButtonHidden:NO
                             frame:self.view.bounds
                      cancelAction:@selector(loadingCancelButtonAction)];
    [self.dataManager requestTeamWithID:self.sourcePlayer.team.iD
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

- (void)loadingCancelButtonAction {
    [self.dataManager stopLoading];
}

#pragma mark - UITableViewDataSource / Delegate 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [self.contentArray[section] count] + 1;
    return self.contentArray.count ? self.contentArray.count : 0;// one additional cell for header of season
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSPlayerStatisticCell *cell = [tableView dequeueReusableCellWithIdentifier:[MSPlayerStatisticCell MS_reuseIdentifier]];
    cell.backgroundColor = (indexPath.row %2) ? [UIColor whiteColor] : [UIColor colorWithRed:(237 / 255.0f)
        green:(237 / 255.0f)
        blue:(237 / 255.0f)
        alpha:1.0f];
    
    [cell setupWithSource:self.contentArray[indexPath.row]];
        return cell;


    //shoudn't reach here
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
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

@end
