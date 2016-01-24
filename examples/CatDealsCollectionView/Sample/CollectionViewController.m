
//
//  CollectionViewController.m
//  Sample
//
//  Created by Samuel Stow on 1/24/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "CollectionViewController.h"
#import "ItemViewCell.h"
#import "LoadingView.h"

static const NSTimeInterval kWebResponseDelay = 1.0;
static const BOOL kSimulateWebResponse = YES;
static const NSInteger kBatchSize = 20;

static const CGFloat kHorizontalSectionPadding = 10.0f;
static const CGFloat kVerticalSectionPadding = 20.0f;


@interface CollectionViewController ()<UICollectionViewDelegateFlowLayout>
{
  NSMutableArray *_data;
  BOOL loadingMoreCats;
}

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Register cell classes
    [self.collectionView registerClass:[ItemViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
  
  [self.collectionView registerClass:[LoadingView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[LoadingView reuseIdentifier]];
  
    // Do any additional setup after loading the view.
}


- (instancetype)init
{
  self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
  
  if (self) {
    
    self.title = @"Cat Deals with UIKit";
    _data = [[NSMutableArray alloc] init];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(kVerticalSectionPadding, kHorizontalSectionPadding, kVerticalSectionPadding, kHorizontalSectionPadding);
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTapped)];
  }
  
  return self;
}



- (void)fetchMoreCatsWithCompletion:(void (^)(BOOL))completion {
  if (kSimulateWebResponse) {
    __weak typeof(self) weakSelf = self;
    void(^mockWebService)() = ^{
      NSLog(@"ViewController \"got data from a web service\"");
      CollectionViewController *strongSelf = weakSelf;
      if (strongSelf != nil)
      {
        NSLog(@"ViewController is not nil");
        [strongSelf appendMoreItems:kBatchSize completion:completion];
        NSLog(@"ViewController finished updating collectionView");
      }
      else {
        NSLog(@"ViewController is nil - won't update collectionView");
      }
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kWebResponseDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), mockWebService);
  } else {
    [self appendMoreItems:kBatchSize completion:completion];
  }
}

- (void)appendMoreItems:(NSInteger)numberOfNewItems completion:(void (^)(BOOL))completion {
  NSArray *newData = [self getMoreData:numberOfNewItems];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.collectionView performBatchUpdates:^{
      [_data addObjectsFromArray:newData];
      NSArray *addedIndexPaths = [self indexPathsForObjects:newData];
      [self.collectionView insertItemsAtIndexPaths:addedIndexPaths];
    } completion:completion];
  });
}

- (NSArray *)getMoreData:(NSInteger)count {
  NSMutableArray *data = [NSMutableArray array];
  for (int i = 0; i < count; i++) {
    [data addObject:[ItemViewModel randomItem]];
  }
  return data;
}

- (NSArray *)indexPathsForObjects:(NSArray *)data {
  NSMutableArray *indexPaths = [NSMutableArray array];
  NSInteger section = 0;
  for (ItemViewModel *viewModel in data) {
    NSInteger item = [_data indexOfObject:viewModel];
    NSAssert(item < [_data count] && item != NSNotFound, @"Item should be in _data");
    [indexPaths addObject:[NSIndexPath indexPathForItem:item inSection:section]];
  }
  return indexPaths;
}


- (BOOL)prefersStatusBarHidden
{
  return YES;
}

- (void)reloadTapped
{
  [self.collectionView reloadData];
}


#pragma mark <UICollectionViewDataSource>


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  
  // Configure the cell
  ItemViewModel *viewModel = _data[indexPath.item];
  cell.itemView.viewModel = viewModel;
  
  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0 && [kind isEqualToString:UICollectionElementKindSectionFooter]) {
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[LoadingView reuseIdentifier] forIndexPath:indexPath];
  }
  return nil;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return [_data count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
  if (section == 0) {
    CGFloat width = CGRectGetWidth(self.view.frame);
    return CGSizeMake(width, [LoadingView desiredHeightForWidth:width]);
  }
  return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat collectionViewWidth = CGRectGetWidth(self.view.frame) - 2 * kHorizontalSectionPadding;
  CGFloat oneItemWidth = [ItemView preferredViewSize].width;
  NSInteger numColumns = floor(collectionViewWidth / oneItemWidth);
  // Number of columns should be at least 1
  numColumns = MAX(1, numColumns);
  
  CGFloat totalSpaceBetweenColumns = (numColumns - 1) * kHorizontalSectionPadding;
  CGFloat itemWidth = ((collectionViewWidth - totalSpaceBetweenColumns) / numColumns);
  return [ItemView sizeForWidth:itemWidth];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
  if ([view isKindOfClass:[LoadingView class]] && !loadingMoreCats) {
    loadingMoreCats = YES;
    [self fetchMoreCatsWithCompletion:^(BOOL complete) {
      loadingMoreCats = NO;
    }];
  }
}



@end
