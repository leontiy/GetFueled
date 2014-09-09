//
//  VenuescollectionViewController.m
//  GetFueled
//
//  Created by Leonty Deriglazov on 05/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "VenuesCollectionViewController.h"
@import CoreData;
#import <RestKit/CoreData/NSManagedObjectContext+RKAdditions.h>
#import <libextobjc/EXTKeyPathCoding.h>
#import <libextobjc/EXTScope.h>
#import <RXCollections/RXCollection.h>
#import "VenueCollectionViewCell.h"
#import "ModelManager.h"
#import "Venue.h"
#import "RecommendedItem.h"
#import "ActivityIndicatorView.h"
#import "RequestStatusView.h"
#import "DataRequest.h"
#import "Insertion.h"
#import "Deletion.h"
#import "DTActionSheet.h"
#import "VenueViewController.h"


static NSString *const kVenueCellReuseIdentifier = @"VenueCell";


@interface VenuesCollectionViewController () <NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) ActivityIndicatorView *pageLoadingIndicator;
@property (nonatomic, strong) RequestStatusView *requestStatusView;
@property (nonatomic, readonly) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *dataController;
@property (nonatomic, strong) NSMutableArray *updateOperations;
@property (nonatomic, weak) UIView *currentBottomView;

@end

@implementation VenuesCollectionViewController

- (NSManagedObjectContext *)context {
    return [ModelManager sharedModelManager].mainContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"VenueCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:kVenueCellReuseIdentifier];
    [self requestNextPage];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showVenue"]) {
        VenueViewController *vc = segue.destinationViewController;
        vc.venue = [sender representedObject];
    }
}

- (void)requestNextPage {
    DataRequest *request = [[ModelManager sharedModelManager] loadNextPage];
    if (request) {
        [self showPageLoadingIndicator];
    }
    @weakify(self);
    [request succeeded:^(DataRequest *request, id result) {
        @strongify(self);
        [self hidePageLoadingIndicator];
        [self createDataControllerIfNeeded];
        if ([[[result[@"venueIds"] rx_mapWithBlock:^Venue *(NSManagedObjectID *each) {
                return (id)[self.context objectWithID:each];
            }] rx_filterWithBlock:^BOOL(Venue *each) {
                return ![each.blacklisted boolValue];
            }] count] == 0)
        { // all blocked in current page
            [self requestNextPage];
        }
    }];
    [request failed:^(DataRequest *request, NSError *error) {
        @strongify(self);
        [self hidePageLoadingIndicator];
        [self showStatusView];
        self.requestStatusView.textLabel.text = @"Communication error occurred.\nTap here to retry.";
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retryPageLoad:)];
        [self.requestStatusView addGestureRecognizer:tapRecognizer];
    }];
}

- (void)createDataControllerIfNeeded {
    if (self.dataController) {
        return;
    }
    
    NSFetchRequest *recommendedItems = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([RecommendedItem class])];
    recommendedItems.relationshipKeyPathsForPrefetching = @[ @keypath(RecommendedItem.new, venue),
                                                              @keypath(RecommendedItem.new, venue.categories) ];
    recommendedItems.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@keypath(RecommendedItem.new, index) ascending:YES] ];
    recommendedItems.predicate = [NSPredicate predicateWithFormat:@"venue.blacklisted == FALSE"];
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
}

- (void)retryPageLoad:(UIGestureRecognizer *)recognizer {
    [self requestNextPage];
}

- (void)showPageLoadingIndicator {
    [self hideStatusView]; // if any

    self.pageLoadingIndicator = (id)[self loadBottomViewFromNibNamed:@"ActivityIndicatorView"];
    [self.pageLoadingIndicator startAnimating];
}

- (void)hidePageLoadingIndicator {
    [self.pageLoadingIndicator removeFromSuperview];
    self.pageLoadingIndicator = nil;
    
    [self showStatusView];
}

- (void)showStatusView {
    self.requestStatusView = (id)[self loadBottomViewFromNibNamed:@"RequestStatusView"];
}

- (void)hideStatusView {
    [self.requestStatusView removeFromSuperview];
    self.requestStatusView = nil;
}

- (UIView *)loadBottomViewFromNibNamed:(NSString *)nibName {
    UIView *view = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil][0];
    const CGFloat requestStatusViewHeight = view.frame.size.height;
    [self.collectionView insertSubview:view atIndex:0];

    UIEdgeInsets inset = self.collectionView.contentInset;
    inset.bottom = requestStatusViewHeight;
    self.collectionView.contentInset = inset;
    self.currentBottomView = view;
    [self.view setNeedsLayout];
    return view;
}

- (void)viewDidLayoutSubviews {
    CGRect frame = self.currentBottomView.frame;
    frame.origin.y = self.collectionView.contentSize.height;
    self.currentBottomView.frame = frame;
}

#pragma mark Fetched Results Controller delegate

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
    }] integerValue] < 0;
    
    if (animated) {
        roll();
    } else {
        [UIView performWithoutAnimation:roll];
    }
}

#pragma mark Collection View delegate / data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataController.fetchedObjects count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VenueCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVenueCellReuseIdentifier
                                                                              forIndexPath:indexPath];
    cell.representedObject = [self.dataController.fetchedObjects[indexPath.row] venue];
    if (indexPath.row == [self.dataController.fetchedObjects count] - 1) {
        [self requestNextPage];
    }
    if (cell.longPressRecognizer) {
        [cell removeGestureRecognizer:cell.longPressRecognizer];
    }
    cell.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(venueOptions:)];
    [cell addGestureRecognizer:cell.longPressRecognizer];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showVenue" sender:[collectionView cellForItemAtIndexPath:indexPath]];
}

#pragma mark -

- (IBAction)venueOptions:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    DTActionSheet *sheet = [[DTActionSheet alloc] initWithTitle:nil];
    [sheet addDestructiveButtonWithTitle:@"Don't show this venue again" block:^{
        VenueCollectionViewCell *cell = (id)recognizer.view;
        cell.representedObject.blacklisted = @YES;
        [self.context saveToPersistentStore:nil];
        [self.dataController performFetch:nil];
        [self.collectionView deleteItemsAtIndexPaths:@[ [self.collectionView indexPathForCell:cell] ]];
    }];
    [sheet addCancelButtonWithTitle:@"Cancel"];
    [sheet showInView:self.view];
}

@end
