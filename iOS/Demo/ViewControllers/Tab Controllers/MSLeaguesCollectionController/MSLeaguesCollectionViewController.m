//
//  MSLeaguesCollectionViewController.m
//  FlagRecognition
//
//  Created by Viktor Levschanov on 17.03.14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import "MSLeaguesCollectionViewController.h"
#import "MSDataManager.h"
#import "MSLeagueCollectionViewCell.h"
#import "UIView+MSNib.h"
#import "MSLeague.h"
#import "MSLeagueDetailsViewController.h"
#import "MSLeagueDetailsSegue.h"
#import "MSCommonDefines.h"


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@interface MSLeaguesCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation MSLeaguesCollectionViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.collectionView registerNib:[MSLeagueCollectionViewCell loadNib] forCellWithReuseIdentifier:[MSLeagueCollectionViewCell reuseIdentifier]];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
//    if(MS_isIOS7 && self.isViewJustLoaded) {
//        [self.collectionView setContentInset:UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0)];
//        [self.collectionView setScrollIndicatorInsets: self.collectionView.contentInset];
//    }
//    
    [super viewDidAppear:animated];
}

#pragma mark - Actions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kMSLeagueDetailsPushSegueIdentifier]) {
        NSParameterAssert([sender isKindOfClass:[MSLeagueCollectionViewCell class]] && [segue isKindOfClass:[MSLeagueDetailsSegue class]]);
        
        MSLeagueDetailsViewController *controller   = (MSLeagueDetailsViewController *)segue.destinationViewController;
        MSLeagueCollectionViewCell    *selectedCell = (MSLeagueCollectionViewCell *)sender;
        MSLeagueDetailsSegue          *leagueSeague = (MSLeagueDetailsSegue *)segue;
        
        controller.sourceLeague = selectedCell.league;
        
        leagueSeague.srcImage = selectedCell.leagueImageView.image;
        
        CGRect imageFrame = [selectedCell convertRect:selectedCell.leagueImageView.frame toView:self.collectionView];
        if(MS_isIOS7) {
            imageFrame.origin.y += self.topLayoutGuide.length;
        }
        leagueSeague.srcRect = imageFrame;
    }
}

#pragma mark - Override


- (void)loadContentArray {
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

- (void)reloadUI {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MSLeagueCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MSLeagueCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    
    [cell setupWithLeague:self.contentArray[indexPath.item]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
    UIView * imView = [view viewWithTag:77];
    imView.layer.cornerRadius = CGRectGetHeight(imView.frame) / 2;
    imView.layer.borderColor = [UIColor blackColor].CGColor;
    imView.layer.borderWidth = 2;
    imView.layer.masksToBounds = YES;
    UIView * parent = imView.superview;
    parent.layer.cornerRadius = CGRectGetHeight(parent.frame) / 2;
    parent.layer.masksToBounds = YES;
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_6P) {
        return CGSizeMake(180.0f, 180.0f);
    }
    return CGSizeMake(140.0f, 140.0f);
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MSLeagueCollectionViewCell *cell = (MSLeagueCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:kMSLeagueDetailsPushSegueIdentifier sender:cell];
}

@end
