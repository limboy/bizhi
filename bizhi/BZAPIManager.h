//
//  BZAPIManager.h
//  bizhi
//
//  Created by Limboy on 4/28/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@class RACSignal;

@interface BZAPIManager : AFHTTPRequestOperationManager

+ (instancetype)sharedManager;

- (RACSignal *)fetchPinsWithTag:(NSString *)tag offset:(NSInteger)offset limit:(NSInteger)limit;

- (RACSignal *)fetchTags;

@end
