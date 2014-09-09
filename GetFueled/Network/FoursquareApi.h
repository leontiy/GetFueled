//
//  FoursquareApi.h
//  GetFueled
//
//  Created by Leonty Deriglazov on 27/08/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import <Foundation/Foundation.h>


@class RKManagedObjectStore;
@class DataRequest;


/**
 Handles networking and data parsing.
*/
@interface FoursquareApi : NSObject

- (instancetype)initWithDataStore:(RKManagedObjectStore*)store;
- (DataRequest *)requestRecommendedVenuesWithOffset:(NSInteger)offset limit:(NSInteger)limit;

@end
