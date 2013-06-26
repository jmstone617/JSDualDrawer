//
//  JSDualDrawerViewController.h
//  JSDualDrawer
//
//  Created by Jordan Stone on 6/25/13.
//  Copyright (c) 2013 Jordan Stone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSDualDrawerViewController : UIViewController

@property (nonatomic, strong, readonly) NSArray *viewControllers;
@property (nonatomic, strong) UIViewController *topViewController;

+ (JSDualDrawerViewController *)sharedDrawerController;

- (void)addViewControllers:(NSArray *)viewControllers;

@end
