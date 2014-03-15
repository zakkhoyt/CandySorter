//
//  VWWCommandsTableViewController.m
//  CandySorter
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWCommandsTableViewController.h"

@interface VWWCommandsTableViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *autoPickSwitch;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;

@end

@implementation VWWCommandsTableViewController



- (void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


#pragma mark IBActions

- (IBAction)startButtonTouchUpInside:(id)sender {
    [self.delegate commandsTableViewControllerStartButtonTouchUpInside:self];
}

- (IBAction)stopButtonTouchUpInside:(id)sender {
    [self.delegate commandsTableViewControllerStopButtonTouchUpInside:self];
}

- (IBAction)loadButtonTouchUpInside:(id)sender {
    [self.delegate commandsTableViewControllerLoadButtonTouchUpInside:self];
}

- (IBAction)dropButtonTouchUpInside:(id)sender {
    [self.delegate commandsTableViewControllerDropButtonTouchUpInside:self];
}

- (IBAction)autoPickSwitchValueChanged:(UISwitch*)sender {
    [self.delegate commandsTableViewController:self autoPickSwitchValueChanged:sender.on];
}
- (IBAction)initServosButtonTouchUpInside:(id)sender {
    [self.delegate commandsTableViewControllerInitButtonTouchUpInside:self];
//    [self.bleController initializeServos];
}
- (IBAction)trimsButtonTouchUpInside:(id)sender {
    [self.delegate commandsTableViewControllerTrimsButtonTouchUpInside:self];
}

-(void)setRssi:(NSString *)rssi{
    _rssi = rssi;
    self.rssiLabel.text = rssi;
}


@end
