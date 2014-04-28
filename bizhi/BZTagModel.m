//
//  BZTagModel.m
//  bizhi
//
//  Created by Limboy on 4/28/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "BZTagModel.h"

@implementation BZTagModel

+ (JSONKeyMapper *)keyMapper
{
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
