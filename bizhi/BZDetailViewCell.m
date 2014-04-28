//
//  BZDetailViewCell.m
//  ios-bizhi-copy
//
//  Created by Limboy on 4/18/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "BZDetailViewCell.h"
#import <UIImageView+WebCache.h>
#import "BZAPIManager.h"
#import "BZPinModel.h"
#import "UIView+Layout.h"
#import "UtilsMacro.h"
#import <RACEXTScope.h>
#import "UIColor+LightRandom.h"

@interface BZDetailViewCell ()
@property (nonatomic) UIImageView *detailImageView;
@property (nonatomic) UIProgressView *progressView;
@end

@implementation BZDetailViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.detailImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.detailImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.detailImageScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.detailImageScrollView.alwaysBounceVertical = YES;
        self.detailImageScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
        [self.detailImageScrollView addSubview:self.detailImageView];
        [self.contentView addSubview:self.detailImageScrollView];
        
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        if ([self.progressView respondsToSelector:@selector(tintColor)]) {
            self.progressView.tintColor = [UIColor grayColor];
        }
        self.progressView.trackTintColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.contentView addSubview:self.progressView];
        self.progressView.frame = CGRectMake(100, ScreenHeight / 2, 120, 2);
    }
    return self;
}

- (void)configureCellWithPin:(BZPinModel *)pin
{
    @weakify(self);
    self.progressView.progress = 0;
    self.contentView.backgroundColor = [UIColor lightRandom];
    NSURL *imageURL = [NSURL URLWithString:[pin imageURLWithThumbnailWidth:658]];
    self.progressView.hidden = NO;
    [self.detailImageView setImageWithURL:imageURL placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        @strongify(self);
        [self.progressView setProgress:receivedSize / (float)expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        @strongify(self);
        self.progressView.hidden = YES;
        NSInteger finalImageHeight = ScreenWidth / image.size.width * image.size.height;
        if (finalImageHeight > ScreenHeight) {
            self.detailImageView.size = CGSizeMake(ScreenWidth, finalImageHeight);
            self.detailImageScrollView.contentSize = self.detailImageView.size;
        }
        if (cacheType != SDImageCacheTypeMemory) {
            self.detailImageView.alpha = 0;
            [UIView animateWithDuration:0.3 animations:^{
                self.detailImageView.alpha = 1;
            }];
        }
    }];
}

@end
