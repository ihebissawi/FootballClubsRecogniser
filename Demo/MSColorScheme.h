//
//  MSColorScheme.h
//  FlagRecognition
//
//  Created by Igor Litvinenko on 12/5/14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSColorScheme : NSObject

@property (nonatomic, strong) UIColor * mainColor;
@property (nonatomic, strong) UIColor * semiMainColor;
@property (nonatomic, strong) UIColor * textColor;
@property (nonatomic, strong) UIColor * textColorSelected;
@property (nonatomic, strong) UIColor * backColor;
@property (nonatomic, strong) UIColor * tabBarColor;
@property (nonatomic, strong) UIColor * tabBarIndicatorColor;

+ (NSDictionary *)correctColors;
+ (NSDictionary *)correctExtraColors;
+ (instancetype)sharedInstance;
+ (void) customScheme:(UIColor*) customColor;
+ (UIColor*) colorWithHexString:(NSString*) color;
+ (UIColor *) getCorrectColor:(UIColor*)teamColor;
+ (UIColor *)readableForBackgroundColor:(UIColor*)color;
@end
