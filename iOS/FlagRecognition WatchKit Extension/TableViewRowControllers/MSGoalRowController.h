//
//  MSGoalRowController.h
//  FlagRecognition
//
//  Created by Mykyta Karpyshyn on 1/27/16.
//  Copyright © 2016 DataArt Solutions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface MSGoalRowController : NSObject

- (void)setAuthor:(NSString *)author time:(NSString *)time isLeftComand:(BOOL)isLeft;

@end
