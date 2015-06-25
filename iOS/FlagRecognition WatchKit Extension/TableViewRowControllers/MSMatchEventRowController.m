//
//  MSMatchEventRowController.m
//  FlagRecognition
//
//  Created by Alexander Peresadchenko on 4/2/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import "MSMatchEventRowController.h"
#import "MSEvent.h"
#import "MSPlayer.h"
#import "MSTeam.h"

typedef enum {
    MATCH_EVENT_NO_EVENT = 0,
    MATCH_EVENT_GOAL = 1,
    MATCH_EVENT_YELLOW_CARD = 2,
    MATCH_EVENT_RED_CARD = 3,
    MATCH_EVENT_PENALTY =4
} MatchEventType;

@interface MSMatchEventRowController ()

@property (nonatomic,weak) IBOutlet WKInterfaceGroup *stateGroup;
@property (nonatomic,weak) IBOutlet WKInterfaceLabel *eventNameLabel;
@property (nonatomic,weak) IBOutlet WKInterfaceLabel *eventLabel;
@property (nonatomic,weak) IBOutlet WKInterfaceLabel *timeLabel;

@end

@implementation MSMatchEventRowController

-(void)setMatchEvent:(MSEvent *)matchEvent {
    
    if (matchEvent.time_minute !=nil) {
        self.timeLabel.text = [NSString stringWithFormat:@"%d'",[matchEvent.time_minute integerValue]];
    }
    
    switch ([matchEvent.eventType integerValue]) {
        case 1:
            self.eventNameLabel.text = @"Goal scored";
            break;
        case 2:
            self.eventNameLabel.text = @"Yellow card";
            break;
        case 3:
            self.eventNameLabel.text = @"Red card";
            break;
        case 4:
            self.eventNameLabel.text = @"Penalty";
            break;
        default:
            break;
    }
    
    self.eventLabel.text = [NSString stringWithFormat:@"%@, %@. Score: %@."];

}

@end
