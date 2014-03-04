//
//  VWWTrimsTableViewController.m
//  CandySorter
//
//  Created by Zakk Hoyt on 3/3/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWTrimsTableViewController.h"

@interface VWWTrimsTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *loadPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *inspectPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dispenseMinPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dispenseMaxPosistionLabel;
@property (weak, nonatomic) IBOutlet UITextField *numOfBinsTextField;

@end

@implementation VWWTrimsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark IBActions
- (IBAction)loadPositionStepperValueChanges:(UIStepper*)sender {
}

- (IBAction)inspectPositionStepperValueChanges:(UIStepper*)sender {
}
- (IBAction)dropPositionStepperValueChanges:(UIStepper*)sender {
}
- (IBAction)dispenseMinPositionStepperValueChanges:(UIStepper*)sender {
}
- (IBAction)dispenseMaxPositionStepperValueChanges:(UIStepper*)sender {
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    /* for backspace */
    if([string length]==0){
        return YES;
    }
    
    /*  limit to only numeric characters  */
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if ([myCharSet characterIsMember:c]) {
            return YES;
        }
    }
    
    return NO;
}
@end
