// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSPlayer.m instead.

#import "_MSPlayer.h"

const struct MSPlayerAttributes MSPlayerAttributes = {
	.age = @"age",
	.birth = @"birth",
	.cityID = @"cityID",
	.cityName = @"cityName",
	.countryID = @"countryID",
	.countryName = @"countryName",
	.firstName = @"firstName",
	.foot = @"foot",
	.height = @"height",
	.iD = @"iD",
	.lastName = @"lastName",
	.nameShort = @"nameShort",
	.photoLink = @"photoLink",
	.playsForCountryID = @"playsForCountryID",
	.playsForTeamID = @"playsForTeamID",
	.playsForTeamName = @"playsForTeamName",
	.positionID = @"positionID",
	.positionName = @"positionName",
	.positionNameShort = @"positionNameShort",
	.shirtNumber = @"shirtNumber",
	.urlLink = @"urlLink",
	.weight = @"weight",
};

const struct MSPlayerRelationships MSPlayerRelationships = {
	.seasonsResults = @"seasonsResults",
	.team = @"team",
    .playerEvents = @"playerEvents"
};

const struct MSPlayerUserInfo MSPlayerUserInfo = {
	.relatedByAttribute = @"iD",
};

@implementation MSPlayerID
@end

@implementation _MSPlayer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MSPlayer" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MSPlayer";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MSPlayer" inManagedObjectContext:moc_];
}

- (MSPlayerID*)objectID {
	return (MSPlayerID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic age;

@dynamic birth;

@dynamic cityID;

@dynamic cityName;

@dynamic countryID;

@dynamic countryName;

@dynamic firstName;

@dynamic foot;

@dynamic height;

@dynamic iD;

@dynamic lastName;

@dynamic nameShort;

@dynamic photoLink;

@dynamic playsForCountryID;

@dynamic playsForTeamID;

@dynamic playsForTeamName;

@dynamic positionID;

@dynamic positionName;

@dynamic positionNameShort;

@dynamic shirtNumber;

@dynamic urlLink;

@dynamic weight;

@dynamic seasonsResults;

- (NSMutableSet*)seasonsResultsSet {
	[self willAccessValueForKey:@"seasonsResults"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"seasonsResults"];

	[self didAccessValueForKey:@"seasonsResults"];
	return result;
}

@dynamic team;

@dynamic playerEvents;

@end

