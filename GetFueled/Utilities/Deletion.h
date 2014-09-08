//
// Created by Leonty Deriglazov on 08/09/14.
// Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArrayOperation.h"


@interface Deletion : ArrayOperation

+ (instancetype)deletionWithObject:(id)object indexPath:(NSIndexPath *)indexPath;

@end