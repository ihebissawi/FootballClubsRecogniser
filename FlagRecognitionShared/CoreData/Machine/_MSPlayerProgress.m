// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSPlayerProgress.m instead.

#import "_MSPlayerProgress.h"

const struct MSPlayerProgressAttributes MSPlayerProgressAttributes = {
	.appearances = @"appearances",
	.goal = @"goal",
	.iD = @"iD",
	.leagueID = @"leagueID",
	.leagueName = @"leagueName",
	.playerID = @"playerID",
	.redCard = @"redCard",
	.seasonID = @"seasonID",
	.seasonName = @"seasonName",
	.teamCountryNamePlayingFor = @"teamCountryNamePlayingFor",
	.teamID = @"teamID",
	.teamName = @"teamName",
	.yellowCard = @"yellowCard",
};

const struct MSPlayerProgressRelationships MSPlayerProgressRelationships = {
	.player = @"player",
};

const struct MSPlayerProgressUserInfo MSPlayerProgressUserInfo = {
	.relatedByAttribute = @"iD",
};

@implementation MSPlayerProgressID
@end

@implementation _MSPlayerProgress

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MSPlayerProgress" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MSPlayerProgress";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MSPlayerProgress" inManagedObjectContext:moc_];
}

- (MSPlayerProgressID*)objectID {
	return (MSPlayerProgressID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic appearances;

@dynamic goal;

@dynamic iD;

@dynamic leagueID;

@dynamic leagueName;

@dynamic playerID;

@dynamic redCard;

@dynamic seasonID;

@dynamic seasonName;

@dynamic teamCountryNamePlayingFor;

@dynamic teamID;

@dynamic teamName;

@dynamic yellowCard;

@dynamic player;

@end

