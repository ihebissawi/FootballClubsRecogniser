//
//  MSImageRecognitionViewController.h
//  FlagRecognition
//
//  Created by Viktor Levschanov on 06.03.14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#if (!TARGET_IPHONE_SIMULATOR)

#ifndef APPSTORE
    #define HAS_CLOUD_RECOGNITION
#endif

#import <UIKit/UIKit.h>

@interface MSImageRecognitionViewController : UIViewController

@property (copy, nonatomic) MSCompletionBlockWithData recognizeCompletion;

@end

#endif
