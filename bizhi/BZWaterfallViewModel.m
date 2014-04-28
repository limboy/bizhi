//
//  BZWaterfallViewModel.m
//  ios-bizhi-copy
//
//  Created by Limboy on 4/17/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "BZWaterfallViewModel.h"
#import "BZAPIManager.h"
#import "BZPinModel.h"
#import <ReactiveCocoa.h>

@interface BZWaterfallViewModel ()
@end

@implementation BZWaterfallViewModel

#pragma mark - Public Methods

- (RACSignal *)fetchPinsWithTag:(NSString *)tag offset:(NSUInteger)offset
{
    return [[BZAPIManager sharedManager] fetchPinsWithTag:tag offset:offset limit:21];
}

- (RACSignal *)fetchMore
{
    NSInteger seq = self.pins.count ? ((BZPinModel *)[self.pins lastObject]).seq : 0;
    return [[BZAPIManager sharedManager] fetchPinsWithTag:self.tag offset:seq limit:21];
}

#pragma mark Accessors

- (NSArray *)pins
{
    if (!_pins) {
        _pins = [NSArray array];
    }
    return _pins;
}

@end
