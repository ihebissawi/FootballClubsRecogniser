//
//  MSSettings.h
//  FlagRecognition
//
//  Created by Lexiren on 2/6/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//


/*  
 *  This class was made for handling common settings of app in future
 *  including Settings bundle if needed
 */

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

#define kMSCountryDefaultID @"1"

@class MSCountry;

@interface MSSettings : NSObject

@property (nonatomic, strong) MSCountry *currentCountry;
@property (nonatomic, strong) UIColor *defaultTintColor;
@property (nonatomic, assign, readonly) NSTimeInterval dataExpirationTimeInterval;

+ (instancetype)settings;

@end
