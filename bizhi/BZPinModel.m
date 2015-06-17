//
//  BZPinModel.m
//  bizhi
//
//  Created by Limboy on 4/28/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "BZPinModel.h"

@implementation BZPinModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"file.key": @"key",
                                                       @"pin_id": @"pinId",
                                                       }];
}

- (NSString *)imageURLWithThumbnailWidth:(NSInteger)width
{
    return [NSString stringWithFormat:@"http://img.hb.aicdn.com/%@_fw%ld", self.key, (long)width];
}

@end
