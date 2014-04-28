//
//  BZWaterfallViewCell.m
//  ios-bizhi-copy
//
//  Created by Limboy on 4/17/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "BZWaterfallViewCell.h"
#import "UIColor+LightRandom.h"
#import <UIImageView+WebCache.h>
#import "BZAPIManager.h"
#import "BZWaterfallViewCellModel.h"
#import <RACEXTScope.h>
#import "BZPinModel.h"

@interface BZWaterfallViewCell ()
@property (nonatomic) UIImageView *thumbnailImageView;
@end

@implementation BZWaterfallViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.thumbnailImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.thumbnailImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.thumbnailImageView];
        self.thumbnailImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.thumbnailImageButton.frame = self.thumbnailImageView.frame;
        [self.contentView addSubview:self.thumbnailImageButton];
    }
    return self;
}

- (void)configureWithViewModel:(BZWaterfallViewCellModel *)viewModel
{
    self.viewModel = viewModel;
    self.backgroundColor = [UIColor lightRandom];
    NSURL *imageURL = [NSURL URLWithString:[viewModel.pin imageURLWithThumbnailWidth:236]];
    @weakify(self);
    [self.thumbnailImageView setImageWithURL:imageURL placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        @strongify(self);
        if (cacheType != SDImageCacheTypeMemory) {
            self.thumbnailImageView.alpha = 0;
            [UIView animateWithDuration:0.25 animations:^{
                self.thumbnailImageView.alpha = 1;
            }];
        }
    }];
}

@end
