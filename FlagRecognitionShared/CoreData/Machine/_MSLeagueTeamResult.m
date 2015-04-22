// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSLeagueTeamResult.m instead.

#import "_MSLeagueTeamResult.h"

const struct MSLeagueTeamResultAttributes MSLeagueTeamResultAttributes = {
	.draw = @"draw",
	.goalsAgainst = @"goalsAgainst",
	.goalsFor = @"goalsFor",
	.iD = @"iD",
	.leagueID = @"leagueID",
	.leagueName = @"leagueName",
	.loose = @"loose",
	.played = @"played",
	.position = @"position",
	.pts = @"pts",
	.seasonID = @"seasonID",
	.seasonName = @"seasonName",
	.teamID = @"teamID",
	.teamName = @"teamName",
	.teamPlayedCountryName = @"teamPlayedCountryName",
	.win = @"win",
};

const struct MSLeagueTeamResultUserInfo MSLeagueTeamResultUserInfo = {
	.relatedByAttribute = @"iD",
};

@implementation MSLeagueTeamResultID
@end

@implementation _MSLeagueTeamResult

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MSLeagueTeamResult" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MSLeagueTeamResult";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MSLeagueTeamResult" inManagedObjectContext:moc_];
}

- (MSLeagueTeamResultID*)objectID {
	return (MSLeagueTeamResultID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"positionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"position"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic draw;

@dynamic goalsAgainst;

@dynamic goalsFor;

@dynamic iD;

@dynamic leagueID;

@dynamic leagueName;

@dynamic loose;

@dynamic played;

@dynamic position;

- (int32_t)positionValue {
	NSNumber *result = [self position];
	return [result intValue];
}

- (void)setPositionValue:(int32_t)value_ {
	[self setPosition:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePositionValue {
	NSNumber *result = [self primitivePosition];
	return [result intValue];
}

- (void)setPrimitivePositionValue:(int32_t)value_ {
	[self setPrimitivePosition:[NSNumber numberWithInt:value_]];
}

@dynamic pts;

@dynamic seasonID;

@dynamic seasonName;

@dynamic teamID;

@dynamic teamName;

@dynamic teamPlayedCountryName;

@dynamic win;

@end

