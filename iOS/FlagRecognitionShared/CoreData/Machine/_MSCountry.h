// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSCountry.h instead.

#import <CoreData/CoreData.h>
#import "MSPerishableEntity.h"

extern const struct MSCountryAttributes {
	__unsafe_unretained NSString *fileFlagID;
	__unsafe_unretained NSString *flag;
	__unsafe_unretained NSString *iD;
	__unsafe_unretained NSString *name;
} MSCountryAttributes;

extern const struct MSCountryRelationships {
	__unsafe_unretained NSString *leagues;
} MSCountryRelationships;

extern const struct MSCountryUserInfo {
	__unsafe_unretained NSString *relatedByAttribute;
} MSCountryUserInfo;

@class MSLeague;

@interface MSCountryID : MSPerishableEntityID {}
@end

@interface _MSCountry : MSPerishableEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MSCountryID* objectID;

@property (nonatomic, strong) NSString* fileFlagID;

//- (BOOL)validateFileFlagID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* flag;

//- (BOOL)validateFlag:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* iD;

//- (BOOL)validateID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *leagues;

- (NSMutableSet*)leaguesSet;

@end

@interface _MSCountry (LeaguesCoreDataGeneratedAccessors)
- (void)addLeagues:(NSSet*)value_;
- (void)removeLeagues:(NSSet*)value_;
- (void)addLeaguesObject:(MSLeague*)value_;
- (void)removeLeaguesObject:(MSLeague*)value_;

@end

@interface _MSCountry (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveFileFlagID;
- (void)setPrimitiveFileFlagID:(NSString*)value;

- (NSString*)primitiveFlag;
- (void)setPrimitiveFlag:(NSString*)value;

- (NSString*)primitiveID;
- (void)setPrimitiveID:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSMutableSet*)primitiveLeagues;
- (void)setPrimitiveLeagues:(NSMutableSet*)value;

@end
