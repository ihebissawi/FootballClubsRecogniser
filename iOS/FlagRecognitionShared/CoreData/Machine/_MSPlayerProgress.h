// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSPlayerProgress.h instead.

#import <CoreData/CoreData.h>
#import "MSPerishableEntity.h"

extern const struct MSPlayerProgressAttributes {
	__unsafe_unretained NSString *appearances;
	__unsafe_unretained NSString *goal;
	__unsafe_unretained NSString *iD;
	__unsafe_unretained NSString *leagueID;
	__unsafe_unretained NSString *leagueName;
	__unsafe_unretained NSString *playerID;
	__unsafe_unretained NSString *redCard;
	__unsafe_unretained NSString *seasonID;
	__unsafe_unretained NSString *seasonName;
	__unsafe_unretained NSString *teamCountryNamePlayingFor;
	__unsafe_unretained NSString *teamID;
	__unsafe_unretained NSString *teamName;
	__unsafe_unretained NSString *yellowCard;
} MSPlayerProgressAttributes;

extern const struct MSPlayerProgressRelationships {
	__unsafe_unretained NSString *player;
} MSPlayerProgressRelationships;

extern const struct MSPlayerProgressUserInfo {
	__unsafe_unretained NSString *relatedByAttribute;
} MSPlayerProgressUserInfo;

@class MSPlayer;

@interface MSPlayerProgressID : MSPerishableEntityID {}
@end

@interface _MSPlayerProgress : MSPerishableEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MSPlayerProgressID* objectID;

@property (nonatomic, strong) NSString* appearances;

//- (BOOL)validateAppearances:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* goal;

//- (BOOL)validateGoal:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* iD;

//- (BOOL)validateID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* leagueID;

//- (BOOL)validateLeagueID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* leagueName;

//- (BOOL)validateLeagueName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* playerID;

//- (BOOL)validatePlayerID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* redCard;

//- (BOOL)validateRedCard:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* seasonID;

//- (BOOL)validateSeasonID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* seasonName;

//- (BOOL)validateSeasonName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* teamCountryNamePlayingFor;

//- (BOOL)validateTeamCountryNamePlayingFor:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* teamID;

//- (BOOL)validateTeamID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* teamName;

//- (BOOL)validateTeamName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* yellowCard;

//- (BOOL)validateYellowCard:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) MSPlayer *player;

//- (BOOL)validatePlayer:(id*)value_ error:(NSError**)error_;

@end

@interface _MSPlayerProgress (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAppearances;
- (void)setPrimitiveAppearances:(NSString*)value;

- (NSString*)primitiveGoal;
- (void)setPrimitiveGoal:(NSString*)value;

- (NSString*)primitiveID;
- (void)setPrimitiveID:(NSString*)value;

- (NSString*)primitiveLeagueID;
- (void)setPrimitiveLeagueID:(NSString*)value;

- (NSString*)primitiveLeagueName;
- (void)setPrimitiveLeagueName:(NSString*)value;

- (NSString*)primitivePlayerID;
- (void)setPrimitivePlayerID:(NSString*)value;

- (NSString*)primitiveRedCard;
- (void)setPrimitiveRedCard:(NSString*)value;

- (NSString*)primitiveSeasonID;
- (void)setPrimitiveSeasonID:(NSString*)value;

- (NSString*)primitiveSeasonName;
- (void)setPrimitiveSeasonName:(NSString*)value;

- (NSString*)primitiveTeamCountryNamePlayingFor;
- (void)setPrimitiveTeamCountryNamePlayingFor:(NSString*)value;

- (NSString*)primitiveTeamID;
- (void)setPrimitiveTeamID:(NSString*)value;

- (NSString*)primitiveTeamName;
- (void)setPrimitiveTeamName:(NSString*)value;

- (NSString*)primitiveYellowCard;
- (void)setPrimitiveYellowCard:(NSString*)value;

- (MSPlayer*)primitivePlayer;
- (void)setPrimitivePlayer:(MSPlayer*)value;

@end
