//
//  NSUserDefaults+AppGroup.m
//  FlagRecognition
//
//  Created by Alexander Peresadchenko on 4/14/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import "NSUserDefaults+AppGroup.h"

NSString * const kUDFlagRecognizerUserID = @"kUDFlagRecognizerUserID";

@implementation NSUserDefaults (AppGroup)

+(NSUserDefaults *)sharedUserDefaults
{
	static NSUserDefaults *_shared;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken,
				  ^{
					   _shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dataart.FlagsRecognizer"];
				  });
	return _shared;
}

@end
