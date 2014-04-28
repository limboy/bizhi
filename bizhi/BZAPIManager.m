//
//  BZAPIManager.m
//  bizhi
//
//  Created by Limboy on 4/28/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "BZAPIManager.h"
#import <ReactiveCocoa.h>
#import <AFNetworking-RACExtensions/AFHTTPRequestOperationManager+RACSupport.h>
#import "BZPinModel.h"

@implementation BZAPIManager

+ (instancetype)sharedManager
{
    static BZAPIManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self manager];
    });
    return instance;
}

- (RACSignal *)fetchPinsWithOffset:(NSInteger)offset limit:(NSInteger)limit
{
    NSString *max = offset ? [NSString stringWithFormat:@"max=%d", offset] : @"";
    NSString *urlString = [NSString stringWithFormat:@"http://api.huaban.com/fm/wallpaper/pins?limit=%d&%@", limit, max];
    return [[self rac_GET:urlString parameters:nil] map:^id(NSDictionary *data) {
        NSMutableArray *pins = [[NSMutableArray alloc] init];
        [data[@"pins"] enumerateObjectsUsingBlock:^(NSDictionary *pin, NSUInteger idx, BOOL *stop) {
            [pins addObject:[[BZPinModel alloc] initWithDictionary:pin error:nil]];
        }];
        return pins;
    }];
}

@end
