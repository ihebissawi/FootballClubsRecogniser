//
//  MSEvent.m
//  FlagRecognition
//
//  Created by Darya Shabadash on 6/24/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import "MSEvent.h"

@implementation MSEvent
- (NSString *)eventTitle{
    if(self.eventTypeValue == 1){
        return @"GOAL!";
    }
    else if(self.eventTypeValue == 2){
        return @"Yellow Card!";
    }
    else if(self.eventTypeValue == 3){
        return @"Red Card!";
    }
    else if(self.eventTypeValue == 4){
        return @"PENALTY!";
    }
    else return nil;
}

- (NSString *)eventHumanDescription{
    return self.eventDescription;
//    if(self.eventTypeValue == 1){
//        return @"Sed ut perspiciatis unde omnis iste natus ";
//    }
//    else if(self.eventTypeValue == 2){
//        return @"But I must explain to you how all this mistaken";
//    }
//    else if(self.eventTypeValue == 3){
//        return @"At vero eos et accusamus et iusto odio ";
//    }
//    else if(self.eventTypeValue == 4){
//        return @"necessitatibus saepe eveniet ut et!";
//    }
//    else return nil;
}

- (NSString *)eventTime{
    return self.time_minute;
}


@end
