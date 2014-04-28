//
//  BZSettingsModule.m
//  ios-bizhi-copy
//
//  Created by Limboy on 4/21/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "BZSettingsModule.h"
#import "Protocols.h"
#import <JSObjection.h>
#import "BZSettingsViewController.h"

@implementation BZSettingsModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[BZSettingsViewController class] toProtocol:@protocol(BZSettingsViewControllerProtocol)];
}

@end
