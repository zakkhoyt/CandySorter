//
//  VWWCommandsTableViewController.m
//  CandySorter
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWCommandsTableViewController.h"
#import "VWWBLEController.h"

@interface VWWCommandsTableViewController () <VWWBLEControllerDelegate>
@property (nonatomic, strong) VWWBLEController *bleController;
@property (weak, nonatomic) IBOutlet UISwitch *autoPickSwitch;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;

@end

@implementation VWWCommandsTableViewController



- (void)viewDidLoad{
    [super viewDidLoad];
    self.bleController = [VWWBLEController sharedInstance];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.bleController.delegate = self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


#pragma mark IBActions

- (IBAction)startButtonTouchUpInside:(id)sender {

}

- (IBAction)stopButtonTouchUpInside:(id)sender {
    
}

- (IBAction)loadButtonTouchUpInside:(id)sender {
    [self.bleController loadCandy];
}

- (IBAction)dropButtonTouchUpInside:(id)sender {
    NSInteger bin = arc4random() % 12;
    [self.bleController dropCandyInBin:bin];
}

- (IBAction)autoPickSwitchValueChanged:(id)sender {
    
}

#pragma mark VWWBLEDelegate
-(void)bleControllerDidConnect:(VWWBLEController*)sender{
    
}
-(void)bleControllerDidDisconnect:(VWWBLEController*)sender{
    VWW_LOG_WARNING(@"BLE Disconnected");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)bleController:(VWWBLEController*)sender didUpdateRSSI:(NSNumber*)rssi{
    self.rssiLabel.text = rssi.stringValue;
}



@end
