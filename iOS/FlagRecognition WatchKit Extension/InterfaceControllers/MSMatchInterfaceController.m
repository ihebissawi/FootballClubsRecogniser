//
//  InterfaceController.m
//  FlagRecognition WatchKit Extension
//
//  Created by Alexander Peresadchenko on 3/27/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import "MSMatchInterfaceController.h"

#import "MagicalRecord+AppGroup.h"

#import "MSDataManager.h"
#import "HTTPClientManager.h"

#import "MSMatchRowController.h"

@interface MSMatchInterfaceController()

@property (nonatomic,strong) NSArray *contentArray;

@property (nonatomic,weak) IBOutlet WKInterfaceTable *matchesTable;

@end


@implementation MSMatchInterfaceController

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];

	[MagicalRecord setupGroupStack];
	
	[self updateMatchesDataWithCompletion:nil];
}

#pragma mark - Data

-(void)updateMatchesDataWithCompletion:(MSCompletionBlock)completion
{
	[[HTTPClientManager sharedHTTPClient] requestUserIDIfNeededWithCompletion:
	 ^(BOOL success, NSError *error)
	 {
		 if (success)
		 {
			 [[MSDataManager sharedManager] requestLastMatchesForFavoriteTeamsForceUpdateFromServer:YES
																					 withCompletion:
			  ^(BOOL success, NSError *error, id data)
			  {
				  self.contentArray = data;
				  
				  [self.matchesTable setNumberOfRows:self.contentArray.count withRowType:@"MatchRow"];
				  
				  NSUInteger index = 0;
				  for (MSMatch *match in self.contentArray)
				  {
					  MSMatchRowController *row = [self.matchesTable rowControllerAtIndex:index];
					  [row setMatch:match];
					  index++;
				  }
			  }];
		 }
		 else
			 NSLog(@"%@",error.localizedDescription);
	 }];
}

@end



