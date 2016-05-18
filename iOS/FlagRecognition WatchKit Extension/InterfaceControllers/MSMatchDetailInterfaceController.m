//
//  MSMatchDetailInterfaceController.m
//  FlagRecognition
//
//  Created by Alexander Peresadchenko on 4/1/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import "MSMatchDetailInterfaceController.h"
#import "MSMatch.h"
#import "MSTeam.h"
#import "MSEvent.h"
#import "MSGoalRowController.h"

@interface MSMatchDetailInterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *matchTitle;
@property (nonatomic, strong) NSArray *goalEvents;
@property (nonatomic, strong) MSMatch * currentMatch;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *tableView;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *scoreLabel;

@end

@implementation MSMatchDetailInterfaceController

/*
- (instancetype)init{
    self = [super init];
    [self setTitle:@"<Matches"];
    return self;
}
*/

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // Configure interface objects here.
    self.currentMatch = context;
    [self.matchTitle setText:[[NSString alloc] initWithFormat:@"%@ vs %@",[self.currentMatch.teamHome shortNameOrName], [self.currentMatch.teamAway shortNameOrName]]];
    [self.scoreLabel setText:[self.currentMatch humanScore]];
    
    self.goalEvents = [self.currentMatch goalEvents];
    if([self.goalEvents count] > 0){
        [self.tableView setNumberOfRows:[self.goalEvents count] withRowType:@"GoalRow"];
        for(NSInteger i = 0; i < [self.goalEvents count]; i++){
            BOOL isLeftComand = [((MSEvent *)self.goalEvents[i]).teamID isEqualToString:self.currentMatch.teamHomeID] ? YES : NO;
            NSString * authorName = [((MSEvent *)self.goalEvents[i]).authorName length] == 0 ? @" - " : ((MSEvent *)self.goalEvents[i]).authorName;
            MSGoalRowController * cell = [self.tableView rowControllerAtIndex:i];
            [cell setAuthor:authorName time:((MSEvent *)self.goalEvents[i]).time_minute isLeftComand:isLeftComand];
        }
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


#pragma mark - Segue
-(id)contextForSegueWithIdentifier:(NSString *)segueIdentifier {
    return self.goalEvents;
}

@end



