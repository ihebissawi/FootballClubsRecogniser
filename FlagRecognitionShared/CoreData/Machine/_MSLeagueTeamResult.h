// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSLeagueTeamResult.h instead.

#import <CoreData/CoreData.h>
#import "MSPerishableEntity.h"

extern const struct MSLeagueTeamResultAttributes {
	__unsafe_unretained NSString *draw;
	__unsafe_unretained NSString *goalsAgainst;
	__unsafe_unretained NSString *goalsFor;
	__unsafe_unretained NSString *iD;
	__unsafe_unretained NSString *leagueID;
	__unsafe_unretained NSString *leagueName;
	__unsafe_unretained NSString *loose;
	__unsafe_unretained NSString *played;
	__unsafe_unretained NSString *position;
	__unsafe_unretained NSString *pts;
	__unsafe_unretained NSString *seasonID;
	__unsafe_unretained NSString *seasonName;
	__unsafe_unretained NSString *teamID;
	__unsafe_unretained NSString *teamName;
	__unsafe_unretained NSString *teamPlayedCountryName;
	__unsafe_unretained NSString *win;
} MSLeagueTeamResultAttributes;

extern const struct MSLeagueTeamResultUserInfo {
	__unsafe_unretained NSString *relatedByAttribute;
} MSLeagueTeamResultUserInfo;

@interface MSLeagueTeamResultID : MSPerishableEntityID {}
@end

@interface _MSLeagueTeamResult : MSPerishableEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MSLeagueTeamResultID* objectID;

@property (nonatomic, strong) NSString* draw;

//- (BOOL)validateDraw:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* goalsAgainst;

//- (BOOL)validateGoalsAgainst:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* goalsFor;

//- (BOOL)validateGoalsFor:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* iD;

//- (BOOL)validateID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* leagueID;

//- (BOOL)validateLeagueID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* leagueName;

//- (BOOL)validateLeagueName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* loose;

//- (BOOL)validateLoose:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* played;

//- (BOOL)validatePlayed:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* position;

@property (atomic) int32_t positionValue;
- (int32_t)positionValue;
- (void)setPositionValue:(int32_t)value_;

//- (BOOL)validatePosition:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* pts;

//- (BOOL)validatePts:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* seasonID;

//- (BOOL)validateSeasonID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* seasonName;

//- (BOOL)validateSeasonName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* teamID;

//- (BOOL)validateTeamID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* teamName;

//- (BOOL)validateTeamName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* teamPlayedCountryName;

//- (BOOL)validateTeamPlayedCountryName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* win;

//- (BOOL)validateWin:(id*)value_ error:(NSError**)error_;

@end

@interface _MSLeagueTeamResult (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDraw;
- (void)setPrimitiveDraw:(NSString*)value;

- (NSString*)primitiveGoalsAgainst;
- (void)setPrimitiveGoalsAgainst:(NSString*)value;

- (NSString*)primitiveGoalsFor;
- (void)setPrimitiveGoalsFor:(NSString*)value;

- (NSString*)primitiveID;
- (void)setPrimitiveID:(NSString*)value;

- (NSString*)primitiveLeagueID;
- (void)setPrimitiveLeagueID:(NSString*)value;

- (NSString*)primitiveLeagueName;
- (void)setPrimitiveLeagueName:(NSString*)value;

- (NSString*)primitiveLoose;
- (void)setPrimitiveLoose:(NSString*)value;

- (NSString*)primitivePlayed;
- (void)setPrimitivePlayed:(NSString*)value;

- (NSNumber*)primitivePosition;
- (void)setPrimitivePosition:(NSNumber*)value;

- (int32_t)primitivePositionValue;
- (void)setPrimitivePositionValue:(int32_t)value_;

- (NSString*)primitivePts;
- (void)setPrimitivePts:(NSString*)value;

- (NSString*)primitiveSeasonID;
- (void)setPrimitiveSeasonID:(NSString*)value;

- (NSString*)primitiveSeasonName;
- (void)setPrimitiveSeasonName:(NSString*)value;

- (NSString*)primitiveTeamID;
- (void)setPrimitiveTeamID:(NSString*)value;

- (NSString*)primitiveTeamName;
- (void)setPrimitiveTeamName:(NSString*)value;

- (NSString*)primitiveTeamPlayedCountryName;
- (void)setPrimitiveTeamPlayedCountryName:(NSString*)value;

- (NSString*)primitiveWin;
- (void)setPrimitiveWin:(NSString*)value;

@end
