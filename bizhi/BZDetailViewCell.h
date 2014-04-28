//
//  BZDetailViewCell.h
//  ios-bizhi-copy
//
//  Created by Limboy on 4/18/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BZPinModel;

@interface BZDetailViewCell : UICollectionViewCell
- (void)configureCellWithPin:(BZPinModel *)pin;
@property (nonatomic) UIScrollView *detailImageScrollView;
@end
