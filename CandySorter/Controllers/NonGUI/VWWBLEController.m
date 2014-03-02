//
//  VWWBLEController.m
//  CandySorter
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWBLEController.h"
#import "BLE.h"




// We will be sending commands to the arduino and back with 3 byte commds:
//          [0]         [1]         [2]
// data[] = [command]   [param1]    [param2]
//
// So for example if we want to tell arduino to drop a piece of candy in bin 4:
//  UInt8 buf[3] = {kDropCandyCommand, 0x04, 0xXX};
//  NSData *data = [[NSData alloc] initWithBytes:buf length:3];
//  [self.ble write:data];
//
// Likewise, when we send a command from the arudino to iOS parse it like this
//-(void)bleDidReceiveData:(unsigned char *)data length:(int)length{
//    VWW_LOG_INFO(@"Length: %d", length);
//    
//    // parse data, all commands are in 3-byte
//    for (int i = 0; i < length; i+=3){
//        VWW_LOG_INFO(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);
//        
//        if (data[i] == kCandyWasDroppedCommand){
//            VWW_LOG_INFO(@"Candy was dropped");
//            
//            // Parse param1
//            if (data[i+1] == 0x01){
//            } else {
//            }
//            
//            // Parse param2
//            if (data[i+2] == 0x01){
//            } else {
//            }
//        }
//    }
//}

const u_int8_t kLoadCandyCommand = 0xB0;
const u_int8_t kDropCandyCommand = 0xB1;

const u_int8_t kCandyWasLoadedCommand = 0xC0;
const u_int8_t kCandyWasDroppedCommand = 0xC1;





@interface VWWBLEController () <BLEDelegate>
@property (strong, nonatomic) BLE *ble;
@end

@implementation VWWBLEController


#pragma mark Public methods

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


-(void)loadCandy{
    UInt8 buf[3] = {kLoadCandyCommand, 0x00, 0x00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self.ble write:data];

}
-(void)dropCandyInBin:(UInt8)bin{
    UInt8 buf[3] = {0x01, 0x00, 0x00};
    buf[1] = bin;
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self.ble write:data];
}



#pragma mark Private methods

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
-(void)bleDidReceiveData:(unsigned char *)data length:(int)length{
    VWW_LOG_INFO(@"Length: %d", length);
    
    // parse data, all commands are in 3-byte
    for (int i = 0; i < length; i+=3){
        VWW_LOG_INFO(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);
        
        if(data[i] == kCandyWasLoadedCommand){
            VWW_LOG_INFO(@"Candy was loaded");
            
//            // Parse param1
//            if (data[i+1] == 0x01){
//            } else {
//            }
            
//            // Parse param2
//            if (data[i+2] == 0x01){
//            } else {
//            }
        } else if(data[i] == kCandyWasDroppedCommand){
            VWW_LOG_INFO(@"Candy was dropped");
            [self.delegate bleControllerDidLoadCandy:self];
        } else {
            VWW_LOG_INFO(@"Received unknown command");
            [self.delegate bleControllerDidDropCandy:self];
        }
    }
}




@end
