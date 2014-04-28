//
//  BZWaterfallViewCellModel.h
//  ios-bizhi-copy
//
//  Created by Limboy on 4/18/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "RVMViewModel.h"

@class BZPinModel;

@interface BZWaterfallViewCellModel : RVMViewModel
@property (nonatomic) BZPinModel *pin;
@property (nonatomic) NSIndexPath *indexPath;
@end
