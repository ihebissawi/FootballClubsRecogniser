//
//  MSImageRecognitionViewController.m
//  FlagRecognition
//
//  Created by Viktor Levschanov on 06.03.14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#if (!TARGET_IPHONE_SIMULATOR)

#import "MSImageRecognitionViewController.h"
#import "MSImageRecognitionSession.h"
#import "MSImageRecognitionEAGLView.h"
#import "UIAlertView+MSExtensions.h"

#ifdef HAS_CLOUD_RECOGNITION
static NSString * const kCloudDBAccesskey = @"89dab607e80bb6fb9b08c9cef0d7da7602b9753f";
static NSString * const kCloudDBSecretkey = @"31a34b8d18921d1ed628068ae6086dce1c13019a";

static NSString * const kIsCloudRecognitionDefaultsKey = @"IsCloudRecognitionDefaultsKey";
#endif

@interface MSImageRecognitionViewController () {
    BOOL _isAppeared;
    BOOL _isCloudRecognition;
}

@property (nonatomic, strong) MSImageRecognitionEAGLView *eaglView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISwitch *cloudRecognitionSwitch;

@end

@implementation MSImageRecognitionViewController

+ (NSArray *)dataSets {
    return @[@"clubs_logos_1.xml", @"clubs_logos_2.xml"];
}

#pragma mark - Lifecycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (MSImageRecognitionEAGLView *) eaglView{
    return (MSImageRecognitionEAGLView *)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
#ifdef HAS_CLOUD_RECOGNITION
    _isCloudRecognition = [self wasCloudRecognition];
#else
    _isCloudRecognition = NO;
#endif
    
    self.cloudRecognitionSwitch.on      = _isCloudRecognition;
    self.cloudRecognitionSwitch.enabled = NO;
    
    [self initImageRecognitionSession:_isCloudRecognition];
    
    _isAppeared = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MSFlurryAnalytics sendScreenName:kFlurryScreenStartRecognition];
#ifdef HAS_CLOUD_RECOGNITION
    [self.navigationController setToolbarHidden:NO];
#else
    [self.navigationController setToolbarHidden:YES];
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
    _isAppeared =  NO;
    [[MSImageRecognitionSession sharedSession] stopAR:^(BOOL success, NSError *error) {
        if(!success || error) {
            NSLog(@"error stopping AR:%@", [error localizedDescription]);
        }
        [[MSImageRecognitionSession sharedSession] cleanupSession:nil];
    }];
    // Be a good OpenGL ES citizen: now that QCAR is paused and the render thread is not executing, inform the root view controller that the EAGLView should finish any OpenGL ES commands
    [self.eaglView finishOpenGLESCommands];
    [self.eaglView freeOpenGLESResources];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        [self.eaglView freeOpenGLESResources];
        self.view = nil;
    }
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
#pragma mark - Actions

- (IBAction)cancelButtonWasTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cloudRecognitionWasChanged:(UISwitch *)sender {
#ifdef HAS_CLOUD_RECOGNITION
    if(_isCloudRecognition == sender.isOn) return;
    
    _isCloudRecognition = sender.isOn;
    
    [self saveCloudRecognitionChoice:_isCloudRecognition];
    
    self.activityIndicator.hidden = NO;
    sender.enabled = NO;
    
    __weak MSImageRecognitionViewController *weakSelf = self;
    [[MSImageRecognitionSession sharedSession] stopAR:^(BOOL success, NSError *error) {
        if(!success || error) {
            NSLog(@"error stopping AR:%@", [error localizedDescription]);
        }
        [[MSImageRecognitionSession sharedSession] cleanupSession:^(BOOL success, NSError *error) {
            MSImageRecognitionViewController *strongSelf = weakSelf;
            if(!strongSelf) return;
            
            if(!success || error) {
                [strongSelf showAlertWithError:error];
                return;
            }
            
            [strongSelf initImageRecognitionSession:strongSelf->_isCloudRecognition];
        }];
    }];
#endif
}

#pragma mark - MSImageRecognitionControl

- (void)initImageRecognitionSession:(BOOL)isCloudRecognition {
    __weak MSImageRecognitionViewController *weakSelf = self;
    [[MSImageRecognitionSession sharedSession] initializeSessionOnCloud:(BOOL)isCloudRecognition withCompletion:^(BOOL success, NSError *error) {
        MSImageRecognitionViewController *strongSelf = weakSelf;
        if(!strongSelf) return;
        if(error) {
            strongSelf.activityIndicator.hidden = YES;
            [strongSelf showAlertWithError:error];
        }
        else {
            [strongSelf onInitARDone];
        }
    }];
}

