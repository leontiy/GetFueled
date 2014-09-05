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

- (instancetype)initWithDataStore:(RKManagedObjectStore*)store {
    self = [super init];
    if (self) {
        NSURL *baseUrl = [NSURL URLWithString:@"https://api.foursquare.com/v2/"];
        self.objectManager = [RKObjectManager managerWithBaseURL:baseUrl];
        self.objectManager.managedObjectStore = store;
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

- (RKObjectMapping *)responseMapping {
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [responseMapping addAttributeMappingsFromArray:@[ @"totalResults" ]];
    return responseMapping;
}

- (RKEntityMapping *)venueMapping {
    RKEntityMapping * venueMapping = [RKEntityMapping mappingForEntityForName:@"Venue"
                                                         inManagedObjectStore:self.objectManager.managedObjectStore];
    venueMapping.identificationAttributes = @[ @"id" ];
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
                              @"featuredPhotos.items.prefix" : @"photoUrlPrefixes",
                              @"featuredPhotos.items.suffix" : @"photoUrlSuffixes",
                              };
    [venueMapping addAttributeMappingsFromDictionary:mapping];
    [venueMapping addRelationshipMappingWithSourceKeyPath:@"categories" mapping:[self categoryMapping]];
    return venueMapping;
}

- (RKEntityMapping *)categoryMapping {
    RKEntityMapping *categoryMapping = [RKEntityMapping mappingForEntityForName:@"VenueCategory"
                                                           inManagedObjectStore:self.objectManager.managedObjectStore];
    categoryMapping.identificationAttributes = @[ @"id" ];
    NSDictionary *mapping = @{
                              @"id" : @"id",
                              @"name" : @"name",
                              };
    [categoryMapping addAttributeMappingsFromDictionary:mapping];
    return categoryMapping;
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

- (void)requestVenuesWithOffset:(NSInteger)offset
                          limit:(NSInteger)limit
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
                                         [self handleResponseWithGroups:groups
                                                                  count:count
                                                             completion:completion];
                                     }
                                 }
                                 failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                     if (completion) {
                                         completion(nil, 0, error);
                                     }
                                 }];
}

- (void)handleResponseWithGroups:(NSArray *)groups
                           count:(NSInteger)count
                      completion:(void(^)(NSArray *venues, NSInteger totalResults, NSError *error))completion
{
    NSArray *venues = [[[groups rx_mapWithBlock:^id(NSDictionary *group) {
        return [group valueForKeyPath:@"items.venue"];
    }] rx_foldInitialValue:[NSMutableArray array] block:^id(id memo, id next) {
        [memo addObjectsFromArray:next];
        return memo;
    }] copy];
    if (completion) {
        completion(venues, count, nil);
    }
}

@end
