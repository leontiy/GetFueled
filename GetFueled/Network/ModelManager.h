//
//  DataProvider.h
//  GetFueled
//
//  Created by Leonty Deriglazov on 01/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

@class ModelManager;

@interface ModelManager : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *mainContext;

+ (instancetype)sharedModelManager;

- (BOOL)moreVenuesAvailable;
- (void)requestMoreVenuesWithCompletionBlock:(dispatch_block_t)completion;
- (void)refresh;

@end
