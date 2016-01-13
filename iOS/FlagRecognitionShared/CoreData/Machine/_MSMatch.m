// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSMatch.m instead.

#import "_MSMatch.h"

const struct MSMatchAttributes MSMatchAttributes = {
	.dateString = @"dateString",
	.iD = @"iD",
	.leagueID = @"leagueID",
	.leagueName = @"leagueName",
	.score = @"score",
	.seasonID = @"seasonID",
	.seasonName = @"seasonName",
	.teamAwayID = @"teamAwayID",
	.teamAwayName = @"teamAwayName",
	.teamHomeID = @"teamHomeID",
	.teamHomeName = @"teamHomeName",
	.timestamp = @"timestamp",
};

const struct MSMatchRelationships MSMatchRelationships = {
	.matchEvents = @"matchEvents",
	.teamAway = @"teamAway",
	.teamHome = @"teamHome",
};

const struct MSMatchUserInfo MSMatchUserInfo = {
	.relatedByAttribute = @"iD",
};

@implementation MSMatchID
@end

@implementation _MSMatch

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MSMatch" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MSMatch";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MSMatch" inManagedObjectContext:moc_];
}

- (MSMatchID*)objectID {
	return (MSMatchID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic dateString;

@dynamic iD;

@dynamic leagueID;

@dynamic leagueName;

@dynamic score;

@dynamic seasonID;

@dynamic seasonName;

@dynamic teamAwayID;

@dynamic teamAwayName;

@dynamic teamHomeID;

@dynamic teamHomeName;

@dynamic timestamp;

@dynamic matchEvents;

- (NSMutableSet*)matchEventsSet {
	[self willAccessValueForKey:@"matchEvents"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"matchEvents"];

	[self didAccessValueForKey:@"matchEvents"];
	return result;
}

@dynamic teamAway;

@dynamic teamHome;

@end

