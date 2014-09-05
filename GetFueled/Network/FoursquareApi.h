//
//  FoursquareApi.h
//  GetFueled
//
//  Created by Leonty Deriglazov on 27/08/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import <Foundation/Foundation.h>


@class RKManagedObjectStore;


@interface FoursquareApi : NSObject

- (instancetype)initWithDataStore:(RKManagedObjectStore*)store;
- (void)requestVenuesWithOffset:(NSInteger)offset
                        limit:(NSInteger)limit
                    completion:(void(^)(NSArray *venues, NSInteger totalResults, NSError *error))completion;

@end
