//
//  MSImageRecognitionSession.m
//  FlagRecognition
//
//  Created by Viktor Levschanov on 06.03.14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#if (!TARGET_IPHONE_SIMULATOR)

#import "MSImageRecognitionSession.h"
#import <QCAR/QCAR.h>
#import <QCAR/QCAR_iOS.h>
#import <QCAR/Tool.h>
#import <QCAR/Renderer.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/VideoBackgroundConfig.h>
#import <QCAR/UpdateCallback.h>
#import <QCAR/TrackerManager.h>
#import <QCAR/ImageTracker.h>
#import <QCAR/Trackable.h>
#import <QCAR/DataSet.h>
#import <QCAR/TrackableResult.h>
#import <QCAR/TargetFinder.h>
#import <QCAR/Trackable.h>
#import <QCAR/ImageTarget.h>
#import <AVFoundation/AVFoundation.h>

namespace {
    // --- Data private to this unit ---
    
    // NSerror domain for errors coming from the Sample application template classes
    static NSString * const MSImageRecognitionSessionErrorDomain = @"ImageRecognitionSessionErrorDomain";
    
    static const int MS_QCARInitFlags = QCAR::GL_20;
    
    // instance of the seesion used to support the QCAR callback there should be only one instance of a session at any given point of time
    static MSImageRecognitionSession* __sharedInstance = nil;
    static BOOL __initialized = NO;
    
    // camera to use for the session
    QCAR::CameraDevice::CAMERA mCamera = QCAR::CameraDevice::CAMERA_DEFAULT;
    
    // class used to support the QCAR callback mechanism
    class VuforiaApplication_UpdateCallback : public QCAR::UpdateCallback {
        virtual void QCAR_onUpdate(QCAR::State& state);
    } qcarUpdate;
}

static inline void MSDispatchMain(void (^block)(void)) {
    dispatch_async(dispatch_get_main_queue(), block);
}

NSString * const MSImageRecognitionCloudAccessKey = @"MSImageRecognitionCloudAccessKey";
NSString * const MSImageRecognitionCloudSecretKey = @"MSImageRecognitionCloudSecretKey";

@interface MSImageRecognitionSession () {
    CGSize                  _boundsSize;
    UIInterfaceOrientation  _interfaceOrientation;
    
    dispatch_queue_t _dispatchQueue;
    
    QCAR::DataSet **_dataSets;
    NSInteger       _dataSetsCount;
    
    BOOL _isCloudRecognition;
}

@property (atomic, readwrite) BOOL cameraIsActive;

@property (nonatomic, copy) MSImageRecognitionBlock recognitionBlock;

@end

@implementation MSImageRecognitionSession

// Determine whether the device has a retina display
+ (BOOL)isRetinaDisplay {
    // If UIScreen mainScreen responds to selector displayLinkWithTarget:selector: and the scale property is 2.0, then this is a retina display
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && 2.0 == [UIScreen mainScreen].scale);
}

- (BOOL) isRetinaDisplay{
    return [[self class] isRetinaDisplay];
}

#pragma mark - Cleanup

- (void)cleanupSession:(MSImageRecognitionCompletionBlock)completion; {
    MSImageRecognitionCompletionBlock blockCopy = completion ? [completion copy] : nil;
    
    dispatch_async(_dispatchQueue, ^{
        self.recognitionBlock = nil;
        if(_dataSets) {
            delete[] _dataSets;
            _dataSets = NULL;
        }
        if(blockCopy) {
            MSDispatchMain(^{
                blockCopy(YES, nil);
            });
        }
    });
}

#pragma mark - Init

+ (instancetype)sharedSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [MSImageRecognitionSession new];
    });
    return __sharedInstance;
}

