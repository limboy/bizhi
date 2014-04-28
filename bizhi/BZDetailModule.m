//
//  BZDetailModule.m
//  ios-bizhi-copy
//
//  Created by Limboy on 4/18/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "BZDetailModule.h"
#import "BZDetailViewController.h"
#import <Objection.h>

@implementation BZDetailModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[BZDetailViewController class] toProtocol:@protocol(BZDetailViewControllerProtocol)];
}

@end
