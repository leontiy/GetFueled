//
// Created by Leonty Deriglazov on 08/09/14.
// Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "Deletion.h"


@implementation Deletion

+ (instancetype)deletionWithObject:(id)object indexPath:(NSIndexPath *)indexPath {
    return [super operationWithObject:object indexPath:indexPath];
}

- (void)applyToCollectionView:(UICollectionView *)collectionView {
    if (self.indexPath.row < [collectionView numberOfItemsInSection:0]) {
        [collectionView deleteItemsAtIndexPaths:@[ self.indexPath ]];
    }
}

@end