- (id)init {
    self = [super init];
    if(self) {
        QCAR::registerCallback(&qcarUpdate);
        _interfaceOrientation = UIInterfaceOrientationPortrait;
        _dispatchQueue = dispatch_queue_create("imageRecognitionSession.queue.FlagRecognition", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)initializeSessionOnCloud:(BOOL)isCloudRecognition withCompletion:(MSImageRecognitionCompletionBlock)completion {
    dispatch_async(_dispatchQueue, ^{
        _isCloudRecognition = isCloudRecognition;
        
        NSError *error = nil;
        MSImageRecognitionCompletionBlock blockCopy = completion ? [completion copy] : nil;
        
        if(!__initialized && ![self initialize:&error]) {
            NSLog(@"Failed to initialize image recognition session: %@", error);
        }
        MSDispatchMain(^{
            if(blockCopy) blockCopy(error == nil, error);
        });
    });
}

// Initialize the Vuforia SDK
- (BOOL)initialize:(NSError **)error {
    DLog(@"");
    NSParameterAssert(error);
    self.cameraIsActive  = NO;
    self.cameraIsStarted = NO;
    
    // If this device has a retina display, we expect the view bounds to have been scaled up by a factor of 2; this allows it to calculate the size and position of
    // the viewport correctly when rendering the video background. The ARViewBoundsSize is the dimension of the AR view as seen in portrait, even if the orientation is landscape
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if ([MSImageRecognitionSession isRetinaDisplay]) {
        screenSize.width  *= 2.0;
        screenSize.height *= 2.0;
    }
    _boundsSize = screenSize;
    
    // Initialising QCAR is a potentially lengthy operation, so perform it on a background thread
    
    QCAR::setInitParameters(MS_QCARInitFlags);
    
    // QCAR::init() will return positive numbers up to 100 as it progresses towards success.  Negative numbers indicate error conditions
    NSInteger initSuccess = 0;
    do {
        initSuccess = QCAR::init();
    } while (0 <= initSuccess && 100 > initSuccess);
    
    if(initSuccess != 100) {
        *error = [self errorWithCode:E_INITIALIZING_QCAR];
        return NO;
    }
    
    [self prepareAR];
    
    __initialized = YES;
    
    return YES;
}

- (void)prepareAR  {
    // Tell QCAR we've created a drawing surface
    QCAR::onSurfaceCreated();
    
    // Frames from the camera are always landscape, no matter what the orientation of the device.  Tell QCAR to rotate the video background (and
    // the projection matrix it provides to us for rendering our augmentation) by the proper angle in order to match the EAGLView orientation
    switch (_interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            QCAR::setRotation(QCAR::ROTATE_IOS_90);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            QCAR::setRotation(QCAR::ROTATE_IOS_270);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            QCAR::setRotation(QCAR::ROTATE_IOS_180);
            break;
        case UIInterfaceOrientationLandscapeRight:
            QCAR::setRotation(1);
            break;
    }
    
    if(UIInterfaceOrientationIsPortrait(_interfaceOrientation)) {
        QCAR::onSurfaceChanged(_boundsSize.width, _boundsSize.height);
    }
    else {
        QCAR::onSurfaceChanged(_boundsSize.height, _boundsSize.width);
    }
}

#pragma mark - AR control

- (void)resumeAR:(MSImageRecognitionCompletionBlock)block {
    dispatch_async(_dispatchQueue, ^{
        NSError *error = nil;
        MSImageRecognitionCompletionBlock blockCopy = block ? [block copy] : nil;
        
        QCAR::onResume();
        
        // if the camera was previously started, but not currently active, then we restart it
        if ((self.cameraIsStarted) && (! self.cameraIsActive)) {
            
            // initialize the camera
            if (! QCAR::CameraDevice::getInstance().init(mCamera)) {
                [self errorWithCode:E_INITIALIZING_CAMERA error:&error];
                MSDispatchMain(^{
                    if(blockCopy) blockCopy(NO, error);
                });
                return;
            }
            
            // start the camera
            if (!QCAR::CameraDevice::getInstance().start()) {
                [self errorWithCode:E_STARTING_CAMERA error:&error];
                MSDispatchMain(^{
                    if(blockCopy) blockCopy(NO, error);
                });
                return;
            }
            
            self.cameraIsActive = YES;
        }
        MSDispatchMain(^{
            if(blockCopy) blockCopy(YES, nil);
        });
    });
}

- (void)pauseAR:(MSImageRecognitionCompletionBlock)block {
    dispatch_async(_dispatchQueue, ^{
        MSImageRecognitionCompletionBlock blockCopy = block ? [block copy] : nil;
        
        if (self.cameraIsActive) {
            NSError *error = nil;
            // Stop and deinit the camera
            if(! QCAR::CameraDevice::getInstance().stop()) {
                [self errorWithCode:E_STOPPING_CAMERA error:&error];
                MSDispatchMain(^{
                    if(blockCopy) blockCopy(NO, error);
                });
                return;
            }
            if(! QCAR::CameraDevice::getInstance().deinit()) {
                [self errorWithCode:E_DEINIT_CAMERA error:&error];
                MSDispatchMain(^{
                    if(blockCopy) blockCopy(NO, error);
                });
                return;
            }
            self.cameraIsActive = NO;
        }
        QCAR::onPause();
        
        MSDispatchMain(^{
            if(blockCopy) blockCopy(YES, nil);
        });
    });
}

- (void)startAR:(MSImageRecognitionCompletionBlock)block recognitionBlock:(MSImageRecognitionBlock)recognitionBlock; {
    __block NSError * error_ = nil;
    __block BOOL isSuccess = YES;
    MSImageRecognitionCompletionBlock blockCopy = block ? [block copy] : nil;
    self.recognitionBlock = recognitionBlock;

    if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType:completionHandler:)]) {
        // Completion handler will be dispatched on a separate thread
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (YES == granted) {
                isSuccess = [self startCamera:QCAR::CameraDevice::CAMERA_BACK viewWidth:_boundsSize.width andHeight:_boundsSize.height error:&error_];
                if (isSuccess) {
                    self.cameraIsActive = YES;
                    self.cameraIsStarted = YES;
                }
            } else {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Permissions Error" message:@"Please allow to use camera in Settings > Privacy > Camera" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alert show];
            }
            self.cameraIsActive = NO;
            self.cameraIsStarted = NO;
            MSDispatchMain(^{
                if(blockCopy) blockCopy(isSuccess, error_);
            });
        }];
    } else {
        isSuccess = [self startCamera:QCAR::CameraDevice::CAMERA_BACK viewWidth:_boundsSize.width andHeight:_boundsSize.height error:&error_];
        if (isSuccess) {
            self.cameraIsActive = YES;
            self.cameraIsStarted = YES;
        }
        if(blockCopy) blockCopy(isSuccess, error_);
    }
}

