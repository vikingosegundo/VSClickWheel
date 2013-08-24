//
//  AppDelegate.h
//  VSClickWheelExample
//
//  Created by Manuel Meyer on 22.08.13.
//  Copyright (c) 2013 Manuel Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExampleViewController;

@interface ExampleAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ExampleViewController *viewController;

@end
