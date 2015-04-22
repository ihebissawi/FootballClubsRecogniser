// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSCountry.m instead.

#import "_MSCountry.h"

const struct MSCountryAttributes MSCountryAttributes = {
	.fileFlagID = @"fileFlagID",
	.flag = @"flag",
	.iD = @"iD",
	.name = @"name",
};

const struct MSCountryRelationships MSCountryRelationships = {
	.leagues = @"leagues",
};

const struct MSCountryUserInfo MSCountryUserInfo = {
	.relatedByAttribute = @"iD",
};

@implementation MSCountryID
@end

@implementation _MSCountry

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MSCountry" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MSCountry";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MSCountry" inManagedObjectContext:moc_];
}

- (MSCountryID*)objectID {
	return (MSCountryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic fileFlagID;

@dynamic flag;

@dynamic iD;

@dynamic name;

@dynamic leagues;

- (NSMutableSet*)leaguesSet {
	[self willAccessValueForKey:@"leagues"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"leagues"];

	[self didAccessValueForKey:@"leagues"];
	return result;
}

@end

