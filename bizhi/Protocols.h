//
//  Protocols.h
//  ios-bizhi-copy
//
//  Created by Limboy on 4/17/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;

@protocol BZWaterfallViewControllerProtocol <NSObject>
- (void)configureWithTag:(NSString *)tag;
- (void)configureWithLatest;
@end


@protocol BZWaterfallViewModelProtocol <NSObject>
@property (nonatomic) NSArray *pins;
- (RACSignal *)fetchPinsWithTag:(NSString *)tag offset:(NSUInteger)offset;
- (RACSignal *)fetchMore;
@end


@protocol BZDetailViewControllerProtocol <NSObject>
@property (nonatomic) NSInteger currentPinIndex;
@property (nonatomic) NSInteger initPinIndex;
- (void)configureWithViewModel:(id<BZWaterfallViewModelProtocol>)viewModel;
@end

@protocol  BZTagsViewControllerProtocol <NSObject>
@end

@protocol  BZSettingsViewControllerProtocol <NSObject>
@end