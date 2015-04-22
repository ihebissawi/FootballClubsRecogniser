//
//  MSColorScheme.m
//  FlagRecognition
//
//  Created by Igor Litvinenko on 12/5/14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import "MSColorScheme.h"
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@implementation MSColorScheme
static  NSString const *correctColorKey = @"";

+ (instancetype)sharedInstance
{
    static MSColorScheme *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MSColorScheme alloc] init];
        sharedInstance.backColor = [UIColor colorWithWhite:38.0f/255.0f alpha:1];
        sharedInstance.mainColor = [UIColor colorWithRed:253.0f/255.0f green:23.0f/255.0f blue:55.0f/255.0f alpha:1];
        sharedInstance.semiMainColor = [UIColor colorWithRed:207.0f/255.0f green:0 blue:0 alpha:1];
        sharedInstance.textColor = [UIColor whiteColor];
        sharedInstance.textColorSelected = [UIColor whiteColor];
        sharedInstance.tabBarColor = [UIColor whiteColor];
    });
    return sharedInstance;
}

+ (void)customScheme:(UIColor*) customColor{
    
    [MSColorScheme sharedInstance].backColor = [UIColor colorWithWhite:38.0f/255.0f alpha:1];
    [MSColorScheme sharedInstance].mainColor = customColor;
    [MSColorScheme sharedInstance].semiMainColor = [self.correctExtraColors objectForKey:correctColorKey];
    [MSColorScheme sharedInstance].textColor = [self readableForBackgroundColor:customColor];
    [MSColorScheme sharedInstance].textColorSelected = [UIColor whiteColor];
    [MSColorScheme sharedInstance].tabBarColor = [self readableForBackgroundColor:customColor];
}


#pragma mark - help methods
+ (UIColor *)colorWithHexString:(NSString *)color {
    
    UIColor *colorToReturn;
    if (!color) {
        return [UIColor redColor];
    }
    const char *hexstring = [color UTF8String];
    int number = (int)strtol(hexstring, NULL, 0);
    colorToReturn = UIColorFromRGB(number);
    
    return colorToReturn;
}

+(NSDictionary*)correctColors
{
    static NSDictionary *_currentColors;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentColors = @{@"1":[UIColor colorWithRed:(248/255.0) green:(27/255.0) blue:(44/255.0) alpha:1.0f],
                           
                           @"2":[UIColor colorWithRed:(38/255.0) green:(38/255.0) blue:(38/255.0) alpha:1.0f],
                           
                           @"3":[UIColor colorWithRed:(28/255.0) green:(109/255.0) blue:(209/255.0) alpha:1.0f],
                           
                           @"4":[UIColor colorWithRed:(241/255.0) green:(241/255.0) blue:(241/255.0) alpha:1.0f],
                           
                           @"5":[UIColor colorWithRed:(188/255.0) green:(12/255.0) blue:(39/255.0) alpha:1.0f],
                           
                           @"6":[UIColor colorWithRed:(90/255.0) green:(187/255.0) blue:(255/255.0) alpha:1.0f],
                           
                           @"7":[UIColor colorWithRed:(255/255.0) green:(153/255.0) blue:(0/255.0) alpha:1.0f],
                           
                           @"8":[UIColor colorWithRed:(254/255.0) green:(235/255.0) blue:(1/255.0) alpha:1.0f],
                           
                           @"9":[UIColor colorWithRed:(36/255.0) green:(36/255.0) blue:(120/255.0) alpha:1.0f],
                           
                           @"10":[UIColor colorWithRed:(51/255.0) green:(153/255.0) blue:(255/255.0) alpha:1.0f],
                           
                           @"11":[UIColor colorWithRed:(255/255.0) green:(102/255.0) blue:(0/255.0) alpha:1.0f],
                           
                           @"12":[UIColor colorWithRed:(255/255.0) green:(142/255.0) blue:(4/255.0) alpha:1.0f],
                           
                           @"13":[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(0/255.0) alpha:1.0f],
                           
                           @"14":[UIColor colorWithRed:(51/255.0) green:(153/255.0) blue:(0/255.0) alpha:1.0f],
                           
                           @"15":[UIColor colorWithRed:(255/255.0) green:(191/255.0) blue:(0/255.0) alpha:1.0f],
                           
                           @"16":[UIColor colorWithRed:(254/255.0) green:(235/255.0) blue:(1/255.0) alpha:1.0f],
                           
                           @"17":[UIColor colorWithRed:(255/255.0) green:(204/255.0) blue:(0/255.0) alpha:1.0f],
                           
                           @"18":[UIColor colorWithRed:(255/255.0) green:(251/255.0) blue:(0/255.0) alpha:1.0f],
                           
                           @"19":[UIColor colorWithRed:(6/255.0) green:(141/255.0) blue:(116/255.0) alpha:1.0f],
                           
                           @"20":[UIColor colorWithRed:(251/255.0) green:(214/255.0) blue:(4/255.0) alpha:1.0f],
                           
                           @"21":[UIColor colorWithRed:(189/255.0) green:(30/255.0) blue:(58/255.0) alpha:1.0f]};
    });
    return _currentColors;
}