// Stop QCAR camera
- (void)stopAR:(MSImageRecognitionCompletionBlock)block {
    dispatch_async(_dispatchQueue, ^{
        NSError *error = nil;
        MSImageRecognitionCompletionBlock blockCopy = block ? [block copy] : nil;
        
        // Stop the camera
        if (self.cameraIsActive) {
            // Stop and deinit the camera
            QCAR::CameraDevice::getInstance().stop();
            QCAR::CameraDevice::getInstance().deinit();
            self.cameraIsActive = NO;
        }
        self.cameraIsStarted = NO;
        
        // ask the application to stop the trackers
        if(![self stopTrackers]) {
            [self errorWithCode:E_STOPPING_TRACKERS error:&error];
            MSDispatchMain(^{
                if(blockCopy) blockCopy(NO, error);
            });
            return;
        }
        
        // ask the application to unload the data associated to the trackers
        if(![self deactivateDataSets]) {
            [self errorWithCode:E_UNLOADING_TRACKERS_DATA error:&error];
            MSDispatchMain(^{
                if(blockCopy) blockCopy(NO, error);
            });
            return;
        }
        
        // ask the application to deinit the trackers
        [self deinitTrackers];
        
        // Pause and deinitialise QCAR
        QCAR::onPause();
        //    QCAR::deinit();
        
        MSDispatchMain(^{
            if(blockCopy) blockCopy(YES, nil);
        });
    });
}

// stop the camera
- (void)stopCamera:(MSImageRecognitionCompletionBlock)block {
    dispatch_async(_dispatchQueue, ^{
        NSError *error = nil;
        MSImageRecognitionCompletionBlock blockCopy = block ? [block copy] : nil;
        
        if (self.cameraIsActive) {
            // Stop and deinit the camera
            QCAR::CameraDevice::getInstance().stop();
            QCAR::CameraDevice::getInstance().deinit();
            self.cameraIsActive = NO;
        } else {
            [self errorWithCode:E_CAMERA_NOT_STARTED error:&error];
            MSDispatchMain(^{
                if(blockCopy) blockCopy(NO, error);
            });
            return;
        }
        self.cameraIsStarted = NO;
        
        // Stop the trackers
        if(![self stopTrackers]) {
            [self errorWithCode:E_STOPPING_TRACKERS error:&error];
            MSDispatchMain(^{
                if(blockCopy) blockCopy(NO, error);
            });
            return;
        }
        MSDispatchMain(^{
            if(blockCopy) blockCopy(YES, nil);
        });
    });
}

