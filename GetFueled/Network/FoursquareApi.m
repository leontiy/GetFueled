//
//  FoursquareApi.m
//  GetFueled
//
//  Created by Leonty Deriglazov on 27/08/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "FoursquareApi.h"
@import CoreData;
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import <RXCollections/RXCollection.h>

static NSString *const kVenuesExplorePath = @"venues/explore";

@interface FoursquareApi ()

@property (nonatomic, strong) RKObjectManager *objectManager;

@end

@implementation FoursquareApi

+ (instancetype)sharedInstance {
    static FoursquareApi *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FoursquareApi new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURL *baseUrl = [NSURL URLWithString:@"https://api.foursquare.com/v2/"];
        self.objectManager = [RKObjectManager managerWithBaseURL:baseUrl];
        self.objectManager.managedObjectStore = [self configureCoreDataStack];
        RKResponseDescriptor *responseObjectDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self responseMapping]
                                                                                                      method:RKRequestMethodGET
                                                                                                 pathPattern:kVenuesExplorePath
                                                                                                     keyPath:@"response"
                                                                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [self.objectManager addResponseDescriptor:responseObjectDescriptor];
        RKResponseDescriptor *rd = [RKResponseDescriptor responseDescriptorWithMapping:[self groupMapping]
                                                                                method:RKRequestMethodGET
                                                                           pathPattern:kVenuesExplorePath
                                                                               keyPath:@"response.groups"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [self.objectManager addResponseDescriptor:rd];
    }
    return self;
}

- (RKManagedObjectStore *)configureCoreDataStack {
    NSError *error = nil;
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Model" ofType:@"momd"]];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
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
    return managedObjectStore;
}

- (RKObjectMapping *)responseMapping {
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromArray:@[ @"totalResults" ]];
    return responseMapping;
}

- (RKEntityMapping *)venueMapping {
    RKEntityMapping * venueMapping = [RKEntityMapping mappingForEntityForName:@"Venue"
                                                         inManagedObjectStore:self.objectManager.managedObjectStore];
    venueMapping.identificationAttributes = @[@"id"];
    NSDictionary *mapping = @{
                              @"id" : @"id",
                              @"name" : @"name",
                              @"contact.phone" : @"phone",
                              @"location.address" : @"address",
                              @"price.tier" : @"priceTier",
                              @"rating" : @"rating",
                              @"menu.mobileUrl" : @"menuUrl",
                              @"hours.status" : @"openNow",
                              @"url" : @"websiteUrl",
                              };
    [venueMapping addAttributeMappingsFromDictionary:mapping];

//    // category mapping (read from end to start)
//    RKObjectMapping *stringMapping = [RKObjectMapping mappingForClass:[NSString class]];
//    [stringMapping add]
//    RKDynamicMapping *categoryDynamicMapping = [RKDynamicMapping new];
//    [categoryDynamicMapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"primary"
//                                                                    expectedValue:@YES
//                                                                    objectMapping:stringMapping]];
//    RKRelationshipMapping *categoryPropMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"categories"
//                                                                                             toKeyPath:@"category"
//                                                                                           withMapping:categoryDynamicMapping];
//    [venueMapping addPropertyMapping:categoryPropMapping];
    return venueMapping;
}

- (RKObjectMapping *)groupMapping {
    RKObjectMapping *groupMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [groupMapping addRelationshipMappingWithSourceKeyPath:@"items" mapping:self.groupItemMapping];
    return groupMapping;
}

- (RKObjectMapping *)groupItemMapping {
    RKObjectMapping *groupItemMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [groupItemMapping addRelationshipMappingWithSourceKeyPath:@"venue" mapping:self.venueMapping];
    return groupItemMapping;
}

- (void)requestVenuesWithLimit:(NSInteger)limit
                        offset:(NSInteger)offset
                    completion:(void(^)(NSArray *venues, NSInteger totalResults, NSError *error))completion
{
    NSDictionary *params = @{@"ll" : @"40.724517, -73.997535", // NY office coordinates
                             @"price" : @"2,3,4",
                             @"openNow" : @1,
                             @"section" : @"food",
                             @"venuePhotos" : @1,
                             @"limit" : @(limit),
                             @"offset" : @(offset),
                             @"client_id": @"CKFSMBEQFN3DAPXEAZ1423BNI0KF0TSH3LB4CWNY3VTU3ELS",
                             @"client_secret": @"MY3OZ0AUCRL1SGQMCQV2ACOVTPKZW1SIVYYUQBKG3TJURKDG", // would be nice if it were revokeable but it's a test app :)
                             @"v": @"20140827"};
    [self.objectManager getObjectsAtPath:kVenuesExplorePath
                              parameters:params
                                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                     if (completion) {
                                         NSInteger count = [mappingResult.dictionary[@"response"][@"totalResults"] integerValue];
                                         NSArray *groups = mappingResult.dictionary[@"response.groups"];
                                         // TODO: delete redundant mappings: I can filter the venues before mapping any entities
                                         NSArray *venues = [[[groups rx_mapWithBlock:^id(NSDictionary *group) {
                                             return [group valueForKeyPath:@"items.venue"];
                                         }] rx_foldInitialValue:[NSMutableArray array] block:^id(id memo, id next) {
                                             [memo addObjectsFromArray:next];
                                             return memo;
                                         }] copy];
                                         completion(venues, count, nil);
                                     }
                                 }
                                 failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                     if (completion) {
                                         completion(nil, 0, error);
                                     }
                                 }];
}

@end
