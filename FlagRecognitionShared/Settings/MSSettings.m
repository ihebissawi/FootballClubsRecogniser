//
//  MSSettings.m
//  FlagRecognition
//
//  Created by Lexiren on 2/6/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "MSSettings.h"
#import "MSCountry.h"
#import "CoreData+MagicalRecord.h"
#import "NSDate+MSExtensions.h"

#define kMSExpirationTimeInDays 1 //TODO: remake for settings bundle


@implementation MSSettings

#pragma mark - init

+ (instancetype)settings {
    static MSSettings *staticSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticSettings = [[MSSettings alloc] init];
        staticSettings.currentCountry = [MSCountry MR_findFirstByAttribute:@"iD" withValue:@"1"];
    });
    return staticSettings;
}

#pragma mark - parameters

- (NSTimeInterval)dataExpirationTimeInterval {
    return secondsInDays(kMSExpirationTimeInDays);
}

- (UIColor *)defaultTintColor {
    if (!_defaultTintColor) {
        //_defaultTintColor = [UIColor colorWithRed:2.0/255.0 green:139.0/255.0 blue:181.0/255.0 alpha:1.0]; //light blue
//        _defaultTintColor = [UIColor colorWithRed:187.0/255.0 green:0.0/255.0 blue:33.0/255.0 alpha:1.0]; //bloody red
    }
    return _defaultTintColor;
}

// HTTP/Network errors
typedef NS_ENUM(NSInteger, MRGNetworkErrorCodes)
{
    kHTTPBadRequest = 400,
    kHTTPAuthorizationRequired = 401,
    kHTTPForbidden = 403,
    kHTTPNotFound = 404,
    kHTTPNoLongerExists = 410,
    kHTTPInternalServerError = 500
};


@end