// Start QCAR camera with the specified view size
- (BOOL)startCamera:(QCAR::CameraDevice::CAMERA)camera viewWidth:(float)viewWidth andHeight:(float)viewHeight error:(NSError **)error
{
    // initialize the camera
    if (! QCAR::CameraDevice::getInstance().init(camera)) {
        [self errorWithCode:-1 error:error];
        return NO;
    }
    
    // start the camera
    if (!QCAR::CameraDevice::getInstance().start()) {
        [self errorWithCode:-1 error:error];
        return NO;
    }
    
    // we keep track of the current camera to restart this
    // camera when the application comes back to the foreground
    mCamera = camera;
    
    // ask the application to start the tracker(s)
    if(![self startTrackers]) {
        [self errorWithCode:-1 error:error];
        return NO;
    }
    
    // configure QCAR video background
    [self configureVideoBackgroundWithViewWidth:viewWidth andHeight:viewHeight];
    
    // Cache the projection matrix
    const QCAR::CameraCalibration& cameraCalibration = QCAR::CameraDevice::getInstance().getCameraCalibration();
    _projectionMatrix = QCAR::Tool::getProjectionGL(cameraCalibration, 2.0f, 5000.0f);
    return YES;
}

#pragma mark - Trackers management

/*!
 *  @brief Trying to connect to cloud database
 *  @param keys Dictionary that should contains access keys for the cloud DB. Must contain values for MSImageRecognitionCloudAccessKey and MSImageRecognitionCloudSecretKey keys. Cannot be nil.
 *  @param completion Completion block.
 */
- (void)loadCloudTrackerForKeys:(NSDictionary *)keys withCompletion:(MSImageRecognitionCompletionBlock)completion {
    
    NSParameterAssert(keys[MSImageRecognitionCloudAccessKey] && keys[MSImageRecognitionCloudSecretKey]);
    
    MSImageRecognitionCompletionBlock blockCopy = completion ? [completion copy] : nil;
    NSError *error = nil;
    
    if([self initTracker:&error]) {
        [self loadCloudTrackerWithAccessKey:keys[MSImageRecognitionCloudAccessKey] andPrivateKey:keys[MSImageRecognitionCloudSecretKey] error:&error];
    }
    
    MSDispatchMain(^{
        if(blockCopy) blockCopy(error == nil, error);
    });
}

- (void)loadBundledDataSets:(NSArray *)dataSetFilesNames withCompletion:(MSImageRecognitionCompletionBlock)completion {
    dispatch_async(_dispatchQueue, ^{
        NSError *error = nil;
        MSImageRecognitionCompletionBlock blockCopy = completion ? [completion copy] : nil;
        
        if([self initTracker:&error]) {
            
            _dataSetsCount = dataSetFilesNames.count;
            _dataSets = new QCAR::DataSet*[_dataSetsCount];
            
            NSInteger idx   = 0;
            for(NSString *fileName in dataSetFilesNames) {
                QCAR::DataSet *dataSet = [self loadBundleDataSetWithName:fileName];
                if (dataSet == NULL) {
                    NSLog(@"Failed to load datasets");
                    error = [self errorWithCode:E_LOADING_TRACKERS_DATA];
                    break;
                }
                if (![self activateDataSet:dataSet]) {
                    NSLog(@"Failed to activate dataset");
                    error = [self errorWithCode:E_LOADING_TRACKERS_DATA];
                    break;
                }
                _dataSets[idx++] = dataSet;
            }
            if(error) {
                if(_dataSets) {
                    delete[] _dataSets;
                }
            }
        }
        
        MSDispatchMain(^{
            if(blockCopy) blockCopy(error == nil, error);
        });
    });
}

- (BOOL)initTracker:(NSError **)error {
    NSParameterAssert(error);
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::Tracker*        trackerBase    = trackerManager.initTracker(QCAR::ImageTracker::getClassType());
    if (!trackerBase){
        trackerBase = trackerManager.getTracker(QCAR::ImageTracker::getClassType());
    }

    if (!trackerBase) {
        NSLog(@"Failed to initialize ImageTracker.");
        *error = [self errorWithCode:E_INIT_TRACKERS];
        return NO;
    }
    
    if(_isCloudRecognition) {
        QCAR::TargetFinder* targetFinder = static_cast<QCAR::ImageTracker*>(trackerBase)->getTargetFinder();
        if (!targetFinder) {
            NSLog(@"Failed to get target finder.");
            *error = [self errorWithCode:E_INIT_TRACKERS];
            return NO;
        }
    }
    
    NSLog(@"Successfully initialized ImageTracker.");
    return YES;
}

