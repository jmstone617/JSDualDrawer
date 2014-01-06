/*
 The MIT License (MIT)
 
 Copyright (c) 2013 Jordan Stone
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

//
//  JSDualDrawerViewController.m
//  JSDualDrawer
//
//  Created by Jordan Stone on 6/25/13.
//  Copyright (c) 2013 Jordan Stone. All rights reserved.
//

#import "JSDualDrawerViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kOpenDrawerOffset 280.0f

@interface JSDualDrawerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UINavigationController *currentNavigationController;
@property (nonatomic, strong, readwrite) NSArray *viewControllers;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic) BOOL leftDrawerShowing;
@property (nonatomic) BOOL rightDrawerShowing;

@end

@implementation JSDualDrawerViewController

+ (JSDualDrawerViewController *)sharedDrawerController {
    static JSDualDrawerViewController *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JSDualDrawerViewController alloc] init];
    });
    
    return instance;
}

- (id)initWithNumberOfDrawers:(JSDualDrawerNumberOfDrawers)numberOfDrawers openDirection:(JSDualDrawerOpenDrawerDirection)openDirection {
    self = [super init];
    
    if (self) {
        _numberOfDrawers = numberOfDrawers;
        _openDrawerDirection = openDirection;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.leftTableView setDelegate:self];
    [self.leftTableView setDataSource:self];
    
    [self.leftTableView.layer setCornerRadius:6.0];
    [self.leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LeftCell"];
    
    [self.view addSubview:self.leftTableView];
    
    if (self.numberOfDrawers == JSDualDrawerNumberOfDrawersTwo) {
        self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(35, 0, 285, self.view.frame.size.height) style:UITableViewStylePlain];
        [self.rightTableView setDelegate:self];
        [self.rightTableView setDataSource:self];
        
        [self.rightTableView.layer setCornerRadius:6.0];
        [self.rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"RightCell"];
        
        [self.view addSubview:self.rightTableView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addViewControllers:(NSArray *)viewControllers {
    self.viewControllers = viewControllers;
    
    UIViewController *initialViewController = viewControllers[0];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:initialViewController];
    [navController.view setClipsToBounds:NO];
    
    [self addChildViewController:navController];
    [navController didMoveToParentViewController:self];
    
    [self.view addSubview:navController.view];
    
    self.currentNavigationController = navController;
    
    UIBarButtonItem *leftNavItem = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonPressed:)];
    
    UINavigationItem *item = self.currentNavigationController.navigationBar.items[0];
    [item setLeftBarButtonItem:leftNavItem];
    
    if (self.numberOfDrawers == JSDualDrawerNumberOfDrawersTwo) {
        UIBarButtonItem *rightNavItem = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonPressed:)];
        [item setRightBarButtonItem:rightNavItem];
    }
    
    self.topViewController = self.currentNavigationController.topViewController;
}

- (void)leftButtonPressed:(id)sender {
    [self showLeftDrawer:!self.leftDrawerShowing];
}

- (void)rightButtonPressed:(id)sender {
    [self showRightDrawer:!self.rightDrawerShowing];
}

- (void)showLeftDrawer:(BOOL)show {
    CGRect homeBaseFrame = CGRectMake(0, 0, self.currentNavigationController.view.frame.size.width, self.currentNavigationController.view.frame.size.height);
    
    if (show) {
        [self.leftTableView setHidden:NO];
        [self.rightTableView setHidden:YES];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, -1, 0);
        CGPathAddLineToPoint(path, NULL, -1, CGRectGetHeight(self.currentNavigationController.view.frame));
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(self.currentNavigationController.view.frame));
        CGPathCloseSubpath(path);
        
        [self.currentNavigationController.view.layer setShadowPath:path];
        [self.currentNavigationController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.currentNavigationController.view.layer setShadowOpacity:1.0];
        [self.currentNavigationController.view.layer setShadowOffset:CGSizeMake(0.0, -3.0)];
        
        CGPathRelease(path);
        
        [UIView animateWithDuration:0.3 animations:^{
            switch (self.openDrawerDirection) {
                case JSDualDrawerOpenDrawerDirectionFromSide: {
                    [self.currentNavigationController.view setFrame:CGRectMake(homeBaseFrame.origin.x + kOpenDrawerOffset, homeBaseFrame.origin.y, homeBaseFrame.size.width, homeBaseFrame.size.height)];
                    
                    break;
                }
                case JSDualDrawerOpenDrawerDirectionFromTop: {
                    [self.currentNavigationController.view setFrame:CGRectMake(0, homeBaseFrame.origin.y + (homeBaseFrame.size.height - 40), homeBaseFrame.size.width, homeBaseFrame.size.height)];
                    
                    break;
                }
                case JSDualDrawerOpenDrawerDirectionFromBottom: {
                    [self.currentNavigationController.view setFrame:CGRectMake(0, homeBaseFrame.origin.y - (homeBaseFrame.size.height - 40), homeBaseFrame.size.width, homeBaseFrame.size.height)];
                    
                    break;
                }
                default:
                    break;
            }
            
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.currentNavigationController.view setFrame:homeBaseFrame];
        }];
    }
    
    self.leftDrawerShowing = show;
}

- (void)showRightDrawer:(BOOL)show {
    CGRect homeBaseFrame = CGRectMake(0, 0, self.currentNavigationController.view.frame.size.width, self.currentNavigationController.view.frame.size.height);
    
    if (show) {
        [self.leftTableView setHidden:YES];
        [self.rightTableView setHidden:NO];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, homeBaseFrame.size.width, 0);
        CGPathAddLineToPoint(path, NULL, homeBaseFrame.size.width + 1, 0);
        CGPathAddLineToPoint(path, NULL, homeBaseFrame.size.width + 1, CGRectGetHeight(self.currentNavigationController.view.frame));
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(self.currentNavigationController.view.frame));
        CGPathCloseSubpath(path);
        
        [self.currentNavigationController.view.layer setShadowPath:path];
        [self.currentNavigationController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.currentNavigationController.view.layer setShadowOpacity:1.0];
        [self.currentNavigationController.view.layer setShadowOffset:CGSizeMake(-1.0, -3.0)];
        
        CGPathRelease(path);
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.currentNavigationController.view setFrame:CGRectMake(homeBaseFrame.origin.x - kOpenDrawerOffset, homeBaseFrame.origin.y, homeBaseFrame.size.width, homeBaseFrame.size.height)];
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.currentNavigationController.view setFrame:homeBaseFrame];
        }];
    }
    
    self.rightDrawerShowing = show;
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewControllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        static NSString *cellIdentifier = @"LeftCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        UIViewController *vc = self.viewControllers[indexPath.row];
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%@", vc.title]];
        
        return cell;
    }
    else {
        static NSString *rightCellIdentifier = @"RightCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightCellIdentifier forIndexPath:indexPath];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        UIViewController *newVC = self.viewControllers[indexPath.row];
        UIViewController *oldVC = self.currentNavigationController;
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newVC];
        [navController.view setClipsToBounds:NO];
        
        [self transitionFromViewController:oldVC toViewController:navController];
    }
    else {
        [self showRightDrawer:NO];
    }
}

#pragma mark - Private Transition Method
- (void)transitionFromViewController:(UIViewController *)oldViewController toViewController:(UIViewController *)newViewController {
    [self addChildViewController:newViewController];
    
    UINavigationController *navController = (UINavigationController *)newViewController;
    
    [navController.view setFrame:oldViewController.view.frame];
    
    UIBarButtonItem *leftNavItem = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonPressed:)];
    UIBarButtonItem *rightNavItem = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonPressed:)];
    
    UINavigationItem *item = navController.navigationBar.items[0];
    [item setLeftBarButtonItem:leftNavItem];
    [item setRightBarButtonItem:rightNavItem];
    
    [UIView animateWithDuration:0.2 animations:^{
        switch (self.openDrawerDirection) {
            case JSDualDrawerOpenDrawerDirectionFromSide: {
                [oldViewController.view setFrame:CGRectMake(320, 0, 320, oldViewController.view.frame.size.height)];
                
                break;
            }
            case JSDualDrawerOpenDrawerDirectionFromTop: {
                [oldViewController.view setFrame:CGRectMake(0, self.view.frame.size.height, 320, oldViewController.view.frame.size.height)];
                
                break;
            }
            case JSDualDrawerOpenDrawerDirectionFromBottom: {
                [oldViewController.view setFrame:CGRectMake(0, -self.view.frame.size.height, 320, oldViewController.view.frame.size.height)];
                
                break;
            }
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [oldViewController.view removeFromSuperview];
        
        [oldViewController removeFromParentViewController];
        
        [navController.view setFrame:oldViewController.view.frame];
        
        [self.view addSubview:navController.view];
        
        [UIView animateWithDuration:0.4 animations:^{
            
            CGRect homeBaseFrame = CGRectMake(0, 0, navController.view.frame.size.width, navController.view.frame.size.height);
            
            [navController.view setFrame:homeBaseFrame];
            
        } completion:^(BOOL finished) {
            self.currentNavigationController = navController;
            self.topViewController = self.currentNavigationController.topViewController;
            [navController didMoveToParentViewController:self];
            self.leftDrawerShowing = NO;
        }];
    }];
}

@end

@implementation UIViewController (JSDualDrawerViewController)

- (JSDualDrawerViewController *)dualDrawerController {
    return (JSDualDrawerViewController *)self.parentViewController.parentViewController;
}

@end
