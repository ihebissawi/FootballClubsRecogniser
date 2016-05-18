//
//  MSMatchEventsInterfaceController.m
//  FlagRecognition
//
//  Created by Alexander Peresadchenko on 4/1/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import "MSMatchEventsInterfaceController.h"
#import "MSMatch.h"
#import "MSTeam.h"
#import "MSMatchEventRowController.h"

@interface MSMatchEventsInterfaceController()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *tableView;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *matchName;
@property (nonatomic,strong) MSMatch * currentMatch;
@end


@implementation MSMatchEventsInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    
    self.currentMatch = context;
    [self.matchName setText:[[NSString alloc] initWithFormat:@"%@ vs %@",[self.currentMatch.teamHome shortNameOrName], [self.currentMatch.teamAway shortNameOrName]]];
    NSArray * events = [self.currentMatch events];
    if([events count] > 0){
        [self.tableView setNumberOfRows:[events count] withRowType:@"EventCell"];
        for(NSInteger i = 0; i < [events count]; i++){
            MSMatchEventRowController * cell = [self.tableView rowControllerAtIndex:i];
            [cell setMatchEvent:events[i]];
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

@end



