//
//  MSImageRecognitionSession.h
//  FlagRecognition
//
//  Created by Viktor Levschanov on 06.03.14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#if (!TARGET_IPHONE_SIMULATOR)

#import <Foundation/Foundation.h>
#import <QCAR/Matrices.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/State.h>
#import <QCAR/DataSet.h>

#define E_INITIALIZING_QCAR         100

#define E_INITIALIZING_CAMERA       110
#define E_STARTING_CAMERA           111
#define E_STOPPING_CAMERA           112
#define E_DEINIT_CAMERA             113

#define E_INIT_TRACKERS             120
#define E_LOADING_TRACKERS_DATA     121
#define E_STARTING_TRACKERS         122
#define E_STOPPING_TRACKERS         123
#define E_UNLOADING_TRACKERS_DATA   124
#define E_DEINIT_TRACKERS           125

#define E_CAMERA_NOT_STARTED        150

#define E_INTERNAL_ERROR                -1

typedef void (^MSImageRecognitionCompletionBlock)(BOOL success, NSError *error);
typedef void (^MSImageRecognitionBlock)(NSString *recognizedName);

extern NSString * const MSImageRecognitionCloudAccessKey;
extern NSString * const MSImageRecognitionCloudSecretKey;

@interface MSImageRecognitionSession : NSObject

@property (nonatomic, readwrite) BOOL cameraIsStarted;
@property (nonatomic, readwrite) QCAR::Matrix44F projectionMatrix;

// Viewport geometry
@property (nonatomic, readwrite) struct TagViewport { int posX, posY, sizeX, sizeY; } viewport;

+ (instancetype)sharedSession;

- (BOOL)isRetinaDisplay;

- (void)initializeSessionOnCloud:(BOOL)isCloudRecognition withCompletion:(MSImageRecognitionCompletionBlock)completion;

- (void)loadCloudTrackerForKeys:(NSDictionary *)keys withCompletion:(MSImageRecognitionCompletionBlock)completion;
- (void)loadBundledDataSets:(NSArray *)dataSetFilesNames withCompletion:(MSImageRecognitionCompletionBlock)completion;

- (void)cleanupSession:(MSImageRecognitionCompletionBlock)completion;

- (void)startAR:(MSImageRecognitionCompletionBlock)block recognitionBlock:(MSImageRecognitionBlock)recognitionBlock;
- (void)pauseAR:(MSImageRecognitionCompletionBlock)block;
- (void)resumeAR:(MSImageRecognitionCompletionBlock)block;
- (void)stopAR:(MSImageRecognitionCompletionBlock)block;

// This can be used if you want to switch between the front and the back camera for instance
- (void)stopCamera:(MSImageRecognitionCompletionBlock)block;

@end

#endif