- (void)deinitTrackers {
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    trackerManager.deinitTracker(QCAR::ImageTracker::getClassType());
}

- (BOOL)startTrackers {
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::Tracker* tracker = trackerManager.getTracker(QCAR::ImageTracker::getClassType());
    if(tracker == 0) {
        return NO;
    }
    tracker->start();
    
    if(_isCloudRecognition) {
        QCAR::ImageTracker* imageTracker = static_cast<QCAR::ImageTracker*>(tracker);
        QCAR::TargetFinder* targetFinder = imageTracker->getTargetFinder();
        assert (targetFinder != 0);
        targetFinder->startRecognition();
    }
    
    return YES;
}

- (BOOL)stopTrackers {
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ImageTracker* imageTracker = static_cast<QCAR::ImageTracker*>(trackerManager.getTracker(QCAR::ImageTracker::getClassType()));
    
    if (!imageTracker) {
        NSLog(@"ERROR: failed to get the tracker from the tracker manager");
        return NO;
    }
    
    imageTracker->stop();
    DLog(@"INFO: successfully stopped tracker");
    
    if(_isCloudRecognition) { // Stop cloud based recognition:
        QCAR::TargetFinder* targetFinder = imageTracker->getTargetFinder();
        assert(targetFinder != 0);
        targetFinder->stop();
        DLog(@"INFO: successfully stopped cloud tracker");
    }
    return YES;
}

#pragma mark - DataSet loading

- (BOOL)loadCloudTrackerWithAccessKey:(NSString *)accessKey andPrivateKey:(NSString *)privateKey error:(NSError **)error {
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ImageTracker* imageTracker = static_cast<QCAR::ImageTracker*>(trackerManager.getTracker(QCAR::ImageTracker::getClassType()));
    if (imageTracker == NULL) {
        NSLog(@">doLoadTrackersData>Failed to load tracking data set because the ImageTracker has not been initialized.");
        *error = [self errorWithCode:E_LOADING_TRACKERS_DATA];
        return NO;
    }
    
    // Initialize visual search:
    QCAR::TargetFinder* targetFinder = imageTracker->getTargetFinder();
    if (targetFinder == NULL) {
        NSLog(@">doLoadTrackersData>Failed to get target finder.");
        *error = [self errorWithCode:E_LOADING_TRACKERS_DATA];
        return NO;
    }
    
    NSDate *start = [NSDate date];
    
    // Start initialization:
    if (targetFinder->startInit([accessKey cStringUsingEncoding:NSUTF8StringEncoding], [privateKey cStringUsingEncoding:NSUTF8StringEncoding])) {
        targetFinder->waitUntilInitFinished();
        
        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:start];
        
        NSLog(@"waitUntilInitFinished Execution Time: %f", executionTime);
    }
    
    int resultCode = targetFinder->getInitState();
    if ( resultCode != QCAR::TargetFinder::INIT_SUCCESS) {
        
        if (resultCode == QCAR::TargetFinder::INIT_ERROR_NO_NETWORK_CONNECTION) {
            NSLog(@"CloudReco error:QCAR::TargetFinder::INIT_ERROR_NO_NETWORK_CONNECTION");
        }
        else if (resultCode == QCAR::TargetFinder::INIT_ERROR_SERVICE_NOT_AVAILABLE) {
            NSLog(@"CloudReco error:QCAR::TargetFinder::INIT_ERROR_SERVICE_NOT_AVAILABLE");
        }
        else {
            NSLog(@"CloudReco error:%d", resultCode);
        }
        
        int initErrorCode = (resultCode == QCAR::TargetFinder::INIT_ERROR_NO_NETWORK_CONNECTION ? QCAR::TargetFinder::UPDATE_ERROR_NO_NETWORK_CONNECTION
                                                                                                : QCAR::TargetFinder::UPDATE_ERROR_SERVICE_NOT_AVAILABLE);
        *error = [self cloudRecognitionErrorForCode:initErrorCode];
        return NO;
    } else {
        NSLog(@"cloud target finder initialized");
        return YES;
    }
}

