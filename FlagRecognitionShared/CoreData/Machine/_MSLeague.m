// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSLeague.m instead.

#import "_MSLeague.h"

const struct MSLeagueAttributes MSLeagueAttributes = {
	.iD = @"iD",
	.name = @"name",
	.shortName = @"shortName",
};

const struct MSLeagueRelationships MSLeagueRelationships = {
	.country = @"country",
};

const struct MSLeagueUserInfo MSLeagueUserInfo = {
	.relatedByAttribute = @"iD",
};

@implementation MSLeagueID
@end

@implementation _MSLeague

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MSLeague" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MSLeague";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MSLeague" inManagedObjectContext:moc_];
}

- (MSLeagueID*)objectID {
	return (MSLeagueID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic iD;

@dynamic name;

@dynamic shortName;

@dynamic country;

@end

