//
//  FavoritesCollectionViewController.h
//  GetFueled
//
//  Created by Leonty Deriglazov on 09/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSManagedObjectContext;

@interface FavoritesCollectionViewController : UICollectionViewController

@property (nonatomic, strong) NSManagedObjectContext *context;

@end
