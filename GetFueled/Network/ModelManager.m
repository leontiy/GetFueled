//
//  DataProvider.m
//  GetFueled
//
//  Created by Leonty Deriglazov on 01/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "ModelManager.h"
#import "FoursquareApi.h"
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>
#import <RXCollections/RXCollection.h>
#import "Venue.h"
#import "RecommendedItem.h"
#import "DataRequest.h"

@import CoreData;


static NSInteger kPageSize = 10;

@interface ModelManager ()

@property (nonatomic, strong) NSMutableArray *mutableObjects;
@property (nonatomic, strong) FoursquareApi *api;

@end

@implementation ModelManager

+ (instancetype)sharedModelManager {
    static ModelManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.api = [[FoursquareApi alloc] initWithDataStore:[ModelManager managedObjectStore]];
    }
    return self;
}

+ (RKManagedObjectStore *)managedObjectStore {
    static RKManagedObjectStore *managedObjectStore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSError *error = nil;
        NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Model" ofType:@"momd"]];
        NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
        [managedObjectStore createPersistentStoreCoordinator];
        NSDictionary *options = @{ NSInferMappingModelAutomaticallyOption : @YES,
                                   NSMigratePersistentStoresAutomaticallyOption: @YES };
        NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Model.sqlite"];
        
        // Handle scheme update: no data migration in this app.
        if (![managedObjectStore addSQLitePersistentStoreAtPath:storePath
                                         fromSeedDatabaseAtPath:nil
                                              withConfiguration:nil
                                                        options:options
                                                          error:&error])
        {
            NSLog(@"Failed to load data model. DB will be deleted");
            NSLog(@"Error: %@", error);
            [[NSFileManager defaultManager] removeItemAtPath:storePath error:&error];
            if (![managedObjectStore addSQLitePersistentStoreAtPath:storePath
                                             fromSeedDatabaseAtPath:nil
                                                  withConfiguration:nil
                                                            options:options
                                                              error:&error]) {
                @throw [NSException exceptionWithName:@"Database error"
                                               reason:@"Failed to re-create database. Bailing out."
                                             userInfo:nil];
            }
        }
        [managedObjectStore createManagedObjectContexts];
    });
    return managedObjectStore;
}

- (RKManagedObjectStore *)managedObjectStore {
    return [ModelManager managedObjectStore];
}

- (NSInteger)objectCount {
    return [self.mutableObjects count];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    id object = self.mutableObjects[indexPath.row];
    if (!object) {
        //[self requestRangeContaining:indexPath];
    }
    return object;
}

- (void)refresh {
    NSInteger offset = 0;
    DataRequest *request = [self.api requestRecommendedVenuesWithOffset:offset limit:kPageSize];
    [request succeeded:^(DataRequest *request, NSDictionary *result) {
        NSArray *venues = result[@"venues"];
        NSManagedObjectContext *updateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        updateContext.parentContext = self.managedObjectStore.mainQueueManagedObjectContext;
        NSArray *venueIds = [venues rx_mapWithBlock:^id(Venue *venue) {
            NSAssert(![venue.objectID isTemporaryID], @"Venues must be persisted at this point.");
            return venue.objectID;
        }];
        [updateContext performBlock:^{
            [self deleteRecommendedItemsInContext:updateContext];
            [venueIds enumerateObjectsUsingBlock:^(NSManagedObjectID *venueId, NSUInteger idx, BOOL *stop) {
                RecommendedItem *item = [updateContext insertNewObjectForEntityForName:@"RecommendedItem"];
                item.index = @(offset + idx);
                item.venue = (Venue *)[updateContext objectWithID:venueId];
            }];
            NSError *error;
            BOOL saved = [updateContext save:&error];
            if (!saved) {
                NSLog(@"Can't update recommended items: %@", [error localizedDescription]);
            }
        }];

    }];
    
}

- (void)deleteRecommendedItemsInContext:(NSManagedObjectContext *)context {
    [context performBlockAndWait:^{
        NSFetchRequest *allRecommendedItems = [NSFetchRequest fetchRequestWithEntityName:@"RecommendedItem"];
        allRecommendedItems.includesPropertyValues = NO;
        NSError *error;
        NSArray *oldItems = [context executeFetchRequest:allRecommendedItems error:&error];
        if (oldItems == nil) {
            NSLog(@"Can't delete recommended items: %@", [error localizedDescription]);
        }
    }];
}

- (void)requestItemAtIndex:(NSInteger)idx {
    //TODO <#here#>
}

- (NSManagedObjectContext *)mainContext {
    return [self managedObjectStore].mainQueueManagedObjectContext;
}

@end
