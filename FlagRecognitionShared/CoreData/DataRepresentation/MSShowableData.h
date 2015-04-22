//
//  MSShowableData.h
//  FlagRecognition
//
//  Created by Igor Litvinenko on 12/4/14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSShowableData : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSAttributedString * subtitle;
@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, unsafe_unretained) BOOL checked;

+ (instancetype) objectWith: (NSString *) title subtitle: (NSAttributedString *) subtitle imageUrl: (NSString *) imageUrl;
+ (instancetype) objectWith: (NSString *) title subtitle: (NSAttributedString *) subtitle imageUrl: (NSString *) imageUrl checked:(BOOL)checked;

@end
