//
//  NSDate+MSExtensions.m
//  FlagRecognition
//
//  Created by Lexiren on 2/13/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "NSDate+MSExtensions.h"

@implementation NSDate (MSExtensions)
@end

NSInteger secondsInDays(NSUInteger days) {
    return days * secondsInHours(24);
}

NSInteger secondsInHours(NSUInteger hours) {
    return hours * secondsInMinutes(60);
}

NSInteger secondsInMinutes(NSUInteger minutes) {
    return minutes * 60;
}


NSString *stringFromDate(NSDate *date, NSString *format) {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        [formatter setLocale:[NSLocale currentLocale]];
    });
    
    [formatter setDateFormat:format];
    
    NSString *parsedString = [formatter stringFromDate:date];
    
    return parsedString;
}

NSDate *dateFromFullComponents(NSInteger day, NSInteger month, NSInteger year, NSInteger hours, NSInteger minutes) {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setHour:hours];
    [comps setMinute:minutes];
    
    NSDate *parsedDate = [cal dateFromComponents:comps];
    
    return parsedDate;
}

NSDateComponents *componentsFromDate(NSDate *date) {
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |
                         NSDayCalendarUnit | NSHourCalendarUnit |
                         NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar * cal = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [cal components:unitFlags fromDate:date];
    
    return components;
}
