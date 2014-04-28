//
//  BZTagsModule.m
//  ios-bizhi-copy
//
//  Created by Limboy on 4/21/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "BZTagsModule.h"
#import "Protocols.h"
#import "BZTagsViewController.h"
#import <JSObjection.h>

@implementation BZTagsModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[BZTagsViewController class] toProtocol:@protocol(BZTagsViewControllerProtocol)];
}
@end
