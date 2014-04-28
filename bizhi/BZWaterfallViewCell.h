//
//  BZWaterfallViewCell.h
//  ios-bizhi-copy
//
//  Created by Limboy on 4/17/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BZWaterfallViewCellModel;

@interface BZWaterfallViewCell : UICollectionViewCell
- (void)configureWithViewModel:(BZWaterfallViewCellModel *)viewModel;
@property (nonatomic) UIButton *thumbnailImageButton;
@property (nonatomic) BZWaterfallViewCellModel *viewModel;
@end