- (QCAR::DataSet *)loadBundleDataSetWithName:(NSString *)dataFile {
    DLog(@"loadImageTrackerDataSet (%@)", dataFile);
    QCAR::DataSet * dataSet = NULL;
    
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ImageTracker* imageTracker = static_cast<QCAR::ImageTracker*>(trackerManager.getTracker(QCAR::ImageTracker::getClassType()));
    
    if (NULL == imageTracker) {
        NSLog(@"ERROR: failed to get the ImageTracker from the tracker manager");
        return NULL;
    }
    else {
        dataSet = imageTracker->createDataSet();
        
        if (NULL != dataSet) {
            DLog(@"INFO: successfully loaded data set");
            
            // Load the data set from the app's resources location
            if (!dataSet->load([dataFile cStringUsingEncoding:NSASCIIStringEncoding], QCAR::DataSet::STORAGE_APPRESOURCE)) {
                NSLog(@"ERROR: failed to load data set");
                imageTracker->destroyDataSet(dataSet);
                dataSet = NULL;
            }
        }
        else {
            NSLog(@"ERROR: failed to create data set");
        }
    }
    return dataSet;
}

- (BOOL)activateDataSet:(QCAR::DataSet *)theDataSet {
    BOOL success = NO;
    
    // Get the image tracker:
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ImageTracker* imageTracker = static_cast<QCAR::ImageTracker*>(trackerManager.getTracker(QCAR::ImageTracker::getClassType()));
    
    if (imageTracker == NULL) {
        NSLog(@"Failed to load tracking data set because the ImageTracker has not been initialized.");
    }
    else {
        // Activate the data set:
        if (!imageTracker->activateDataSet(theDataSet)) {
            NSLog(@"Failed to activate data set.");
        }
        else {
            NSLog(@"Successfully activated data set.");
            success = YES;
        }
    }
    return success;
}

- (BOOL)deactivateDataSets {
    // Get the image tracker:
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ImageTracker*   imageTracker   = static_cast<QCAR::ImageTracker*>(trackerManager.getTracker(QCAR::ImageTracker::getClassType()));
    if (imageTracker == NULL) {
        NSLog(@"Failed to unload tracking data set because the ImageTracker has not been initialized.");
        return NO;
    }
    if(_isCloudRecognition) {
        QCAR::TargetFinder* finder = imageTracker->getTargetFinder();
        finder->deinit();
    }
    else {
        for(int i = 0; i < _dataSetsCount; i++) {
            QCAR::DataSet *dataSet = _dataSets[i];
            if(dataSet != NULL) {
                if (imageTracker->deactivateDataSet(dataSet)) {
                    DLog(@"Dataset was deactivated succesfullty");
                    if(imageTracker->destroyDataSet(dataSet)) {
                        DLog(@"Dataset was destroyed succesfullty");
                    }
                    else {
                        NSLog(@"Failed to destroy dataset");
                    }
                }
                else {
                    NSLog(@"Failed to deactivate data set.");
                }
            }
        }
    }
    return YES;
}

#pragma mark - Camera setup

