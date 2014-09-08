//
// Created by Leonty Deriglazov on 08/09/14.
// Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "Insertion.h"


@implementation Insertion

+ (instancetype)insertionWithObject:(id)object indexPath:(NSIndexPath *)indexPath {
    return [super operationWithObject:object indexPath:indexPath];
}

- (void)applyToCollectionView:(UICollectionView *)collectionView {
    [collectionView insertItemsAtIndexPaths:@[ self.indexPath ]];
}

@end