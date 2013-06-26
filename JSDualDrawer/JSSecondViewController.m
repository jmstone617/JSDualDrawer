//
//  JSSecondViewController.m
//  JSDualDrawer
//
//  Created by Jordan Stone on 6/25/13.
//  Copyright (c) 2013 Jordan Stone. All rights reserved.
//

#import "JSSecondViewController.h"

@interface JSSecondViewController ()

@end

@implementation JSSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.title = @"Second VC";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
