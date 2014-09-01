//
//  DataProvider.m
//  GetFueled
//
//  Created by Leonty Deriglazov on 01/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "DataProvider.h"
#import "FoursquareApi.h"


static NSInteger kPageSize = 10;

@interface DataProvider ()

@property (nonatomic, strong) NSMutableArray *mutableObjects;

@end

@implementation DataProvider

- (NSInteger)objectCount {
    return [self.mutableObjects count];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    id object = self.mutableObjects[indexPath.row];
    if (!object) {
        //[self requestRangeContaining:indexPath];
    }
    return object;
}

- (void)refresh {
    [[FoursquareApi sharedInstance] requestVenuesWithLimit:0 offset:kPageSize completion:^(NSArray *venues, NSInteger totalResults, NSError *error) {
        if (error == nil) {
            [self.requester dataPoviderDidRefresh:self];
        } else {
            [self.requester dataPovider:self didFailToFetchDataWithError:error];
        }
    }];
}

@end
