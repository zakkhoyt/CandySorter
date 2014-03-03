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
const u_int8_t kIntializeServosCommand = 0xB2;

const u_int8_t kCandyWasLoadedCommand = 0xC0;
const u_int8_t kCandyWasDroppedCommand = 0xC1;
const u_int8_t kServosDidInitializeCommand = 0xC2;




@interface VWWBLEController () <BLEDelegate>
@property (strong, nonatomic) BLE *ble;

@property (nonatomic, strong) VWWEmptyBlock loadCandyCompletionBlock;
@property (nonatomic, strong) VWWEmptyBlock dropCandyCompletionBlock;
@property (nonatomic, strong) VWWEmptyBlock initServosCompletionBlock;
@property (nonatomic, strong) NSTimer *rssiTimer;
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

-(void)initializeServosWithCompletionBlock:(VWWEmptyBlock)completionBlock{
    self.initServosCompletionBlock = completionBlock;
    UInt8 buf[3] = {kIntializeServosCommand , 0x00, 0x00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self.ble write:data];
}

-(void)loadCandyWithCompletionBlock:(VWWEmptyBlock)completionBlock{
    self.loadCandyCompletionBlock = completionBlock;
    UInt8 buf[3] = {kLoadCandyCommand, 0x00, 0x00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self.ble write:data];

}
-(void)dropCandyInBin:(UInt8)bin completionBlock:(VWWEmptyBlock)completionBlock{
    self.dropCandyCompletionBlock = completionBlock;
    UInt8 buf[3] = {kDropCandyCommand, 0x00, 0x00};
    buf[1] = bin;
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self.ble write:data];
}



#pragma mark Private methods


-(void) readRSSITimer:(NSTimer *)timer{
    [self.ble readRSSI];
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
    
    self.rssiTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];

    [self.delegate bleControllerDidConnect:self];
    
}
-(void)bleDidDisconnect{
    VWW_LOG_TRACE;
    [self.rssiTimer invalidate];
    [self.delegate bleControllerDidDisconnect:self];
}
-(void)bleDidUpdateRSSI:(NSNumber *)rssi{
    VWW_LOG_TRACE;
    [self.delegate bleController:self didUpdateRSSI:rssi];
}
-(void)bleDidReceiveData:(unsigned char *)data length:(int)length{
    VWW_LOG_INFO(@"Length: %d", length);
    
    // parse data, all commands are in 3-byte
    for (int i = 0; i < length; i+=3){
        VWW_LOG_INFO(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);

        //            // Parse param1
        //            if (data[i+1] == 0x01){
        //            } else {
        //            }
        
        //            // Parse param2
        //            if (data[i+2] == 0x01){
        //            } else {
        //            }

        if(data[i] == kCandyWasLoadedCommand){
            VWW_LOG_INFO(@"Candy was loaded");
            if(self.loadCandyCompletionBlock){
                self.loadCandyCompletionBlock();
            }
        } else if(data[i] == kCandyWasDroppedCommand){
            VWW_LOG_INFO(@"Candy was dropped");
            if(self.dropCandyCompletionBlock){
                self.dropCandyCompletionBlock();
            }
        } else if(data[i] == kServosDidInitializeCommand){
            VWW_LOG_INFO(@"Servos are initialized");
            if(self.initServosCompletionBlock){
                self.initServosCompletionBlock();
            }
        } else {
            VWW_LOG_INFO(@"Received unknown command");

        }
    }
}




@end
