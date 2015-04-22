//
//  MSCommonDefines.h
//  FlagRecognition
//
//  Created by Lexiren on 2/25/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#ifndef FlagRecognition_MSCommonDefines_h
#define FlagRecognition_MSCommonDefines_h

// iOS version check-functions defines
#define MS_iOSVersionEqualTo(v)           ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define MS_iOSVersionGreaterThan(v)         ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define MS_iOSVersionGreaterOrEqualTo(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define MS_iOSVersionLessThan(v)            ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define MS_iOSVersionLessOrEqualTo(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define MS_isIOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
// iOS version check-functions defines

#define MS_isIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define MS_isIPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// ---- screen size defines ---- //
#define MS_IsDeviceScreenSize4Inch ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
// ---- screen size defines ---- //
#define MS_IsDeviceScreenSize4InchOrBigger ([[UIScreen mainScreen] bounds].size.height >= 568)

#endif
