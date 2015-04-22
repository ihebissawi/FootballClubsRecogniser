//
//  MSShowableData.m
//  FlagRecognition
//
//  Created by Igor Litvinenko on 12/4/14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import "MSShowableData.h"

@implementation MSShowableData

+ (instancetype)objectWith:(NSString *)title subtitle:(NSAttributedString *)subtitle imageUrl:(NSString *)imageUrl{
	return  [self objectWith:title subtitle:subtitle imageUrl:imageUrl checked:NO];
}
+ (instancetype)objectWith:(NSString *)title subtitle:(NSAttributedString *)subtitle imageUrl:(NSString *)imageUrl checked:(BOOL)checked{
    MSShowableData * data = [MSShowableData new];
    data.title = title;
    data.subtitle = subtitle;
    data.imageUrl = imageUrl;
	data.checked = checked;
    return data;
}

@end
