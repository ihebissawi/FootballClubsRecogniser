//
//  TodayViewController.m
//  FlagRecognition Today Extension
//
//  Created by Alexander Peresadchenko on 3/27/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import "MSTodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <QuartzCore/QuartzCore.h>

#import "MagicalRecord+AppGroup.h"

#import "MSDataManager.h"
#import "HTTPClientManager.h"

#import "MSMatch.h"

#import "MSTodayTableViewCell.h"

const CGFloat kMSTodayViewControllerYOffset = 5.0;
const CGFloat kMSTodayViewControllerCellHeight = 45.0;
const NSUInteger kMSTodayViewControllerCollapsedMaxCellsCount = 3;
const NSUInteger kMSTodayViewControllerExpandedMaxCellsCount = 6;

@interface MSTodayViewController () <NCWidgetProviding, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSArray *contentArray;

@property (nonatomic,weak) IBOutlet UITableView *matchesTableView;
@property (nonatomic,weak) IBOutlet UILabel *noMatchesLabel;
@property (nonatomic,weak) IBOutlet UIButton *stateButton;
@property (nonatomic,weak) IBOutlet UIVisualEffectView *statusVisualEffectView;
@property (nonatomic,weak) IBOutlet UIButton *refreshButton;
@property (nonatomic,weak) IBOutlet UIVisualEffectView *refreshVisualEffectView;
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView *refreshIndicator;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *matchesTableViewHeightConstraint;

@property (nonatomic,unsafe_unretained) BOOL collapsed;

@end

@implementation MSTodayViewController

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[MagicalRecord setupGroupStack];
	
	[self.stateButton addTarget:self action:@selector(touchBeginButtonAction:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
	[self.stateButton addTarget:self action:@selector(touchEndedButtonAction:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside |
	 UIControlEventTouchDragOutside | UIControlEventTouchCancel];
	self.statusVisualEffectView.layer.cornerRadius = 5.0;
	self.statusVisualEffectView.layer.masksToBounds = YES;
	
	[self.refreshButton addTarget:self action:@selector(touchBeginButtonAction:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
	[self.refreshButton addTarget:self action:@selector(touchEndedButtonAction:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside |
	 UIControlEventTouchDragOutside | UIControlEventTouchCancel];
	self.refreshVisualEffectView.layer.cornerRadius = 5.0;
	self.refreshVisualEffectView.layer.masksToBounds = YES;
	
	self.collapsed = YES;
	
	[self updateViewSize];
}

#pragma mark - Widget

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
	[self updateMatchesDataWithCompletion:
	 ^(BOOL success, NSError *error)
	 {
		 if (!success || error != nil)
			 completionHandler(NCUpdateResultFailed);
		 else
			 completionHandler(NCUpdateResultNewData);
	 }];	
}

-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
	return UIEdgeInsetsZero;
}

-(void)openContainingAppWithMatch:(MSMatch*)match
{
	NSString *urlString = @"fcrte://";
	if (match != nil)
		urlString = [urlString stringByAppendingString:match.iD];
	NSURL *url = [NSURL URLWithString:urlString];
	[self.extensionContext openURL:url completionHandler:nil];
}

#pragma mark - Data

-(void)updateMatchesDataWithCompletion:(MSCompletionBlock)completion
{
	[self.refreshButton setTitle:@"Updating" forState:UIControlStateNormal];
	
	[self.refreshIndicator startAnimating];
	[[HTTPClientManager sharedHTTPClient] requestUserIDIfNeededWithCompletion:
	 ^(BOOL success, NSError *error)
	 {
		 if (success)
		 {
			 [[MSDataManager sharedManager] requestLastMatchesForFavoriteTeamsForceUpdateFromServer:YES
																					 withCompletion:
			  ^(BOOL success, NSError *error, id data)
			  {
				  [self.refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
				  
				  self.contentArray = data;
				  [self updateSubviews];
				  
				  performCompletionBlock(completion, success, error);
			  }];
		 }
		 else
			 NSLog(@"%@",error.localizedDescription);
	 }];
}

-(void)updateSubviews
{
	[self updateTitleLabel];
	
	[self.refreshIndicator stopAnimating];
	
	NSUInteger contentCount = self.contentArray.count;
	self.noMatchesLabel.hidden = contentCount != 0;
	self.matchesTableView.hidden = contentCount == 0;
	
	[self.matchesTableView reloadData];
	[self updateViewSize];
}

-(void)updateTitleLabel
{
	NSUInteger contentArrayCount =self.contentArray.count;
	NSString *title = nil;
	if (contentArrayCount > kMSTodayViewControllerCollapsedMaxCellsCount && self.collapsed)
		title = @"See more matches";
	else
		title = @"Open application";
	[self.stateButton setTitle:title forState:UIControlStateNormal];
}

-(void)updateViewSize
{
	CGFloat additionalHeight = self.contentArray.count == 0 && self.contentArray != nil ? self.noMatchesLabel.bounds.size.height : [self cellsCount] * kMSTodayViewControllerCellHeight;
	
	self.preferredContentSize = CGSizeMake(self.view.bounds.size.width,
										   additionalHeight + self.refreshButton.bounds.size.height +
										   self.stateButton.bounds.size.height + kMSTodayViewControllerYOffset * 4.0);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	self.matchesTableViewHeightConstraint.constant = [self cellsCount] * kMSTodayViewControllerCellHeight;
	[self.view updateConstraints];
	[coordinator animateAlongsideTransition:
	 ^(id<UIViewControllerTransitionCoordinatorContext> context)
	 {
		 [self.view layoutIfNeeded];
	}
								 completion:nil];
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self cellsCount];
}

-(NSUInteger)cellsCount
{
	NSInteger retVal = self.collapsed ?
	MIN(self.contentArray.count, kMSTodayViewControllerCollapsedMaxCellsCount) :
	MIN(self.contentArray.count, kMSTodayViewControllerExpandedMaxCellsCount);
	return retVal;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MSTodayTableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"todayCell"];
	MSMatch *match = self.contentArray[indexPath.row];
	[cell setMatch:match];
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	MSMatch *match = self.contentArray[indexPath.row];
	[self openContainingAppWithMatch:match];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kMSTodayViewControllerCellHeight;
}
#pragma mark - Actions

-(IBAction)refreshAction:(id)sender
{
	[self updateMatchesDataWithCompletion:nil];
}

-(IBAction)stateAction:(id)sender
{
	if (self.contentArray.count > 3 && self.collapsed)
	{
		self.collapsed = NO;
		[self.matchesTableView reloadData];
		[self updateTitleLabel];
		[self updateViewSize];
	}
	else
		[self openContainingAppWithMatch:nil];
}

// Methods needed to simulate highlited state
-(void)touchBeginButtonAction:(UIButton*)sender
{
	sender.superview.superview.alpha = 0.5;
}

-(void)touchEndedButtonAction:(UIButton*)sender
{
	sender.superview.superview.alpha = 1.0;
}

@end