//
//  MSEvent.h
//  FlagRecognition
//
//  Created by Darya Shabadash on 6/23/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MSPerishableEntity.h"

@interface MSEventID : MSPerishableEntityID {}
@end

@class MSMatch, MSPlayer, MSTeam;

@interface _MSEvent : MSPerishableEntity {}

@property (nonatomic, retain) NSNumber * eventType;
@property (nonatomic, retain) NSString * iD;
@property (nonatomic, retain) NSString * matchID;
@property (nonatomic, retain) NSString * playerID;
@property (nonatomic, retain) NSString * score;
@property (nonatomic, retain) NSString * teamID;
@property (nonatomic, retain) NSNumber * time_minute;
@property (nonatomic, retain) MSMatch *match;
@property (nonatomic, retain) MSPlayer *player;
@property (nonatomic, retain) MSTeam *team;

@end
