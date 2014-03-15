//
//  VWWDefaultViewController.m
//  CandySorter
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWDefaultViewController.h"
#import "VWWBLEController.h"
#import "MBProgressHUD.h"

static NSString *VWWSegueDefaultToScanner = @"VWWSegueDefaultToScanner";

@interface VWWDefaultViewController () <VWWBLEControllerDelegate>
@property (nonatomic, strong) VWWBLEController *bleController;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (nonatomic, strong) MBProgressHUD *hud;
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
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
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

-(BOOL)prefersStatusBarHidden{
    return YES;
}


#pragma mark Private methods

// Configure with servo positions
-(void)configureArduinoWithCompletionBlock:(VWWEmptyBlock)completionBlock{
    

    // This is a hoaky way to get around synchronously calling asynchronous blocks
    // However CoreData seems to only want to run on the main thread making
    // dispatch_semaphore and NSRunLoop polling tend to freeze the GUI.
    // Since these calls return fairly quickly, we'll just sleep between each call.
    // This is not a typical way to accomplish this in iOS programming.
    UInt8 loadPosition = [VWWUserDefaults loadPosition];
    [self.bleController setLoadPosition:loadPosition completionBlock:^{

    }];
    
    [NSThread sleepForTimeInterval:1.0];

    UInt8 inspectPosition = [VWWUserDefaults inspectPosition];
    [self.bleController setInspectPosition:inspectPosition completionBlock:^{

    }];
    
    [NSThread sleepForTimeInterval:1.0];

    UInt8 dropPosition = [VWWUserDefaults dropPosition];
    [self.bleController setDropPosition:dropPosition completionBlock:^{
    
    }];
    
    [NSThread sleepForTimeInterval:1.0];
    
    UInt8 dispenseMinPosision = [VWWUserDefaults dispenseMinPosition];
    [self.bleController setDispenseMinPosition:dispenseMinPosision completionBlock:^{
    
    }];
    
    [NSThread sleepForTimeInterval:1.0];
    
    UInt8 dispenseMaxPosision = [VWWUserDefaults dispenseMaxPosition];
    [self.bleController setDispenseMaxPosition:dispenseMaxPosision completionBlock:^{
    
    }];
    
    [NSThread sleepForTimeInterval:1.0];
    
    UInt8 dispenseNumChoices = [VWWUserDefaults dispenseNumChoices];
    [self.bleController setDispenseNumChoices:dispenseNumChoices completionBlock:^{
    
    }];
    
    [NSThread sleepForTimeInterval:3.0];
    
    completionBlock();
    
}


#pragma mark IBActions
- (IBAction)connectButtonTouchUpInside:(id)sender {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.connectButton.enabled = NO;
    self.hud.dimBackground = YES;
    self.hud.labelText = @"Connecting...";
    [self.bleController scanForPeripherals];
}
- (IBAction)scannerButtonTouchUpInside:(id)sender {
    [self performSegueWithIdentifier:VWWSegueDefaultToScanner sender:self];
}



#pragma mark VWWBLEControllerDelegate

-(void)bleControllerDidConnect:(VWWBLEController*)sender{
    self.hud.detailsLabelText = @"Initializing...";
    [self configureArduinoWithCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self performSegueWithIdentifier:VWWSegueDefaultToScanner sender:self];
        self.connectButton.enabled = YES;
    }];
}
-(void)bleControllerDidDisconnect:(VWWBLEController*)sender{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.connectButton.enabled = YES;
}

-(void)bleController:(VWWBLEController *)sender didUpdateRSSI:(NSNumber *)rssi{
    
}


@end
