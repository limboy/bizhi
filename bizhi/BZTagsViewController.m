//
//  CategoriesViewController.m
//  ios-bizhi-copy
//
//  Created by Limboy on 4/21/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "BZTagsViewController.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import <SVPullToRefresh.h>
#import "Protocols.h"
#import <Objection.h>
#import "BZAPIManager.h"
#import "BZTagModel.h"

static NSString *cellIdentifier = @"cell";

@interface BZTagsViewController ()
@property (nonatomic) NSArray *tags;
@end

@implementation BZTagsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    @weakify(self);
    [RACObserve(self, tags) subscribeNext:^(NSArray *tags) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        [[[BZAPIManager sharedManager] fetchTags] subscribeNext:^(NSArray *tags) {
            self.tags = tags;
            [self.tableView.infiniteScrollingView stopAnimating];
            self.tableView.showsInfiniteScrolling = NO;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }];
    }];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeTop;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView triggerInfiniteScrolling];
    });
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    BZTagModel *tag = ((BZTagModel *)self.tags[indexPath.row]);
    NSString *tagName = tag.tagName;
    NSString *pinCountString = [NSString stringWithFormat:@"%ld", (long)tag.pinCount];
    NSString *displayString = [NSString stringWithFormat:@"%@ 共%@张", tagName, pinCountString];
    
    // Configure the cell...
    NSDictionary *stringAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:displayString attributes:stringAttributes];
    [attributedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor grayColor]} range:NSMakeRange(tagName.length + 1, pinCountString.length + 2)];
    cell.textLabel.attributedText = attributedString;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([cell respondsToSelector:@selector(separatorInset)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController <BZWaterfallViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(BZWaterfallViewControllerProtocol)];
    NSString *tagName = ((BZTagModel *)self.tags[indexPath.row]).tagName;
    [viewController configureWithTag:tagName];
    viewController.title = tagName;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
