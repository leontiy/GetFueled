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
@property (nonatomic) NSInteger nextPageOffset;
@property (nonatomic) NSInteger totalResults;

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

- (instancetype)init {
    self = [super init];
    if (self) {
        self.api = [[FoursquareApi alloc] initWithDataStore:[ModelManager managedObjectStore]];
        self.totalResults = INT_MAX;
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

- (NSManagedObjectContext *)mainContext {
    return [ModelManager managedObjectStore].mainQueueManagedObjectContext;
}

- (DataRequest *)refresh {
    self.nextPageOffset = 0;
    return [self loadNextPage];
}

- (DataRequest *)loadNextPage {
    if (self.totalResults - self.nextPageOffset <= 0) {
        return nil;
    }

    NSInteger pageSize = MIN(kPageSize, self.totalResults - self.nextPageOffset);

    DataRequest *request = [self.api requestRecommendedVenuesWithOffset:self.nextPageOffset limit:pageSize];
    [request succeeded:^(DataRequest *request, NSDictionary *result) {
        self.totalResults = [result[@"totalResults"] integerValue];
        NSArray *venueIds = result[@"venueIds"];
        NSManagedObjectContext *updateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        updateContext.parentContext = self.mainContext;
        const NSInteger offsetForThisUpdate = self.nextPageOffset;
        self.nextPageOffset += [venueIds count];
        [updateContext performBlock:^{
            if (offsetForThisUpdate == 0) {
                [self deleteRecommendedItemsInContext:updateContext];
            }
            [self createRecommendedItemsWithVenueIds:venueIds offset:offsetForThisUpdate context:updateContext];
        }];
    }];
    return request;
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
        for (RecommendedItem *item in oldItems) {
            [context deleteObject:item];
        }
    }];
}

- (void)createRecommendedItemsWithVenueIds:(NSArray *)venueIds offset:(NSInteger)offset context:(NSManagedObjectContext *)context {
    [context performBlockAndWait:^{
        [venueIds enumerateObjectsUsingBlock:^(NSManagedObjectID *venueId, NSUInteger idx, BOOL *stop) {
            RecommendedItem *item = [context insertNewObjectForEntityForName:@"RecommendedItem"];
            item.index = @(offset + idx);
            item.venue = (Venue *)[context objectWithID:venueId];
        }];
        NSError *error;
        BOOL saved = [context saveToPersistentStore:&error];
        if (!saved) {
            NSLog(@"Can't update recommended items: %@", [error localizedDescription]);
        }
    }];
}


@end
