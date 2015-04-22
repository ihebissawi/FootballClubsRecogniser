// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSLeague.h instead.

#import <CoreData/CoreData.h>
#import "MSPerishableEntity.h"

extern const struct MSLeagueAttributes {
	__unsafe_unretained NSString *iD;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *shortName;
} MSLeagueAttributes;

extern const struct MSLeagueRelationships {
	__unsafe_unretained NSString *country;
} MSLeagueRelationships;

extern const struct MSLeagueUserInfo {
	__unsafe_unretained NSString *relatedByAttribute;
} MSLeagueUserInfo;

@class MSCountry;

@interface MSLeagueID : MSPerishableEntityID {}
@end

@interface _MSLeague : MSPerishableEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MSLeagueID* objectID;

@property (nonatomic, strong) NSString* iD;

//- (BOOL)validateID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* shortName;

//- (BOOL)validateShortName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) MSCountry *country;

//- (BOOL)validateCountry:(id*)value_ error:(NSError**)error_;

@end

@interface _MSLeague (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveID;
- (void)setPrimitiveID:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveShortName;
- (void)setPrimitiveShortName:(NSString*)value;

- (MSCountry*)primitiveCountry;
- (void)setPrimitiveCountry:(MSCountry*)value;

@end
