//
//  MSMatchRowController.h
//  FlagRecognition
//
//  Created by Alexander Peresadchenko on 4/2/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@class MSMatch;

@interface MSMatchRowController : NSObject

-(void)setMatch:(MSMatch*)match;

@end
