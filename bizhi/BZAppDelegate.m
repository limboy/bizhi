//
//  BZAppDelegate.m
//  bizhi
//
//  Created by Limboy on 4/28/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "BZAppDelegate.h"
#import "Protocols.h"
#import <Objection.h>

@implementation BZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self setupRootViewController];
    return YES;
}

- (void)setupRootViewController
{
    UITabBarController *tabViewController = [[UITabBarController alloc] init];
    
    UIViewController <BZWaterfallViewControllerProtocol> *waterfallViewController = [[JSObjection defaultInjector] getObject:@protocol(BZWaterfallViewControllerProtocol)];
    [waterfallViewController configureWithLatest];
    UINavigationController *waterfallNavigationController = [[UINavigationController alloc] initWithRootViewController:waterfallViewController];
    waterfallViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"最新" image:[UIImage imageNamed:@"latest"] tag:0];
    waterfallViewController.title = @"最新";
    
    UIViewController <BZTagsViewControllerProtocol> *tagsViewController = [[JSObjection defaultInjector] getObject:@protocol(BZTagsViewControllerProtocol)];
    UINavigationController *tagsNavigationController = [[UINavigationController alloc] initWithRootViewController:tagsViewController];
    tagsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"分类" image:[UIImage imageNamed:@"categories"] tag:1];
    tagsViewController.title = @"分类";
    
    UIViewController <BZSettingsViewControllerProtocol> *settingsViewController = [[JSObjection defaultInjector] getObject:@protocol(BZSettingsViewControllerProtocol)];
    settingsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"settings"] tag:2];
    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    settingsViewController.title = @"设置";
    
    tabViewController.viewControllers = @[waterfallNavigationController, tagsNavigationController, settingsNavigationController];
    self.window.rootViewController = tabViewController;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
