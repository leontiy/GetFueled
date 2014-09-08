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
#import "DataRequest.h"
#import "DataRequest+Internal.h"

typedef id (*ResponseProcessorMethodIMP)(id, SEL, id, NSError **);

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



- (DataRequest *)requestRecommendedVenuesWithOffset:(NSInteger)offset limit:(NSInteger)limit {
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
    DataRequest *request = [self getObjectsAtPath:kVenuesExplorePath parameters:params responseProcessor:@selector(processVenuesResponse:error:)];
    return request;
}

- (id)processVenuesResponse:(RKMappingResult *)mappingResult error:(NSError **)error {
    NSInteger count = [mappingResult.dictionary[@"response"][@"totalResults"] integerValue];
    NSArray *groups = mappingResult.dictionary[@"response.groups"];
    // TODO: delete redundant mappings: I can filter the venues before mapping any entities
    NSArray *venues = [[[[groups rx_mapWithBlock:^id(NSDictionary *group) {
        return [group valueForKeyPath:@"items.venue"];
    }] rx_foldInitialValue:[NSMutableArray array] block:^id(id memo, id next) {
        [memo addObjectsFromArray:next];
        return memo;
    }] rx_mapWithBlock:^id(NSManagedObject *object) {
        return [object objectID];
    }] copy];
    return @{ @"totalResults" : @(count), @"venueIds" : venues };
}

- (DataRequest *)getObjectsAtPath:(NSString *)path parameters:(NSDictionary *)parameters responseProcessor:(SEL)processor {
    DataRequest *modelRequest = [DataRequest new];
    
    parameters = parameters ?: @{};
    
    NSParameterAssert(!!processor);
    NSURLRequest *urlRequest = [self.objectManager requestWithObject:nil method:RKRequestMethodGET path:path parameters:parameters];
    RKObjectRequestOperation *operation = [self.objectManager managedObjectRequestOperationWithRequest:urlRequest
                                                                                  managedObjectContext:nil
                                                                                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
    {
        ResponseProcessorMethodIMP method = (ResponseProcessorMethodIMP)[self methodForSelector:processor];
        NSError *error;
        modelRequest.result = method(self, processor, mappingResult, &error);
        if (modelRequest.result != nil) {
            [modelRequest didSucceed:modelRequest.result];
        } else {
            [modelRequest didFail:error];
        }
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error) {
       [modelRequest didFail:error];
    }];
    
//    [self.objectManager appropriateObjectRequestOperationWithObject:nil method:RKRequestMethodGET path:path parameters:parameters];
    
    // give the caller a chance to configure the request
    dispatch_async(dispatch_get_main_queue(), ^{
        [modelRequest didStart];
        [self.objectManager enqueueObjectRequestOperation:operation];
    });
    
    return modelRequest;
}

@end
