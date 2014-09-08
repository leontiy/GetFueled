//
//  VenuescollectionViewController.m
//  GetFueled
//
//  Created by Leonty Deriglazov on 05/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "VenuesCollectionViewController.h"
@import CoreData;
#import <libextobjc/EXTKeyPathCoding.h>
#import <libextobjc/EXTScope.h>
#import <RXCollections/RXCollection.h>
#import "VenueCollectionViewCell.h"
#import "ModelManager.h"
#import "Venue.h"
#import "RecommendedItem.h"
#import "ActivityIndicatorView.h"
#import "DataRequest.h"
#import "Insertion.h"
#import "Deletion.h"




@interface VenuesCollectionViewController () <NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) ActivityIndicatorView *pageLoadingIndicator;
@property (nonatomic, readonly) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *dataController;
@property (nonatomic, strong) NSMutableArray *updateOperations;
@end

@implementation VenuesCollectionViewController

- (NSManagedObjectContext *)context {
    return [ModelManager sharedModelManager].mainContext;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DataRequest *request = [[ModelManager sharedModelManager] refresh];
    @weakify(self);
    [request succeeded:^(DataRequest *request, id result) {
        @strongify(self);
        // update loading indicator <#here#>
    }];
    [request failed:^(DataRequest *request, NSError *error) {
        // TOOD handle failure <#here#>
    }];

    NSFetchRequest *recommendedItems = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([RecommendedItem class])];
    recommendedItems.relationshipKeyPathsForPrefetching = @[ @keypath(RecommendedItem.new, venue),
                                                             @keypath(RecommendedItem.new, venue.categories) ];
    recommendedItems.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@keypath(RecommendedItem.new, index) ascending:YES] ];
    self.dataController = [[NSFetchedResultsController alloc] initWithFetchRequest:recommendedItems
                                                              managedObjectContext:self.context
                                                                sectionNameKeyPath:nil
                                                                         cacheName:nil];
    self.dataController.delegate = self;
    NSError *error;
    BOOL fetched = [self.dataController performFetch:&error];
    if (!fetched) {
        NSLog(@"Could not fetch data %@", [error localizedDescription]);
    }
    
    self.pageLoadingIndicator = [[NSBundle mainBundle] loadNibNamed:@"ActivityIndicatorView" owner:nil options:nil][0];
    const CGFloat loadingIndicatorHeight = self.pageLoadingIndicator.frame.size.height;
    [self.collectionView insertSubview:self.pageLoadingIndicator atIndex:0];

    UIEdgeInsets inset = self.collectionView.contentInset;
    inset.bottom = loadingIndicatorHeight;
    self.collectionView.contentInset = inset;
}

- (void)viewDidLayoutSubviews {
    [self.pageLoadingIndicator startAnimating];
    CGRect frame = self.pageLoadingIndicator.frame;
    frame.origin.y = self.collectionView.contentSize.height;
    self.pageLoadingIndicator.frame = frame;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    self.updateOperations = [NSMutableArray new];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    Venue *venue = [anObject venue];
    switch(type) {
        case NSFetchedResultsChangeInsert: {
            Insertion *insertion = [Insertion insertionWithObject:venue indexPath:newIndexPath];
            [self.updateOperations addObject:insertion];
        }; break;
            
        case NSFetchedResultsChangeDelete:{
            Deletion *deletion = [Deletion deletionWithObject:venue indexPath:indexPath];
            [self.updateOperations addObject:deletion];
        }; break;
            
        case NSFetchedResultsChangeUpdate: {
            VenueCollectionViewCell *cell = (id)[self.collectionView cellForItemAtIndexPath:indexPath];
            cell.representedObject = venue;
        }; break;
            
        case NSFetchedResultsChangeMove: {
            Deletion *deletion = [Deletion deletionWithObject:venue indexPath:indexPath];
            [self.updateOperations addObject:deletion];
            Insertion *insertion = [Insertion insertionWithObject:venue indexPath:newIndexPath];
            [self.updateOperations addObject:insertion];
        }; break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    dispatch_block_t roll = ^{
        [self.collectionView performBatchUpdates:^{
            [self.updateOperations enumerateObjectsUsingBlock:^(ArrayOperation *operation, NSUInteger idx, BOOL *stop) {
                [operation applyToCollectionView:self.collectionView];
            }];
        } completion:^(BOOL finished) {
            self.updateOperations = nil;
        }];
    };
    BOOL animated = [[self.updateOperations rx_foldInitialValue:@0 block:^NSNumber *(NSNumber *memo, ArrayOperation *op) {
        BOOL positive = [op isKindOfClass:[Insertion class]];
        return @([memo integerValue] + (positive?  +1 : -1));
    }] integerValue] != 0;
    
    if (animated) {
        roll();
    } else {
        [UIView performWithoutAnimation:roll];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataController.fetchedObjects count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VenueCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VenueCell" forIndexPath:indexPath];
    cell.representedObject = [self.dataController.fetchedObjects[indexPath.row] venue];
    return cell;
}

@end