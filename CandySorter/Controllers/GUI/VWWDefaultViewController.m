//
//  VWWDefaultViewController.m
//  CandySorter
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWDefaultViewController.h"
#import "VWWBLEController.h"

static NSString *VWWSegueDefaultToScanner = @"VWWSegueDefaultToScanner";

@interface VWWDefaultViewController () <VWWBLEControllerDelegate>
@property (nonatomic, strong) VWWBLEController *bleController;
@end

@implementation VWWDefaultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bleController = [VWWBLEController sharedInstance];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.bleController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark IBActions
- (IBAction)connectButtonTouchUpInside:(id)sender {
    [self.bleController scanForPeripherals];
}
- (IBAction)scannerButtonTouchUpInside:(id)sender {
    [self performSegueWithIdentifier:VWWSegueDefaultToScanner sender:self];
}



#pragma mark VWWBLEControllerDelegate

-(void)bleControllerDidConnect:(VWWBLEController*)sender{
    [self performSegueWithIdentifier:VWWSegueDefaultToScanner sender:self];
}
-(void)bleControllerDidDisconnect:(VWWBLEController*)sender{
    
}


@end
