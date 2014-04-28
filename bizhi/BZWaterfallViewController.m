//
//  BZWaterfallViewController.m
//  ios-bizhi-copy
//
//  Created by Limboy on 4/17/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "BZWaterfallViewController.h"
#import <CHTCollectionViewWaterfallLayout.h>
#import "BZWaterfallViewModel.h"
#import "BZWaterfallViewCell.h"
#import "BZWaterfallViewCellModel.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import <JSObjection.h>
#import "UIView+SuperView.h"
#import <SVProgressHUD.h>
#import <SVPullToRefresh.h>

static NSString *cellIdentifier = @"cell";

@interface BZWaterfallViewController () <CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic) BZWaterfallViewModel *viewModel;
@property (nonatomic) RACCommand *thumbnailImageButtonCommand;
@property (nonatomic) NSIndexPath *selectedIndexPath;
@end

@implementation BZWaterfallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.columnCount = 3;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.viewModel = [[BZWaterfallViewModel alloc] init];
    }
    return self;
}

#pragma mark - Public Methods

- (void)configureWithTag:(NSString *)tag
{
    self.viewModel.tag = tag;
}

- (void)configureWithLatest
{
    self.viewModel.tag = @"";
}

#pragma mark - Accessors

- (RACCommand *)thumbnailImageButtonCommand
{
    if (!_thumbnailImageButtonCommand) {
        @weakify(self);
        _thumbnailImageButtonCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
            BZWaterfallViewCell *cell = (BZWaterfallViewCell *)[button findSuperViewWithClass:[BZWaterfallViewCell class]];
            
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                UIViewController <BZDetailViewControllerProtocol>* viewController = [[JSObjection defaultInjector] getObject:@protocol(BZDetailViewControllerProtocol)];
                viewController.initPinIndex = cell.viewModel.indexPath.row;
                [viewController configureWithViewModel:self.viewModel];
                [self presentViewController:viewController animated:YES completion:^{
                    [subscriber sendCompleted];
                }];
                [[RACObserve(viewController, currentPinIndex) skip:1] subscribeNext:^(id x) {
                    @strongify(self);
                    self.selectedIndexPath = [NSIndexPath indexPathForRow:[x intValue] inSection:0];
                }];
                return nil;
            }];
        }];
    }
    return _thumbnailImageButtonCommand;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.pins.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BZWaterfallViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    BZWaterfallViewCellModel *viewModel = [[BZWaterfallViewCellModel alloc] init];
    viewModel.pin = self.viewModel.pins[indexPath.row];
    viewModel.indexPath = indexPath;
    [cell configureWithViewModel:viewModel];
    cell.thumbnailImageButton.rac_command = self.thumbnailImageButtonCommand;;
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(97, 145);
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[BZWaterfallViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    @weakify(self);
    [RACObserve(self, viewModel.pins) subscribeNext:^(NSArray *pins) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [self.collectionView addSubview:refreshControl];
    [[refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self);
        [[self.viewModel fetchPinsWithTag:self.viewModel.tag offset:0] subscribeNext:^(NSArray *pins) {
            self.viewModel.pins = pins;
        }];
        [refreshControl endRefreshing];
    }];
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        [[self.viewModel fetchMore] subscribeNext:^(NSArray *pins) {
            if (!pins.count) {
                [SVProgressHUD showErrorWithStatus:@"没有更多了"];
            } else {
                NSMutableArray *mutablePins = [NSMutableArray arrayWithArray:self.viewModel.pins];
                [mutablePins addObjectsFromArray:pins];
                self.viewModel.pins = [mutablePins copy];
            }
            [self.collectionView.infiniteScrollingView stopAnimating];
        }];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView triggerInfiniteScrolling];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.selectedIndexPath) {
        [self.collectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
