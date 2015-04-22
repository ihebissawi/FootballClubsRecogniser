//
//  MSTeamsTableViewController.m
//  FlagRecognition
//
//  Created by Lexiren on 2/6/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "MSTeamsTableViewController.h"
#import "MSTeamDetailsViewController.h"
#import "UIViewController+MSActivityIndicator.h"
#import "MSTeam.h"
#import "MSTeamTableViewCell.h"
#if (!TARGET_IPHONE_SIMULATOR)
#import "MSImageRecognitionViewController.h"
#endif

static NSString * const kImageRecognitionSegueIdentifier = @"presentImageRecognitionSegue";

@interface MSTeamsTableViewController ()
<MSTeamTableViewCellDelegate>
@property (nonatomic, strong) MSTeam *selectedTeam;


@end

@implementation MSTeamsTableViewController

#pragma mark - Overwriting super methods

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.searchDisplayController.searchResultsTableView registerNib:[MSTeamTableViewCell MS_cellNib] forCellReuseIdentifier:[MSTeamTableViewCell MS_reuseIdentifier]];
	[self.tableView registerNib:[MSTeamTableViewCell MS_cellNib] forCellReuseIdentifier:[MSTeamTableViewCell MS_reuseIdentifier]];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[MSFlurryAnalytics sendScreenName:kFlurryScreenTeams];
}

- (void)loadContentArray
{
	[self showActivityViewWithCancelButtonHidden:YES cancelAction:nil];
	[self.dataManager requestTeamsPlayingInCountry:self.dataManager.settings.currentCountry
							 forceUpdateFromServer:NO
									withCompletion:^(BOOL success, NSError *error, id data) {
										[self hideActivityView];
										[self completeSettingContentArrayWithArray:data
																		   success:success
																			 error:error];
										

										[self.dataManager requestLastMatchesForFavoriteTeamsForceUpdateFromServer:NO
																								   withCompletion:
										 ^(BOOL success, NSError *error, id data)
										 {
											 
										 }];
									}];
}

- (void)refreshContentArray {
	[self.dataManager requestTeamsPlayingInCountry:self.dataManager.settings.currentCountry
							 forceUpdateFromServer:YES
									withCompletion:^(BOOL success, NSError *error, id data) {
										[self.refreshControl endRefreshing];
										[self completeSettingContentArrayWithArray:data
																		   success:success
																			 error:error];
									}];
	
}

#pragma mark - Public

- (void)completeSettingContentArrayWithArray:(NSArray *)array success:(BOOL)isSuccessUpdate error:(NSError *)error
{
	if (isSuccessUpdate) {
		self.contentArray = [array sortedArrayUsingComparator:
							 ^NSComparisonResult(MSTeam *obj1, MSTeam *obj2)
							 {
								 return [obj2.favorite compare:obj1.favorite];
							 }];
		[self reloadUI];
	} else {
		[UIAlertView MS_showErrorAlertWithError:error];
	}
}

#pragma mark - UITableViewDataSource & Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MSTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MSTeamTableViewCell MS_reuseIdentifier]];
	cell.delegate = self;
	cell.backgroundColor = (indexPath.row %2) ? [UIColor whiteColor] : [UIColor colorWithRed:(237 / 255.0f)
																					   green:(237 / 255.0f)
																						blue:(237 / 255.0f)
																					   alpha:1.0f];
	
	NSArray * datasource = tableView == self.searchDisplayController.searchResultsTableView ? self.filteredContentArray : self.contentArray;
	MSTeam * team = datasource[indexPath.row];
	cell.viewObject = team.viewObject;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		self.selectedTeam = self.filteredContentArray[indexPath.row];
	} else {
		self.selectedTeam = self.contentArray[indexPath.row];
	}
	
	//allow to show selection at once
	self.tableView.userInteractionEnabled = NO;
	dispatch_async(dispatch_get_main_queue(), ^{
		self.tableView.userInteractionEnabled = YES;
		[self performSegueWithIdentifier:kMSTeamDetailsPushSegueIdentifier sender:self];
	});
}


#pragma mark - MSTeamTableViewDelegate

- (void)teamTableViewCell:(MSTeamTableViewCell *)cell setFavoritesState:(BOOL)state
{
	BOOL searching =  self.tableView.hidden;
	NSIndexPath *indexPath = searching ?  [self.searchDisplayController.searchResultsTableView indexPathForCell:cell] : [self.tableView indexPathForCell:cell];
	NSArray *datasource = searching ? self.filteredContentArray : self.contentArray;
	MSTeam *team = datasource[indexPath.row];
	team.favorite = [NSNumber numberWithBool:state];
	
	[self.dataManager updateFavoriteStatusForTeam:team
								   withCompletion:
	 ^(BOOL success, NSError *error)
	 {
		 self.contentArray = [self.contentArray sortedArrayUsingComparator:[self sortComparator]];
		 if (self.filteredContentArray.count > 0)
		 {
			 self.filteredContentArray = [self.filteredContentArray sortedArrayUsingComparator:[self sortComparator]];
			 [self.searchDisplayController.searchResultsTableView reloadData];
		 }

		 [self.tableView reloadData];
	 }];
}

-(NSComparisonResult(^)(MSTeam *obj1, MSTeam *obj2))sortComparator
{
	return [^NSComparisonResult(MSTeam *obj1, MSTeam *obj2)
	{
		NSComparisonResult result = [obj2.favorite compare:obj1.favorite];
		if (result == NSOrderedSame)
			result = [obj1.name caseInsensitiveCompare:obj2.name];
		
		return result;
	} copy];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:kMSTeamDetailsPushSegueIdentifier]) {
		MSTeamDetailsViewController *controller = (MSTeamDetailsViewController *)segue.destinationViewController;
		controller.sourceTeam = self.selectedTeam;
		controller.colorScheme = self.customTabbarController.colorScheme;
		
	}
#if (!TARGET_IPHONE_SIMULATOR)
	else if ([segue.identifier isEqualToString:kImageRecognitionSegueIdentifier]) {
		MSImageRecognitionViewController *vc = (MSImageRecognitionViewController *)[(UINavigationController *)segue.destinationViewController topViewController];
		
		__weak MSTeamsTableViewController *weakSelf = self;
		vc.recognizeCompletion = ^(BOOL success, NSError *error, id data) {
			MSTeamsTableViewController *strongSelf = weakSelf;
			if(!strongSelf) return;
			if (success) {
				if ([data isKindOfClass:[NSString class]]) {
					[strongSelf showActivityViewWithCancelButtonHidden:YES cancelAction:nil];
					[strongSelf.dataManager requestTeamWithID:data
											   withCompletion:^(BOOL success, NSError *error, id data) {
												   [strongSelf hideActivityView];
												   if (success) {
													   strongSelf.selectedTeam = data;
													   [strongSelf performSegueWithIdentifier:kMSTeamDetailsPushSegueIdentifier sender:self];
												   } else {
													   [UIAlertView MS_showErrorAlertWithError:error];
												   }
											   }];
				}
			} else {
				[UIAlertView MS_showErrorAlertWithError:error];
			}
		};
	}
#endif
}

- (BOOL)isFilterEnabled{
	return NO;
}

- (UIView *)filterView{
	//    return [MSFilterView loadFromNib];
	return nil;
}

#pragma mark - IBActions

- (IBAction)didTapOpenScannerButton:(id)sender {
#if (!TARGET_IPHONE_SIMULATOR)
	[self performSegueWithIdentifier:kImageRecognitionSegueIdentifier sender:self];
#endif
}

@end
