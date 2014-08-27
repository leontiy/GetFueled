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

static NSString *const kVenuesSearchPath = @"venues/search";

@interface FoursquareApi ()

@property (nonatomic, strong) RKObjectManager *objectManager;
@property (nonatomic, strong) RKEntityMapping *venueMapping;

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *baseUrl = [NSURL URLWithString:@"https://api.foursquare.com/v2/"];
        self.objectManager = [RKObjectManager managerWithBaseURL:baseUrl];
        [self configureCoreDataStack];
        RKResponseDescriptor *rd = [RKResponseDescriptor responseDescriptorWithMapping:self.venueMapping
                                                                                method:RKRequestMethodGET
                                                                           pathPattern:kVenuesSearchPath
                                                                               keyPath:@"response.venues"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [self.objectManager addResponseDescriptor:rd];
    }
    return self;
}

- (void)configureCoreDataStack {
    NSError *error = nil;
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Model" ofType:@"momd"]];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    [managedObjectStore createPersistentStoreCoordinator];
    NSDictionary *options = @{NSInferMappingModelAutomaticallyOption : @YES,
                              NSMigratePersistentStoresAutomaticallyOption: @YES};
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Model.sqlite"];
    if (![managedObjectStore addSQLitePersistentStoreAtPath:storePath
                                     fromSeedDatabaseAtPath:nil
                                          withConfiguration:nil
                                                    options:options
                                                      error:&error]) {
        NSLog(@"Failed to load data model. DB will be deleted");
        NSLog(@"Error: %@", error);
        [[NSFileManager defaultManager] removeItemAtPath:storePath error:&error];
        if (![managedObjectStore addSQLitePersistentStoreAtPath:storePath
                                         fromSeedDatabaseAtPath:nil
                                              withConfiguration:nil
                                                        options:options
                                                          error:&error]) {
            NSLog(@"Failed to re-create database. Bailing out.");
            abort();
        }
    }
    [managedObjectStore createManagedObjectContexts];
    self.objectManager.managedObjectStore = managedObjectStore;
}


- (RKEntityMapping *)venueMapping {
    if (_venueMapping == nil) {
        _venueMapping = [RKEntityMapping mappingForEntityForName:@"Venue"
                                            inManagedObjectStore:self.objectManager.managedObjectStore];
        _venueMapping.identificationAttributes = @[@"id"];
        [_venueMapping addAttributeMappingsFromArray:@[@"id", @"name"]];
    }
    return _venueMapping;
}

- (void)requestVenuesWithCompletion:(void(^)(NSArray *venues, NSError *error))completion {
    NSDictionary *params = @{@"ll": @"40.7,74",
                             @"client_id": @"CKFSMBEQFN3DAPXEAZ1423BNI0KF0TSH3LB4CWNY3VTU3ELS",
                             @"client_secret": @"MY3OZ0AUCRL1SGQMCQV2ACOVTPKZW1SIVYYUQBKG3TJURKDG",
                             @"v": @"20140827"};
    [self.objectManager getObjectsAtPath:kVenuesSearchPath
                              parameters:params
                                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                     if (completion) {
                                         completion(mappingResult.array, nil);
                                     }
                                 }
                                 failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                     if (completion) {
                                         completion(nil, error);
                                     }
                                 }];
}

@end
