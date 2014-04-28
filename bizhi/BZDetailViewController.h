//
//  BZDetailViewController.h
//  ios-bizhi-copy
//
//  Created by Limboy on 4/17/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"

@interface BZDetailViewController : UICollectionViewController <BZDetailViewControllerProtocol>
@property (nonatomic) NSInteger currentPinIndex;
@property (nonatomic) NSInteger initPinIndex;
@end
