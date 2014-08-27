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

- (void)requestVenuesWithCompletion:(void(^)(NSArray *venues, NSError *error))completion;

@end
