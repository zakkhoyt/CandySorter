//
//  VWWCommandsTableViewController.m
//  CandySorter
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWCommandsTableViewController.h"

@interface VWWCommandsTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *assignButton;

@end

@implementation VWWCommandsTableViewController



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



- (IBAction)assignButtonTouchUpInside:(id)sender {
}
- (IBAction)editButtonTouchUpInside:(id)sender {
}



@end
