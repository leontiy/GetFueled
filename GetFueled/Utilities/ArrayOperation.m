//
// Created by Leonty Deriglazov on 08/09/14.
// Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "ArrayOperation.h"


@implementation ArrayOperation

- (instancetype)initWithObject:(id)object indexPath:(NSIndexPath *)indexPath{
    self = [super init];
    if (self) {
        _object = object;
        _indexPath = indexPath;
    }

    return self;
}

+ (instancetype)operationWithObject:(id)object indexPath:(NSIndexPath *)indexPath {
    return [[self alloc] initWithObject:object indexPath:indexPath];
}

- (void)applyToCollectionView:(UICollectionView *)collectionView {
    abort();
}


@end