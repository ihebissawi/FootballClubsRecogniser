//
//  MSMatchEventRowController.h
//  FlagRecognition
//
//  Created by Alexander Peresadchenko on 4/2/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@class MSEvent;

@interface MSMatchEventRowController : NSObject

-(void)setMatchEvent:(MSEvent *)matchEvent;

@end
