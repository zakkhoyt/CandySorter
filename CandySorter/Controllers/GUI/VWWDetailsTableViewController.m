//
//  VWWDetailsTableViewController.m
//  CandySorter
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWDetailsTableViewController.h"

@interface VWWDetailsTableViewController ()

@end

@implementation VWWDetailsTableViewController


- (void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
