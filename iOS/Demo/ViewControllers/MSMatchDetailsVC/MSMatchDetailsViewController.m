//
//  MSMatchDetailsViewController.m
//  FlagRecognition
//
//  Created by Mykyta Karpyshyn on 1/14/16.
//  Copyright © 2016 DataArt Solutions, Inc. All rights reserved.
//

#import "MSMatchDetailsViewController.h"
#import "MSRoundedImageView.h"
#import "MSDataManager.h"
#import "MSTeam.h"
#import "MSEvent.h"
#import "MSMatchDetailsTableViewCell.h"
#import "MSColorScheme.h"

@interface MSMatchDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel1;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel2;
@property (weak, nonatomic) IBOutlet MSRoundedImageView *teamLogo1;
@property (weak, nonatomic) IBOutlet MSRoundedImageView *teamLogo2;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * matchEvents;
@end

@implementation MSMatchDetailsViewController

+ (instancetype)loadFromStoryBoard{
    NSString * currentStoryBoardName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIMainStoryboardFile"];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:currentStoryBoardName bundle:nil];
    return (MSMatchDetailsViewController *)[sb instantiateViewControllerWithIdentifier:@"MatchDetailsVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.tableView registerNib:[MSMatchDetailsTableViewCell MS_cellNib] forCellReuseIdentifier:[MSMatchDetailsTableViewCell MS_reuseIdentifier]];
    
    if(self.sourceMatch){
        self.teamNameLabel1.text = self.sourceMatch.teamHome.shortNameOrName;
        self.teamNameLabel2.text = self.sourceMatch.teamAway.shortNameOrName;
        
        [self.teamLogo1 setImageWithUrlPath:self.sourceMatch.teamHome.logo];
        self.teamLogo1.borderWidth = 4.0f;
        
        [self.teamLogo2 setImageWithUrlPath:self.sourceMatch.teamAway.logo];
        self.teamLogo2.borderWidth = 4.0f;
    }
    if(self.sourceMatch.events){
        self.matchEvents = self.sourceMatch.events;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (MSDataManager *)dataManager{
    return [MSDataManager sharedManager];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.matchEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSEvent * currentEvent = self.matchEvents[indexPath.row];
    MSMatchDetailsTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:[MSMatchDetailsTableViewCell MS_reuseIdentifier]];
    [cell setEventTitle:[currentEvent eventTitle] description:[currentEvent eventHumanDescription] time:[currentEvent eventTime] teamColor:[MSColorScheme colorWithHexString:currentEvent.team.teamColorHex]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MSMatchDetailsTableViewCell cellHeight];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
