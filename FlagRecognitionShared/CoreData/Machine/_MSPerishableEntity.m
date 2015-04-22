// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSPerishableEntity.m instead.

#import "_MSPerishableEntity.h"

const struct MSPerishableEntityAttributes MSPerishableEntityAttributes = {
	.imageFilePath = @"imageFilePath",
	.lastUpdateDate = @"lastUpdateDate",
};

@implementation MSPerishableEntityID
@end

@implementation _MSPerishableEntity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MSPerishableEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MSPerishableEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MSPerishableEntity" inManagedObjectContext:moc_];
}

- (MSPerishableEntityID*)objectID {
	return (MSPerishableEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic imageFilePath;

@dynamic lastUpdateDate;

@end

