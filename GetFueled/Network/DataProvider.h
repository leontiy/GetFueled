//
//  DataProvider.h
//  GetFueled
//
//  Created by Leonty Deriglazov on 01/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

@class DataProvider;

@protocol DataRequester <NSObject>

- (void)dataPoviderDidRefresh:(DataProvider *)provider;
- (void)dataPovider:(DataProvider *)provider didUpdateObjectsAtIndices:(NSIndexSet *)indexSet;

- (void)dataPovider:(DataProvider *)provider didFailToFetchDataWithError:(NSError *)error;

@end

@interface DataProvider : NSObject

@property (nonatomic, weak) id<DataRequester> requester;
@property (nonatomic, readonly) NSInteger objectCount;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (void)refresh;

@end
