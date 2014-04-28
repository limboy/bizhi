//
//  BZSettingsViewController.m
//  ios-bizhi-copy
//
//  Created by Limboy on 4/21/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "BZSettingsViewController.h"
#import <SDWebImageManager.h>
#import "UtilsMacro.h"
#import "UIView+Layout.h"
#import <ReactiveCocoa.h>
#import <SVProgressHUD.h>

static NSString *cellIdentifier = @"cell";

@interface BZSettingsViewController ()

@end

@implementation BZSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12];
        footerLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        footerLabel.text = @"close the app, enjoy your life";
        self.tableView.tableFooterView = footerLabel;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"清除缓存";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.imageView.image = [UIImage imageNamed:@"trash"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [SVProgressHUD showSuccessWithStatus:@"清除成功"];
        }];
    }
}

@end
