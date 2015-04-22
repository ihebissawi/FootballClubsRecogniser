//
//  MagicalRecord+AppGroup.m
//  FlagRecognition
//
//  Created by Alexander Peresadchenko on 4/8/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import "MagicalRecord+AppGroup.h"

#import "CoreData+MagicalRecord.h"

@implementation MagicalRecord (AppGroup)

+(void)setupGroupStack
{
	 if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil)
		 return;
	
	NSString *containerPath = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.dataart.FlagsRecognizer"].path;
	NSString *sqlitePath = [NSString stringWithFormat:@"%@/%@", containerPath, @"database.sqlite"];
	NSURL *sqliteURL = [NSURL fileURLWithPath:sqlitePath];
	NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
	NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	[coordinator MR_addSqliteStoreNamed:sqliteURL withOptions:nil];
	[NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
	
	[NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

@end
