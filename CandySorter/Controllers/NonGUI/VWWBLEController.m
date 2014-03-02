//
//  VWWBLEController.m
//  CandySorter
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWBLEController.h"
#import "BLE.h"

@interface VWWBLEController () <BLEDelegate>
@property (strong, nonatomic) BLE *ble;
@end

@implementation VWWBLEController

+(VWWBLEController*)sharedInstance{
    static VWWBLEController *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc]init];
    });
    return instance;
}


-(id)init{
    self = [super init];
    if(self){
        _ble = [[BLE alloc] init];
        [_ble controlSetup];
        _ble.delegate = self;
    }
    return self;
}



#pragma mark Private methods

// Connect button will call to this
-(void)scanForPeripherals{
    if (self.ble.activePeripheral){
        if(self.ble.activePeripheral.state == CBPeripheralStateConnected){
            [[self.ble CM] cancelPeripheralConnection:[self.ble activePeripheral]];
//            [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
            VWW_LOG_INFO(@"Found peripheral devices");
            return;
        }
    }
    if (self.ble.peripherals){
        self.ble.peripherals = nil;
    }
    
//    [btnConnect setEnabled:false];
    VWW_LOG_INFO(@"Enable connect button here");
    [self.ble findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
//    [indConnecting startAnimating];
    VWW_LOG_INFO(@"Start animating...");
}

-(void)connectionTimer:(NSTimer *)timer{
//    [btnConnect setEnabled:true];
    VWW_LOG_INFO(@"Enable connect button");
//    [btnConnect setTitle:@"Disconnect" forState:UIControlStateNormal];
    VWW_LOG_INFO(@"Set button title to disconnect");
    
    if (self.ble.peripherals.count > 0){
        [self.ble connectPeripheral:[self.ble.peripherals objectAtIndex:0]];
    }
    else
    {
//        [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
        VWW_LOG_INFO(@"Set button title to connect");
//        [indConnecting stopAnimating];
        VWW_LOG_INFO(@"Stop animating");
    }
}


#pragma mark BLEDelegate
-(void)bleDidConnect{
    VWW_LOG_TRACE;
    [self.delegate bleControllerDidConnect:self];
}
-(void)bleDidDisconnect{
    VWW_LOG_TRACE;
}
-(void)bleDidUpdateRSSI:(NSNumber *)rssi{
    VWW_LOG_TRACE;
}
-(void)bleDidReceiveData:(unsigned char *) data length:(int) length{
    VWW_LOG_TRACE;
}




@end
