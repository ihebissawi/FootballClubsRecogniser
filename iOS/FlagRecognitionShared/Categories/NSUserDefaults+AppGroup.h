//
//  NSUserDefaults+AppGroup.h
//  FlagRecognition
//
//  Created by Alexander Peresadchenko on 4/14/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kUDFlagRecognizerUserID;

@interface NSUserDefaults (AppGroup)

+(NSUserDefaults*)sharedUserDefaults;

@end
