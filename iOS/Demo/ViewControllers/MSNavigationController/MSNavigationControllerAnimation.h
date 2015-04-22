//
//  MSNavigationControllerAnimation.h
//  FlagRecognition
//
//  Created by Viktor Levschanov on 18.03.14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSNavigationControllerAnimation <NSObject>

@optional

- (CAAnimation *)popAnimation;
- (CAAnimation *)pushAnimation;

@end