- (void)onInitARDone {
    if(!_isAppeared) return;
    __weak MSImageRecognitionViewController *weakSelf = self;
    
    if(_isCloudRecognition) {
#ifdef HAS_CLOUD_RECOGNITION
        NSDictionary *keys = @{MSImageRecognitionCloudAccessKey : kCloudDBAccesskey, MSImageRecognitionCloudSecretKey : kCloudDBSecretkey};
        [[MSImageRecognitionSession sharedSession] loadCloudTrackerForKeys:keys withCompletion:^(BOOL success, NSError *error)
         {
             MSImageRecognitionViewController *strongSelf = weakSelf;
             if(!strongSelf || !_isAppeared) return;
             [strongSelf onLoadARDoneWithResult:success error:error];
         }];
#endif
    }
    else {
        [[MSImageRecognitionSession sharedSession] loadBundledDataSets:[self.class dataSets] withCompletion:^(BOOL success, NSError *error)
         {
             MSImageRecognitionViewController *strongSelf = weakSelf;
             if(!strongSelf || !_isAppeared) return;
             [strongSelf onLoadARDoneWithResult:success error:error];
         }];
    }
}

- (void)onLoadARDoneWithResult:(BOOL)success error:(NSError *)error {
    if(success) {
        __weak MSImageRecognitionViewController *weakSelf = self;
        [[MSImageRecognitionSession sharedSession] startAR:^(BOOL success, NSError *error)
         {
             weakSelf.activityIndicator.hidden = YES;
             weakSelf.cloudRecognitionSwitch.enabled = YES;

             if(!_isAppeared) return;
             if(error) {
                 [weakSelf showAlertWithError:error];
             }
         } recognitionBlock:^(NSString *recognizedName)
         {
             MSImageRecognitionViewController *strongSelf = weakSelf;
             if(!strongSelf || !_isAppeared) return;
             [MSFlurryAnalytics sendScreenName:kFlurryScreenSuccessRecognition];
             performCompletionBlockWithData(strongSelf.recognizeCompletion, YES, nil, recognizedName);
             [strongSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
         }];
    }
    if(error) {
        [self showAlertWithError:error];
        self.activityIndicator.hidden = YES;
        self.cloudRecognitionSwitch.enabled = YES;
        self.view.backgroundColor = nil;
    }
}

#pragma mark - App state change

- (void)handleAppWillResignActiveNotification:(NSNotification *)notification {
    __weak MSImageRecognitionViewController *weakSelf = self;
    [[MSImageRecognitionSession sharedSession] pauseAR:^(BOOL success, NSError *error) {
        if(!success || error) {
            NSLog(@"Error pausing AR:%@", [error description]);
        }
        else {
            DLog(@"AR was paused succesfully");
        }
        [weakSelf.eaglView finishOpenGLESCommands];
    }];
}

- (void)handleAppDidBecomeActiveNotification:(NSNotification *)notification {
    [[MSImageRecognitionSession sharedSession] resumeAR:^(BOOL success, NSError *error) {
        if(!success || error) {
            NSLog(@"Error resuming AR:%@", [error description]);
        }
        else {
            DLog(@"AR was resumed succesfully");
        }
    }];
}

#pragma mark - Error handling

- (void)showAlertWithError:(NSError *)error {
    BOOL hasRecoverySuggestion = [error localizedRecoverySuggestion].length;
    NSString *title = hasRecoverySuggestion ? [error localizedDescription] : @"Image recognizer error";
    NSString *msg   = hasRecoverySuggestion ? [error localizedRecoverySuggestion] : [error localizedDescription];
    [UIAlertView MS_showAlertWithTitle:title message:msg andCancelButton:@"Dismiss"];
}

#pragma mark - Cloud recognition defaults

#ifdef HAS_CLOUD_RECOGNITION
- (BOOL)wasCloudRecognition {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [defs boolForKey:kIsCloudRecognitionDefaultsKey];
}

- (void)saveCloudRecognitionChoice:(BOOL)isCloudRecognition {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setBool:isCloudRecognition forKey:kIsCloudRecognitionDefaultsKey];
    [defs synchronize];
}
#endif

@end

#endif