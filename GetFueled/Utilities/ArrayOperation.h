//
// Created by Leonty Deriglazov on 08/09/14.
// Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ArrayOperation : NSObject

@property (nonatomic, strong, readonly) NSIndexPath *indexPath;
@property (nonatomic, strong, readonly) id object;

+ (instancetype)operationWithObject:(id)object indexPath:(NSIndexPath *)indexPath;

/// Abstract method
- (void)applyToCollectionView:(UICollectionView *)collectionView;

@end