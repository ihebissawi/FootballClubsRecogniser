#import "MSMatch.h"

#import "MSTeam.h"

#import "NSDate+MSExtensions.h"

@interface MSMatch ()

// Private interface goes here.

@end


@implementation MSMatch

// Custom logic goes here.

+ (id) MR_importFromObject:(id)objectData inContext:(NSManagedObjectContext *)context
{
    MSMatch *newEntity = [super MR_importFromObject:objectData inContext:context];
	if (newEntity.teamAwayID)
	{
		MSTeam *team = [MSTeam MR_findFirstByAttribute:@"iD" withValue:newEntity.teamAwayID];
		newEntity.teamAway = team;
		[team addAwayMatchesObject:newEntity];
	}
	
	if (newEntity.teamHomeID)
	{
		MSTeam *team = [MSTeam MR_findFirstByAttribute:@"iD" withValue:newEntity.teamHomeID];
		newEntity.teamHome = team;
		[team addHomeMatchesObject:newEntity];
	}
	
    if ([newEntity notFinished])
	{
        NSString *timeString = [newEntity.score stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *timeComponents = [timeString componentsSeparatedByString:@":"];
        if (timeComponents.count == 2)
		{
            NSInteger hours = secondsInHours([timeComponents[0] integerValue]);
            NSInteger minutes = secondsInMinutes([timeComponents[1] integerValue]);
            NSInteger newTimestamp = [newEntity.timestamp integerValue] + hours + minutes;
            
            newEntity.timestamp = [NSString stringWithFormat:@"%ld", (long)newTimestamp];
        }
		else
		{
            //TODO: check whats wrong with format
            NSLog(@"unexpected score format: %@\nMSMatch Entity: %@", newEntity.score, newEntity.description);
        }
    }

    return newEntity;
}

- (BOOL)notFinished
{
    if (self.score.length)
	{
        NSRange substringRange = [self.score rangeOfString:@":"];
        return (substringRange.location != NSNotFound);
    }
    return NO;
}

- (NSDate *)date
{
	NSDate *date = nil;
	if (self.timestamp)
	{
		date = [NSDate dateWithTimeIntervalSince1970:[self.timestamp integerValue]];
    }
    return date;
}

- (NSArray *)events {
    if (!self.matchEvents.count) {
        return nil;
    }
    
    NSArray *events = [self.matchEvents allObjects];
    return events;
    
}


@end
