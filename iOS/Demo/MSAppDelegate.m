/**
 * Copyright (c) 2012 Moodstocks SAS
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "MSAppDelegate.h"
#import "HTTPClientManager.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "MagicalRecord+AppGroup.h"

#import "CoreData+MagicalRecord.h"

#import "MSSettings.h"

#import "Flurry.h"
//#define DEBUG_BUILD   

@implementation MSAppDelegate

#pragma mark - UIApplication delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[Fabric with:@[CrashlyticsKit]];
	
    [MagicalRecord setupGroupStack];
	
    self.window.backgroundColor = [UIColor whiteColor];
    [Flurry setCrashReportingEnabled:YES];
    //PROD KEY - 86PH2XFH3PJB27H95KBD
    //TEST KEY - RVTM5YCQ6GTH3BWYVDVW
    [Flurry startSession:@"RVTM5YCQ6GTH3BWYVDVW"];
	
	[[HTTPClientManager sharedHTTPClient] requestUserIDIfNeededWithCompletion:
	 ^(BOOL success, NSError *error)
	 {
		 if (success)
		 {
			 UIApplication *application = [UIApplication sharedApplication];
			 if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
			 {
				 UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
																									  |UIUserNotificationTypeSound
																									  |UIUserNotificationTypeAlert) categories:nil];
				 [application registerUserNotificationSettings:settings];
				 [application registerForRemoteNotifications];
			 }
			 else
				 [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
		 }
		 else
			 NSLog(@"%@",error.localizedDescription);
	 }];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[[HTTPClientManager sharedHTTPClient] operationQueue]cancelAllOperations];
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationResignActiveNotification object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationBecomeActiveNotification object:nil];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"badge"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
	if ([userInfo objectForKey:@"content-available"] != nil)
	{
		NSInteger number = [[[NSUserDefaults standardUserDefaults] objectForKey:@"badge"] intValue] + 1;
		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:number];
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:number] forKey:@"badge"];
		if ([userInfo objectForKey:@"text"] != nil)
		{
			NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:@"dates"] mutableCopy];
			if (array == nil)
				array =[NSMutableArray array];
			[array addObject:[userInfo objectForKey:@"text"]];
			[[NSUserDefaults standardUserDefaults] setObject:array forKey:@"dates"];
		}

		[[NSUserDefaults standardUserDefaults] synchronize];
		completionHandler(UIBackgroundFetchResultNewData);
	}
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	return YES;
}

#pragma mark - Push 

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	[[HTTPClientManager sharedHTTPClient] registerForPushNotificationsWithDeviceToken:deviceToken completion:nil];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

@end

