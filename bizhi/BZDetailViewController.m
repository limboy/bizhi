//
//  BZDetailViewController.m
//  ios-bizhi-copy
//
//  Created by Limboy on 4/17/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "BZDetailViewController.h"
#import <ReactiveCocoa.h>
#import "UtilsMacro.h"
#import "BZDetailViewCell.h"
#import <Objection.h>
#import <RACEXTScope.h>
#import <SVProgressHUD.h>
#import <SDWebImageManager.h>
#import "BZAPIManager.h"
#import "BZPinModel.h"
#import "UIView+Layout.h"

static NSString *cellIdentifier = @"cell";

@interface BZDetailViewController () <UIGestureRecognizerDelegate>
@property (nonatomic) id<BZWaterfallViewModelProtocol> viewModel;
@property (nonatomic) UIView *actionButtonsContainerView;
@end

@implementation BZDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight);
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        // Custom initialization
        RAC(self, currentPinIndex) = RACObserve(self, initPinIndex);
    }
    return self;
}

- (void)configureWithViewModel:(id<BZWaterfallViewModelProtocol>)viewModel
{
    self.viewModel = viewModel;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.pins.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BZDetailViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell configureCellWithPin:self.viewModel.pins[indexPath.row]];
    [self addSwipeGestureToCell:cell];
    [self addTouchGestureToCell:cell];
    return cell;
}

#pragma mark - Utils

- (void)addGesture:(UIGestureRecognizer *)gesture ToCell:(BZDetailViewCell *)cell
{
    __block UIGestureRecognizer *theGesture = gesture;
    [cell.detailImageScrollView.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[gesture class]]) {
            [cell.detailImageScrollView removeGestureRecognizer:obj];
        }
    }];
    [cell.detailImageScrollView addGestureRecognizer: theGesture];
    [cell.detailImageScrollView.panGestureRecognizer requireGestureRecognizerToFail:theGesture];
}

- (void)addTouchGestureToCell:(BZDetailViewCell *)cell
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [self addGesture:tapGesture ToCell:cell];
    
    @weakify(self);
    [[tapGesture.rac_gestureSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        @strongify(self);
        if (self.actionButtonsContainerView.hidden) {
            self.actionButtonsContainerView.alpha = 0;
            self.actionButtonsContainerView.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                self.actionButtonsContainerView.alpha = 1;
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                self.actionButtonsContainerView.alpha = 0;
            } completion:^(BOOL finished) {
                self.actionButtonsContainerView.hidden = YES;
            }];
        }
    }];
}

- (void)addSwipeGestureToCell:(BZDetailViewCell *)cell
{
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] init];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    swipeGesture.delegate = self;
    [self addGesture:swipeGesture ToCell:cell];
    
    @weakify(self);
    [[swipeGesture.rac_gestureSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UISwipeGestureRecognizer *gesture) {
        @strongify(self);
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - UIPanGestureDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIScrollView *scrollView = (UIScrollView *)gestureRecognizer.view;
    return scrollView.top <= 0 ? YES : NO;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collectionView registerClass:[BZDetailViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.collectionView.pagingEnabled = YES;
    [self.view addSubview:self.actionButtonsContainerView];
    //self.actionButtonsContainerView.hidden = YES;
    
    @weakify(self);
    [[self rac_signalForSelector:@selector(scrollViewDidScroll:) fromProtocol:@protocol(UIScrollViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        UIScrollView *scrollView = tuple.first;
        if (scrollView.isDragging && scrollView.contentSize.width <= (scrollView.contentOffset.x + scrollView.width)) {
            [[self.viewModel fetchMore] subscribeNext:^(NSArray *pins) {
                if (!pins.count) {
                    [SVProgressHUD showErrorWithStatus:@"没有更多了"];
                } else {
                    NSMutableArray *mutablePins = [NSMutableArray arrayWithArray:self.viewModel.pins];
                    [mutablePins addObjectsFromArray:pins];
                    self.viewModel.pins = [mutablePins copy];
                }
            }];
        }
    }];
    
    [[self rac_signalForSelector:@selector(scrollViewDidEndDecelerating:) fromProtocol:@protocol(UIScrollViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        UIScrollView *scrollView = tuple.first;
        self.currentPinIndex = scrollView.contentOffset.x / ScreenWidth;
    }];
    
    self.collectionView.delegate = nil;
    self.collectionView.delegate = self;
    
    [RACObserve(self, viewModel.pins) subscribeNext:^(NSArray *pins) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView setContentOffset:CGPointMake(ScreenWidth * self.initPinIndex, 0)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utils

- (void)shareWithImage:(UIImage *)image
{
    NSArray *activityItems = [NSArray arrayWithObjects:image, nil];
    
    //-- initialising the activity view controller
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:activityItems
                                                        applicationActivities:nil];
    
    
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeAirDrop];
    
    //-- define the activity view completion handler
    activityViewController.completionHandler = ^(NSString *activityType, BOOL completed){
        if (completed) {
            if (activityType != UIActivityTypeSaveToCameraRoll) {
                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"下载成功"];
            }
        }
    };
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - Accessors

- (UIView *)actionButtonsContainerView
{
    if (!_actionButtonsContainerView) {
        UIImage *shareButtonImage = [UIImage imageNamed:@"button_share"];
        CGSize containerSize = CGSizeMake(shareButtonImage.size.width + 20, shareButtonImage.size.height + 20);
        _actionButtonsContainerView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth - containerSize.width) / 2, ScreenHeight - containerSize.height - 20, containerSize.width, containerSize.height)];
        _actionButtonsContainerView.layer.cornerRadius = 6;
        _actionButtonsContainerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:shareButtonImage forState:UIControlStateNormal];
        shareButton.origin = CGPointMake(10 , 10);
        shareButton.size = shareButtonImage.size;
        [_actionButtonsContainerView addSubview:shareButton];
        
        @weakify(self);
        shareButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            BZPinModel *currentPin = (BZPinModel *)self.viewModel.pins[self.currentPinIndex];
            NSString *URLString = [currentPin imageURLWithThumbnailWidth:658];
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                if (![[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:URLString]]) {
                    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeBlack];
                }
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:URLString]
                                                                options:SDWebImageRetryFailed
                                                               progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [SVProgressHUD dismiss];
                    [subscriber sendCompleted];
                    if (!error) {
                        @strongify(self);
                        [self shareWithImage:image];
                    }
                }];
                return nil;
            }];
        }];
    }
    return _actionButtonsContainerView;
}

@end
