//
//  NSDate+MSExtensions.h
//  FlagRecognition
//
//  Created by Lexiren on 2/13/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MSExtensions)

@end

NSInteger secondsInDays(NSUInteger days);
NSInteger secondsInHours(NSUInteger hours);
NSInteger secondsInMinutes(NSUInteger minutes);


NSString *stringFromDate(NSDate *date, NSString *format);
NSDate *dateFromFullComponents(NSInteger day, NSInteger month, NSInteger year, NSInteger hours, NSInteger minutes);
NSDateComponents *componentsFromDate(NSDate *date);
