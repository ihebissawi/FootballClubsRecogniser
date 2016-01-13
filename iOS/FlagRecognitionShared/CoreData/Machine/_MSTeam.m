// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSTeam.m instead.

#import "_MSTeam.h"

const struct MSTeamAttributes MSTeamAttributes = {
	.cityID = @"cityID",
	.cityName = @"cityName",
	.coach = @"coach",
	.currentLeagueID = @"currentLeagueID",
	.currentLeagueName = @"currentLeagueName",
	.currentSeasonID = @"currentSeasonID",
	.currentSeasonName = @"currentSeasonName",
	.email = @"email",
	.favorite = @"favorite",
	.fax = @"fax",
	.founded = @"founded",
	.homeAddress = @"homeAddress",
	.homeCountryID = @"homeCountryID",
	.homeCountryName = @"homeCountryName",
	.iD = @"iD",
	.logo = @"logo",
	.matchesLastUpdateDate = @"matchesLastUpdateDate",
	.name = @"name",
	.phone = @"phone",
	.playersLastUpdateDate = @"playersLastUpdateDate",
	.playingCountryID = @"playingCountryID",
	.playingCountryName = @"playingCountryName",
	.shortName = @"shortName",
	.stadium = @"stadium",
	.synced = @"synced",
	.teamColor = @"teamColor",
	.url = @"url",
};

const struct MSTeamRelationships MSTeamRelationships = {
	.awayMatches = @"awayMatches",
	.homeMatches = @"homeMatches",
	.squad = @"squad",
	.teamEvents = @"teamEvents",
};

const struct MSTeamUserInfo MSTeamUserInfo = {
	.relatedByAttribute = @"iD",
};

@implementation MSTeamID
@end

@implementation _MSTeam

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MSTeam" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MSTeam";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MSTeam" inManagedObjectContext:moc_];
}

- (MSTeamID*)objectID {
	return (MSTeamID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"favoriteValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"favorite"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"syncedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"synced"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic cityID;

@dynamic cityName;

@dynamic coach;

@dynamic currentLeagueID;

@dynamic currentLeagueName;

@dynamic currentSeasonID;

@dynamic currentSeasonName;

@dynamic email;

@dynamic favorite;

- (BOOL)favoriteValue {
	NSNumber *result = [self favorite];
	return [result boolValue];
}

- (void)setFavoriteValue:(BOOL)value_ {
	[self setFavorite:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFavoriteValue {
	NSNumber *result = [self primitiveFavorite];
	return [result boolValue];
}

- (void)setPrimitiveFavoriteValue:(BOOL)value_ {
	[self setPrimitiveFavorite:[NSNumber numberWithBool:value_]];
}

@dynamic fax;

@dynamic founded;

@dynamic homeAddress;

@dynamic homeCountryID;

@dynamic homeCountryName;

@dynamic iD;

@dynamic logo;

@dynamic matchesLastUpdateDate;

@dynamic name;

@dynamic phone;

@dynamic playersLastUpdateDate;

@dynamic playingCountryID;

@dynamic playingCountryName;

@dynamic shortName;

@dynamic stadium;

@dynamic synced;

- (BOOL)syncedValue {
	NSNumber *result = [self synced];
	return [result boolValue];
}

- (void)setSyncedValue:(BOOL)value_ {
	[self setSynced:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSyncedValue {
	NSNumber *result = [self primitiveSynced];
	return [result boolValue];
}

- (void)setPrimitiveSyncedValue:(BOOL)value_ {
	[self setPrimitiveSynced:[NSNumber numberWithBool:value_]];
}

@dynamic teamColor;

@dynamic url;

@dynamic awayMatches;

- (NSMutableSet*)awayMatchesSet {
	[self willAccessValueForKey:@"awayMatches"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"awayMatches"];

	[self didAccessValueForKey:@"awayMatches"];
	return result;
}

@dynamic homeMatches;

- (NSMutableSet*)homeMatchesSet {
	[self willAccessValueForKey:@"homeMatches"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"homeMatches"];

	[self didAccessValueForKey:@"homeMatches"];
	return result;
}

@dynamic squad;

- (NSMutableSet*)squadSet {
	[self willAccessValueForKey:@"squad"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"squad"];

	[self didAccessValueForKey:@"squad"];
	return result;
}

@dynamic teamEvents;

- (NSMutableSet*)teamEventsSet {
	[self willAccessValueForKey:@"teamEvents"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"teamEvents"];

	[self didAccessValueForKey:@"teamEvents"];
	return result;
}

@end