+(NSDictionary*)correctExtraColors
{
    static NSDictionary *_currentExtraColors;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentExtraColors = @{
                           @"1":[UIColor colorWithRed:(204/255.0) green:(50/255.0) blue:(50/255.0) alpha:1.0f],
                           
                           @"2":[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1.0f],
                           
                           @"3":[UIColor colorWithRed:(20/255.0) green:(82/255.0) blue:(158/255.0) alpha:1.0f],
                           
                           @"4":[UIColor colorWithRed:(220/255.0) green:(220/255.0) blue:(220/255.0) alpha:1.0f],
                           
                           @"5":[UIColor colorWithRed:(143/255.0) green:(13/255.0) blue:(34/255.0) alpha:1.0f],
                           
                           @"6":[UIColor colorWithRed:(65/255.0) green:(150/255.0) blue:(210/255.0) alpha:1.0f],
                           
                           @"7":[UIColor colorWithRed:(205/255.0) green:(123/255.0) blue:(0/255.0) alpha:1.0f],
                           
                           @"8":[UIColor colorWithRed:(216/255.0) green:(200/255.0) blue:(1/255.0) alpha:1.0f],
                           
                           @"9":[UIColor colorWithRed:(54/255.0) green:(54/255.0) blue:(156/255.0) alpha:1.0f],
                           
                           @"10":[UIColor colorWithRed:(38/255.0) green:(123/255.0) blue:(207/255.0) alpha:1.0f],
                           
                           @"11":[UIColor colorWithRed:(210/255.0) green:(86/255.0) blue:(4/255.0) alpha:1.0f],
                           
                           @"12":[UIColor colorWithRed:(212/255.0) green:(117/255.0) blue:(0/255.0) alpha:1.0f],
                           
                           @"13":[UIColor colorWithRed:(219/255.0) green:(219/255.0) blue:(0/255.0) alpha:1.0f],
                           
                           @"14":[UIColor colorWithRed:(36/255.0) green:(109/255.0) blue:(0/255.0) alpha:1.0f],
                           
                           @"15":[UIColor colorWithRed:(215/255.0) green:(161/255.0) blue:(0/255.0) alpha:1.0f],
                           
                           @"16":[UIColor colorWithRed:(207/255.0) green:(155/255.0) blue:(0/255.0) alpha:1.0f],
                           
                           @"17":[UIColor colorWithRed:(221/255.0) green:(177/255.0) blue:(0/255.0) alpha:1.0f],
                           
                           @"18":[UIColor colorWithRed:(213/255.0) green:(210/255.0) blue:(0/255.0) alpha:1.0f],
                           
                           @"19":[UIColor colorWithRed:(5/255.0) green:(108/255.0) blue:(89/255.0) alpha:1.0f],
                           
                           @"20":[UIColor colorWithRed:(203/255.0) green:(174/255.0) blue:(10/255.0) alpha:1.0f],
                           
                           @"21":[UIColor colorWithRed:(140/255.0) green:(19/255.0) blue:(41/255.0) alpha:1.0f]};
    });
    return _currentExtraColors;
}

+(UIColor *) getCorrectColor:(UIColor*)teamColor
{
    CGFloat teamR, teamG, teamB, teamA;
    [teamColor getRed: &teamR green:&teamG blue:&teamB alpha:&teamA];

    UIColor *correctColor;
    float d = 10000;
    for (NSString * key in [self correctColors]) {
        float temp = 0;
        UIColor *color = [self.correctColors objectForKey:key];
        CGFloat currentR, currentG, currentB, currentA;
        [color getRed: &currentR green:&currentG blue:&currentB alpha:&currentA];

//        float g1 = teamR * 0.299 + 0.587*teamG + 0.114*teamB;
//        float g2 = currentR * 0.299 + 0.587*currentG + 0.114*currentB;
//        
//        float cB1 = 128 -  (teamR * 0.1687) - (0.331*teamG) + 0.5*teamB;
//        float cB2 = 128 -  (currentR * 0.1687) - (0.331*currentG) + 0.5*currentB;
//        
//        float cR1 = 128 + teamR * 0.5 - 0.42*teamG - 0.081*teamB;
//        float cR2 = 128 +  currentR * 0.5 - 0.42*currentG - 0.81*currentB;
//        
        //temp = sqrtf(powf(g2 - g1, 2) + powf(cB2 - cB1, 2) + powf(cR2 - cR1, 2));
        
        
        temp = sqrtf(powf(currentR - teamR, 2) + powf(currentG - teamG, 2) + powf(currentB - teamB, 2));
        if (temp<d) {
            d = temp;
            correctColor = color;
            correctColorKey = key;
        }
    }
    
    [correctColor getRed: &teamR green:&teamG blue:&teamB alpha:&teamA];
    return correctColor;
}

+(UIColor *)readableForBackgroundColor:(UIColor*)color {
    
    const CGFloat *componentColors = CGColorGetComponents(color.CGColor);
    
    CGFloat darknessScore = (((componentColors[0]*255) * 299) + ((componentColors[1]*255) * 587) + ((componentColors[2]*255) * 114)) / 1000;
    
    if (darknessScore >= 125) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
        return [UIColor blackColor];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    return [UIColor whiteColor];
}

@end
