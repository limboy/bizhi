//
//  BZWaterfallModule.m
//  ios-bizhi-copy
//
//  Created by Limboy on 4/17/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "BZWaterfallModule.h"
#import <Objection.h>
#import "BZWaterfallViewController.h"
#import "Protocols.h"

@implementation BZWaterfallModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[BZWaterfallViewController class] toProtocol:@protocol(BZWaterfallViewControllerProtocol)];
}

@end
