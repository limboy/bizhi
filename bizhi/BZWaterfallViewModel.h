//
//  BZWaterfallViewModel.h
//  ios-bizhi-copy
//
//  Created by Limboy on 4/17/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveViewModel.h>
#import "Protocols.h"

@interface BZWaterfallViewModel : RVMViewModel <BZWaterfallViewModelProtocol>
@property (nonatomic) NSArray *pins;
@property (nonatomic) NSString *tag;
@end
