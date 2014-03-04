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
    __block BOOL complete = NO;
    
    NSNumber *loadPositionNumber = [VWWUserDefaults loadPosition];
    UInt8 loadPosition = loadPositionNumber.integerValue;
    [self.bleController setLoadPosition:loadPosition completionBlock:^{
        complete = YES;
    }];
    
    while(complete == NO){
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    complete = NO;
    
    NSNumber *inspectPositionNumber = [VWWUserDefaults inspectPosition];
    UInt8 inspectPosition = inspectPositionNumber.integerValue;
    [self.bleController setInspectPosition:inspectPosition completionBlock:^{
        complete = YES;
    }];
    
    while(complete == NO){
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    complete = NO;

    NSNumber *dropPositionNumber = [VWWUserDefaults dropPosition];
    UInt8 dropPosition = dropPositionNumber.integerValue;
    [self.bleController setDropPosition:dropPosition completionBlock:^{
        complete = YES;
    }];
    
    while(complete == NO){
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    complete = NO;

    
    NSNumber *dispenseMinPositionNumber = [VWWUserDefaults dispenseMinPosition];
    UInt8 dispenseMinPosision = dispenseMinPositionNumber.integerValue;
    [self.bleController setDispenseMinPosition:dispenseMinPosision completionBlock:^{
        complete = YES;
    }];
    
    while(complete == NO){
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    complete = NO;
    
    NSNumber *dispenseMaxPositionNumber = [VWWUserDefaults dispenseMaxPosition];
    UInt8 dispenseMaxPosision = dispenseMaxPositionNumber.integerValue;
    [self.bleController setDispenseMaxPosition:dispenseMaxPosision completionBlock:^{
        complete = YES;
    }];
    
    while(complete == NO){
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    complete = NO;

    
    NSNumber *dispenseNumChoicesNumber = [VWWUserDefaults dispenseNumChoices];
    UInt8 dispenseNumChoices = dispenseNumChoicesNumber.integerValue;
    [self.bleController setDispenseNumChoices:dispenseNumChoices completionBlock:^{
        complete = YES;
    }];
    
    completionBlock();
    
}


#pragma mark IBActions
- (IBAction)connectButtonTouchUpInside:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.connectButton.enabled = NO;
    hud.dimBackground = YES;
    hud.labelText = @"Connecting...";
    [self.bleController scanForPeripherals];
}
- (IBAction)scannerButtonTouchUpInside:(id)sender {
    [self performSegueWithIdentifier:VWWSegueDefaultToScanner sender:self];
}



#pragma mark VWWBLEControllerDelegate

-(void)bleControllerDidConnect:(VWWBLEController*)sender{
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


@end
