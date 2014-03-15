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

@property (weak, nonatomic) IBOutlet UIStepper *loadStepper;
@property (weak, nonatomic) IBOutlet UIStepper *inspectStepper;
@property (weak, nonatomic) IBOutlet UIStepper *dropStepper;
@property (weak, nonatomic) IBOutlet UIStepper *dispenseMinStepper;
@property (weak, nonatomic) IBOutlet UIStepper *dispenseMaxStepper;



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
    self.loadStepper.value = [VWWUserDefaults loadPosition];
    self.inspectStepper.value = [VWWUserDefaults inspectPosition];
    self.dropStepper.value = [VWWUserDefaults dropPosition];
    self.dispenseMinStepper.value = [VWWUserDefaults dispenseMinPosition];
    self.dispenseMaxStepper.value = [VWWUserDefaults dispenseMaxPosition];
    
    self.loadPositionLabel.text = [NSString stringWithFormat:@"%ld", [VWWUserDefaults loadPosition]];
    self.inspectPositionLabel.text = [NSString stringWithFormat:@"%ld", [VWWUserDefaults inspectPosition]];
    self.dropPositionLabel.text = [NSString stringWithFormat:@"%ld", [VWWUserDefaults dropPosition]];
    self.dispenseMinPositionLabel.text = [NSString stringWithFormat:@"%ld", [VWWUserDefaults dispenseMinPosition]];
    self.dispenseMaxPosistionLabel.text = [NSString stringWithFormat:@"%ld", [VWWUserDefaults dispenseMaxPosition]];
    
    self.numOfBinsTextField.text = [NSString stringWithFormat:@"%ld", (long)[VWWUserDefaults dispenseNumChoices]];
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
    self.loadPositionLabel.text = [NSString stringWithFormat:@"%ld", (long)sender.value];
    [VWWUserDefaults setLoadPosition:sender.value];
    [self.delegate trimsTableViewControllerLoadPositionChanged:self];
    VWW_LOG_INFO(@"load position: %ld", (long)sender.value);
}

- (IBAction)inspectPositionStepperValueChanges:(UIStepper*)sender {
    self.inspectPositionLabel.text = [NSString stringWithFormat:@"%ld", (long)sender.value];
    [VWWUserDefaults setInspectPosition:sender.value];
    [self.delegate trimsTableViewControllerInspectPositionChanged:self];
    VWW_LOG_INFO(@"inspect position: %ld", (long)sender.value);
}
- (IBAction)dropPositionStepperValueChanges:(UIStepper*)sender {
    self.dropPositionLabel.text = [NSString stringWithFormat:@"%ld", (long)sender.value];
    [VWWUserDefaults setDropPosition:sender.value];
    [self.delegate trimsTableViewControllerDropPositionChanged:self];
    VWW_LOG_INFO(@"drop position: %ld", (long)sender.value);
}
- (IBAction)dispenseMinPositionStepperValueChanges:(UIStepper*)sender {
    self.dispenseMinPositionLabel.text = [NSString stringWithFormat:@"%ld", (long)sender.value];
    [VWWUserDefaults setDispenseMinPosition:sender.value];
    [self.delegate trimsTableViewControllerDispenseMinPositionChanged:self];
    VWW_LOG_INFO(@"dispense min position: %ld", (long)sender.value);
}
- (IBAction)dispenseMaxPositionStepperValueChanges:(UIStepper*)sender {
    self.dispenseMaxPosistionLabel.text = [NSString stringWithFormat:@"%ld", (long)sender.value];
    [VWWUserDefaults setDispenseMaxPosition:sender.value];
    [self.delegate trimsTableViewControllerDispenseMaxPositionChanged:self];
    VWW_LOG_INFO(@"dispense max position: %ld", (long)sender.value);
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
    
    VWW_LOG_INFO(@"#bins: %ld", textField.text.integerValue);
    [VWWUserDefaults setDispenseNumChoices:textField.text.integerValue];
    
    return NO;
}
@end