// Configure QCAR with the video background size
- (void)configureVideoBackgroundWithViewWidth:(float)viewWidth andHeight:(float)viewHeight
{
    // Get the default video mode
    QCAR::CameraDevice& cameraDevice = QCAR::CameraDevice::getInstance();
    QCAR::VideoMode videoMode = cameraDevice.getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);
    
    // Configure the video background
    QCAR::VideoBackgroundConfig config;
    config.mEnabled = true;
    config.mSynchronous = true;
    config.mPosition.data[0] = 0.0f;
    config.mPosition.data[1] = 0.0f;
    
    // Determine the orientation of the view.  Note, this simple test assumes
    // that a view is portrait if its height is greater than its width.  This is
    // not always true: it is perfectly reasonable for a view with portrait
    // orientation to be wider than it is high.  The test is suitable for the
    // dimensions used in this sample
    if (UIInterfaceOrientationIsPortrait(_interfaceOrientation)) {
        // --- View is portrait ---
        
        // Compare aspect ratios of video and screen.  If they are different we
        // use the full screen size while maintaining the video's aspect ratio,
        // which naturally entails some cropping of the video
        float aspectRatioVideo = (float)videoMode.mWidth / (float)videoMode.mHeight;
        float aspectRatioView = viewHeight / viewWidth;
        
        if (aspectRatioVideo < aspectRatioView) {
            // Video (when rotated) is wider than the view: crop left and right
            // (top and bottom of video)
            
            // --============--
            // - =          = _
            // - =          = _
            // - =          = _
            // - =          = _
            // - =          = _
            // - =          = _
            // - =          = _
            // - =          = _
            // --============--
            
            config.mSize.data[0] = (int)videoMode.mHeight * (viewHeight / (float)videoMode.mWidth);
            config.mSize.data[1] = (int)viewHeight;
        }
        else {
            // Video (when rotated) is narrower than the view: crop top and
            // bottom (left and right of video).  Also used when aspect ratios
            // match (no cropping)
            
            // ------------
            // -          -
            // -          -
            // ============
            // =          =
            // =          =
            // =          =
            // =          =
            // =          =
            // =          =
            // =          =
            // =          =
            // ============
            // -          -
            // -          -
            // ------------
            
            config.mSize.data[0] = (int)viewWidth;
            config.mSize.data[1] = (int)videoMode.mWidth * (viewWidth / (float)videoMode.mHeight);
        }
    }
    else {
        // --- View is landscape ---
        float temp = viewWidth;
        viewWidth = viewHeight;
        viewHeight = temp;
        
        // Compare aspect ratios of video and screen.  If they are different we
        // use the full screen size while maintaining the video's aspect ratio,
        // which naturally entails some cropping of the video
        float aspectRatioVideo = (float)videoMode.mWidth / (float)videoMode.mHeight;
        float aspectRatioView = viewWidth / viewHeight;
        
        if (aspectRatioVideo < aspectRatioView) {
            // Video is taller than the view: crop top and bottom
            
            // --------------------
            // ====================
            // =                  =
            // =                  =
            // =                  =
            // =                  =
            // ====================
            // --------------------
            
            config.mSize.data[0] = (int)viewWidth;
            config.mSize.data[1] = (int)videoMode.mHeight * (viewWidth / (float)videoMode.mWidth);
        }
        else {
            // Video is wider than the view: crop left and right.  Also used
            // when aspect ratios match (no cropping)
            
            // ---====================---
            // -  =                  =  -
            // -  =                  =  -
            // -  =                  =  -
            // -  =                  =  -
            // ---====================---
            
            config.mSize.data[0] = (int)videoMode.mWidth * (viewHeight / (float)videoMode.mHeight);
            config.mSize.data[1] = (int)viewHeight;
        }
    }
    
    // Calculate the viewport for the app to use when rendering
    TagViewport viewport;
    viewport.posX  = ((viewWidth - config.mSize.data[0]) / 2) + config.mPosition.data[0];
    viewport.posY  = (((int)(viewHeight - config.mSize.data[1])) / (int) 2) + config.mPosition.data[1];
    viewport.sizeX = config.mSize.data[0];
    viewport.sizeY = config.mSize.data[1];
    
    self.viewport = viewport;
    
    DLog(@"VideoBackgroundConfig: size: %d,%d", config.mSize.data[0], config.mSize.data[1]);
    DLog(@"VideoMode:w=%d h=%d", videoMode.mWidth, videoMode.mHeight);
    DLog(@"width=%7.3f height=%7.3f", viewWidth, viewHeight);
    DLog(@"ViewPort: X,Y: %d,%d Size X,Y:%d,%d", viewport.posX,viewport.posY,viewport.sizeX,viewport.sizeY);
    
    // Set the config
    QCAR::Renderer::getInstance().setVideoBackgroundConfig(config);
}

#pragma mark - Error handling

// build a NSError
- (NSError *)errorWithCode:(int) code {
    return [NSError errorWithDomain:MSImageRecognitionSessionErrorDomain code:code userInfo:nil];
}

- (void)errorWithCode:(int) code error:(NSError **) error{
    if (error != NULL) {
        *error = [self errorWithCode:code];
    }
}

