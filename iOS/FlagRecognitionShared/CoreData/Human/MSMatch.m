#import "MSMatch.h"

#import "MSTeam.h"

#import "NSDate+MSExtensions.h"

#import "MSEvent.h"

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

- (void)shouldImportMatchEvents:(id)data{
    for(MSEvent * eventToDelete in self.matchEvents){
        [self.managedObjectContext deleteObject:eventToDelete];
    }
    
    for(NSDictionary * eventDitionary in data){
        MSEvent * newEvent = [MSEvent insertInManagedObjectContext:self.managedObjectContext];
        newEvent.eventType = [NSNumber numberWithInteger: [eventDitionary[@"event_type"] integerValue]];
        newEvent.authorName = eventDitionary[@"event_author"];
        newEvent.teamID = eventDitionary[@"team_id"];
        newEvent.time_minute = eventDitionary[@"time_minute"];
        newEvent.score = eventDitionary[@"score"];
        newEvent.eventDescription = eventDitionary[@"alert_message"];
        [self addMatchEventsObject:newEvent];
        
        MSTeam * team = [MSTeam MR_findFirstByAttribute:@"iD" withValue:eventDitionary[@"team_id"] inContext:self.managedObjectContext];
        if(team){
            [newEvent setTeam:team];
        }
    }
    
    NSError * error = nil;
    [self.managedObjectContext save:&error];
    if(error){
        NSLog(@"Error on saving match event: %@",error.localizedDescription);
    }
}


- (BOOL)notFinished
{
    if(self.score.length == 0){
        return YES;
    }
    return NO;
    
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
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"eventType IN {1,2,3,4} AND match = %@",self];
    NSFetchRequest * request = [MSEvent MR_requestAllSortedBy:@"time_minute" ascending:NO];
    [request setPredicate:predicate];
    NSArray * events = [MSEvent MR_executeFetchRequest:request inContext:self.managedObjectContext];
    return events;
}

- (NSArray *)goalEvents {
    if (!self.matchEvents.count) {
        return nil;
    }
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"eventType = 1 AND match = %@",self];
    NSFetchRequest * request = [MSEvent MR_requestAllSortedBy:@"time_minute" ascending:NO];
    [request setPredicate:predicate];
    NSArray * events = [MSEvent MR_executeFetchRequest:request inContext:self.managedObjectContext];
    return events;
}
- (NSString *)humanScore{
    if([self.score length] > 0){
        return self.score;
    }
    else{
        return @"-";
    }
}

+ (instancetype)matchWithId:(NSString *)matchId{
    return [MSMatch MR_findFirstByAttribute:@"iD" withValue:matchId];
}

@end
