//
//  DataProvider.h
//  GetFueled
//
//  Created by Leonty Deriglazov on 01/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

@class DataRequest;

/**
 *  Owns Core data stack, manages local data representation with regard to Foursquare API.
 *  View Controllers perform simple local model operations themselves (review, favorites).
 */
@interface ModelManager : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *mainContext;
+ (instancetype)sharedModelManager;
- (DataRequest *)refresh;
- (DataRequest *)loadNextPage;

@end