- (NSError *)cloudRecognitionErrorForCode:(int)code {
    
    NSString *description;
    NSString *suggestion;
    
    switch (code) {
        case QCAR::TargetFinder::UPDATE_ERROR_NO_NETWORK_CONNECTION:
            description = @"Network Unavailable";
            suggestion = @"Please check your internet connection and try again.";
            break;
        case QCAR::TargetFinder::UPDATE_ERROR_REQUEST_TIMEOUT:
            description = @"Request Timeout";
            suggestion = @"The network request has timed out, please check your internet connection and try again.";
            break;
        case QCAR::TargetFinder::UPDATE_ERROR_SERVICE_NOT_AVAILABLE:
            description = @"Service Unavailable";
            suggestion = @"The cloud recognition service is unavailable, please try again later.";
            break;
        case QCAR::TargetFinder::UPDATE_ERROR_UPDATE_SDK:
            description = @"Unsupported Version";
            suggestion = @"The application is using an unsupported version of Vuforia.";
            break;
        case QCAR::TargetFinder::UPDATE_ERROR_TIMESTAMP_OUT_OF_RANGE:
            description = @"Clock Sync Error";
            suggestion = @"Please update the date and time and try again.";
            break;
        case QCAR::TargetFinder::UPDATE_ERROR_AUTHORIZATION_FAILED:
            description = @"Authorization Error";
            suggestion = @"The cloud recognition service access keys are incorrect or have expired.";
            break;
        case QCAR::TargetFinder::UPDATE_ERROR_PROJECT_SUSPENDED:
            description = @"Authorization Error";
            suggestion = @"The cloud recognition service has been suspended.";
            break;
        case QCAR::TargetFinder::UPDATE_ERROR_BAD_FRAME_QUALITY:
            description = @"Poor Camera Image";
            suggestion = @"The camera does not have enough detail, please try again later";
            break;
        default:
            description = @"Unknown error";
            suggestion = [NSString stringWithFormat:@"An unknown error has occurred (Code %d)", code];
            break;
    }
    return [NSError errorWithDomain:MSImageRecognitionSessionErrorDomain
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey : description,
                                      NSLocalizedRecoverySuggestionErrorKey : suggestion}];
}

#pragma mark - QCAR callback

- (void) QCAR_onUpdate:(QCAR::State *) state {
    if(_isCloudRecognition) {
        QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
        QCAR::ImageTracker* imageTracker = static_cast<QCAR::ImageTracker*>(trackerManager.getTracker(QCAR::ImageTracker::getClassType()));
        QCAR::TargetFinder* finder = imageTracker->getTargetFinder();
        
        // Check if there are new results available:
        const int statusCode = finder->updateSearchResults();
        if (statusCode < 0) {
            // Show a message if we encountered an error:
            NSLog(@"update search result failed:%d", statusCode);
            if (statusCode == QCAR::TargetFinder::UPDATE_ERROR_NO_NETWORK_CONNECTION) {
                //TODO
            }
        }
        else if (statusCode == QCAR::TargetFinder::UPDATE_RESULTS_AVAILABLE) {
            for (int i = 0; i < finder->getResultCount(); ++i)
            {
                const QCAR::TargetSearchResult* result = finder->getResult(i);
                // Check if this target is suitable for tracking:
                if (result->getTrackingRating() > 0)
                {
                    // Create a new Trackable from the result:
                    QCAR::Trackable* newTrackable = finder->enableTracking(*result);
                    if (newTrackable != 0) {
                        //  Avoid entering on ContentMode when a bad target is found
                        //  (Bad Targets are targets that are exists on the CloudReco database but not on our own book database)
                        NSLog(@"Successfully created new trackable '%s' with rating '%d'.", newTrackable->getName(), result->getTrackingRating());
                        
                        NSString *name = [[NSString alloc] initWithUTF8String:newTrackable->getName()];
                        if(name.length) {
                            DLog(@"recognized image with name: %@", name);
                            MSDispatchMain(^{
                                self.recognitionBlock(name);
                            });
                        }
                    }
                    else
                    {
                        NSLog(@"Failed to create new trackable.");
                    }
                }
            }
        }
    }
    else {
        for (int i = 0; i < state->getNumTrackableResults(); ++i) {
            // Get the trackable
            const QCAR::TrackableResult* result = state->getTrackableResult(i);
            const QCAR::Trackable& trackable = result->getTrackable();
            NSString *name = [[NSString alloc] initWithUTF8String:trackable.getName()];
            if(name.length) {
                DLog(@"recognized image with name: %@", name);
                MSDispatchMain(^{
                    self.recognitionBlock(name);
                });
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////
// Callback function called by the tracker when each tracking cycle has finished
void VuforiaApplication_UpdateCallback::QCAR_onUpdate(QCAR::State& state)
{
    if (__sharedInstance != nil) {
        [__sharedInstance QCAR_onUpdate:&state];
    }
}

@end

#endif