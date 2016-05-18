//
//  MSGoalRowController.m
//  FlagRecognition
//
//  Created by Mykyta Karpyshyn on 1/27/16.
//  Copyright © 2016 DataArt Solutions, Inc. All rights reserved.
//

#import "MSGoalRowController.h"

@interface MSGoalRowController()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *leftTeamLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *rightTeamLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *timeLabel;

@end

@implementation MSGoalRowController

- (void)setAuthor:(NSString *)author time:(NSString *)time isLeftComand:(BOOL)isLeft{
    [self.timeLabel setText:time];
    if(isLeft){
        [self.rightTeamLabel setText:@""];
        [self.leftTeamLabel setText:author];
    }
    else{
        [self.rightTeamLabel setText:author];
        [self.leftTeamLabel setText:@""];
    }
}

@end
