//
//  FoursquareApi.h
//  GetFueled
//
//  Created by Leonty Deriglazov on 27/08/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoursquareApi : NSObject

+ (instancetype)sharedInstance;

- (void)requestVenuesWithLimit:(NSInteger)limit
                        offset:(NSInteger)offset
                    completion:(void(^)(NSArray *venues, NSInteger totalResults, NSError *error))completion;

@end
