//
//  DataProvider.h
//  GetFueled
//
//  Created by Leonty Deriglazov on 01/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

@class ModelManager;
@class RKManagedObjectStore;


@protocol DataRequester <NSObject>

- (void)dataPoviderDidRefresh:(ModelManager *)provider;
- (void)dataPovider:(ModelManager *)provider didUpdateObjectsAtIndices:(NSIndexSet *)indexSet;

- (void)dataPovider:(ModelManager *)provider didFailToFetchDataWithError:(NSError *)error;

@end


@interface ModelManager : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *mainContext;

+ (instancetype)sharedModelManager;

- (void)requestItemAtIndex:(NSInteger)idx;
- (void)refresh;

@end
