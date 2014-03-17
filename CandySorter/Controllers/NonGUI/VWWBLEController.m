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




const UInt8 kLoadCandyCommand = 0xB0;
const UInt8 kDropCandyCommand = 0xB1;
const UInt8 kIntializeServosCommand = 0xB2;
const UInt8 kSetLoadPositionCommand = 0xB3;
const UInt8 kSetInspectPositionCommand = 0xB4;
const UInt8 kSetDropCandyPositionCommand = 0xB5;
const UInt8 kSetDispenseMinPositionCommand = 0xB6;
const UInt8 kSetDispenseMaxPositionCommand = 0xB7;
const UInt8 kSetDispenseNumChoicesCommand = 0xB8;

const UInt8 kCandyWasLoadedCommand = 0xC0;
const UInt8 kCandyWasDroppedCommand = 0xC1;
const UInt8 kServosDidInitializeCommand = 0xC2;
const UInt8 kLoadPositionWasSetCommand = 0xC3;
const UInt8 kInspectPositionWasSetCommand = 0xC4;
const UInt8 kDropCandyPositionWasSetCommand = 0xC5;
const UInt8 kDispenseMinPositionWasSetCommand = 0xC6;
const UInt8 kDispenseMaxPositionWasSetCommand = 0xC7;
const UInt8 kDispenseNumChoicesWasSetCommand = 0xC8;



@interface VWWBLEController () <BLEDelegate>
@property (strong, nonatomic) BLE *ble;

@property (nonatomic, strong) VWWEmptyBlock connectSuccessBlock;
@property (nonatomic, strong) VWWEmptyBlock connectErrorBlock;
@property (nonatomic, strong) VWWEmptyBlock disconnectBlock;
@property (nonatomic, strong) VWWNumberBlock rssiBlock;

@property (nonatomic, strong) VWWEmptyBlock loadCandyCompletionBlock;
@property (nonatomic, strong) VWWEmptyBlock dropCandyCompletionBlock;
@property (nonatomic, strong) VWWEmptyBlock initServosCompletionBlock;

@property (nonatomic, strong) VWWEmptyBlock setLoadPositionCompletionBlock;
@property (nonatomic, strong) VWWEmptyBlock setInspectPositionCompletionBlock;
@property (nonatomic, strong) VWWEmptyBlock setDropPositionCompletionBlock;
@property (nonatomic, strong) VWWEmptyBlock setDispenseMinPositionCompletionBlock;
@property (nonatomic, strong) VWWEmptyBlock setDispenseMaxPositionCompletionBlock;
@property (nonatomic, strong) VWWEmptyBlock setDispenseNumChoicesCompletionBlock;


@property (nonatomic, strong) NSTimer *rssiTimer;
@property (nonatomic) NSInteger *loadPosition;
@property (nonatomic) NSInteger *inspectPosition;
@property (nonatomic) NSInteger *dropPosition;
@property (nonatomic) NSInteger *dispenseMinPosition;
@property (nonatomic) NSInteger *dispenseMaxPosition;
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


-(void)scanForPeripheralsWithCompletionBlock:(VWWEmptyBlock)completionBlock
                                  errorBlock:(VWWEmptyBlock)errorBlock{

    self.connectSuccessBlock = completionBlock;
    self.connectErrorBlock = errorBlock;
    
    if (self.ble.activePeripheral){
        if(self.ble.activePeripheral.state == CBPeripheralStateConnected){
            [[self.ble CM] cancelPeripheralConnection:[self.ble activePeripheral]];
            VWW_LOG_INFO(@"Found peripheral devices");
            return;
        }
    }
    if (self.ble.peripherals){
        self.ble.peripherals = nil;
    }
    
    VWW_LOG_INFO(@"Enable connect button here");
    [self.ble findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];

    VWW_LOG_INFO(@"Start animating...");
}

-(void)setBLEDidDisconnectBlock:(VWWEmptyBlock)disconnectBlock{
    self.disconnectBlock = disconnectBlock;
}

-(void)setRSSIDidUpdateBlock:(VWWNumberBlock)rssiBlock{
    self.rssiBlock = rssiBlock;
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

-(void)setLoadPosition:(UInt8)position completionBlock:(VWWEmptyBlock)completionBlock{
    self.setLoadPositionCompletionBlock = completionBlock;
    UInt8 buf[3] = {kSetLoadPositionCommand, 0x00, 0x00};
    buf[1] = position;
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self.ble write:data];

}
-(void)setInspectPosition:(UInt8)position completionBlock:(VWWEmptyBlock)completionBlock{
    self.setInspectPositionCompletionBlock = completionBlock;
    UInt8 buf[3] = {kSetInspectPositionCommand, 0x00, 0x00};
    buf[1] = position;
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self.ble write:data];
    
}
-(void)setDropPosition:(UInt8)position completionBlock:(VWWEmptyBlock)completionBlock{
    self.setDropPositionCompletionBlock = completionBlock;
    UInt8 buf[3] = {kSetDropCandyPositionCommand, 0x00, 0x00};
    buf[1] = position;
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self.ble write:data];
    
}
-(void)setDispenseMinPosition:(UInt8)position completionBlock:(VWWEmptyBlock)completionBlock{
    self.setDispenseMinPositionCompletionBlock = completionBlock;
    UInt8 buf[3] = {kSetDispenseMinPositionCommand, 0x00, 0x00};
    buf[1] = position;
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self.ble write:data];
    
}
-(void)setDispenseMaxPosition:(UInt8)position completionBlock:(VWWEmptyBlock)completionBlock{
    self.setDispenseMaxPositionCompletionBlock = completionBlock;
    UInt8 buf[3] = {kSetDispenseMaxPositionCommand, 0x00, 0x00};
    buf[1] = position;
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self.ble write:data];
    
}

-(void)setDispenseNumChoices:(UInt8)numChoices completionBlock:(VWWEmptyBlock)completionBlock{
    self.setDispenseNumChoicesCompletionBlock = completionBlock;
    UInt8 buf[3] = {kSetDispenseNumChoicesCommand, 0x00, 0x00};
    buf[1] = numChoices;
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self.ble write:data];
}

#pragma mark Private methods


-(void) readRSSITimer:(NSTimer *)timer{
    [self.ble readRSSI];
}


-(void)connectionTimer:(NSTimer *)timer{
    VWW_LOG_INFO(@"Enable connect button");
    VWW_LOG_INFO(@"Set button title to disconnect");
    
    if (self.ble.peripherals.count > 0){
        [self.ble connectPeripheral:[self.ble.peripherals objectAtIndex:0]];
    } else {
        VWW_LOG_INFO(@"Set button title to connect");
        VWW_LOG_INFO(@"Stop animating");
    }
}


#pragma mark BLEDelegate
-(void)bleDidConnect{
    VWW_LOG_TRACE;
    
    // Start reading RSSI
    self.rssiTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];

    if(self.connectSuccessBlock){
        self.connectSuccessBlock();
    }
    
}
-(void)bleDidDisconnect{
    VWW_LOG_TRACE;
    // Stop RSSI updates
    [self.rssiTimer invalidate];
    
    if(self.disconnectBlock){
        self.disconnectBlock();
        _disconnectBlock = nil;
    }

}
-(void)bleDidUpdateRSSI:(NSNumber *)rssi{
//    VWW_LOG_TRACE;
//    if(self.delegate){
//        [self.delegate bleController:self didUpdateRSSI:rssi];
//    }
    if(self.rssiBlock){
        self.rssiBlock(rssi);
    }
}
-(void)bleDidReceiveData:(unsigned char *)data length:(int)length{
    VWW_LOG_INFO(@"Length: %d", length);
    
    if(length != 3){
        VWW_LOG_WARNING(@"Expected data of length 3. Got %ld", (long)length);
    }
    
    // parse data, all commands are in 3-byte. See header of commands.
    for (int i = 0; i < length; i+=3){
//    NSUInteger i = 0;
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
        } else if(data[i] == kLoadPositionWasSetCommand){
            UInt8 position = data[i+1];
            VWW_LOG_INFO(@"Load postition was set: 0x%02X", position);
            if(self.setLoadPositionCompletionBlock){
                self.setLoadPositionCompletionBlock();
            }
        } else if(data[i] == kInspectPositionWasSetCommand){
            UInt8 position = data[i+1];
            VWW_LOG_INFO(@"Inspect position was set: 0x%02X", position);
            if(self.setInspectPositionCompletionBlock){
                self.setInspectPositionCompletionBlock();
            }
        } else if(data[i] == kDropCandyPositionWasSetCommand){
            UInt8 position = data[i+1];
            VWW_LOG_INFO(@"Drop position was set: 0x%02X", position);
            if(self.setDropPositionCompletionBlock){
                self.setDropPositionCompletionBlock();
            }
        } else if(data[i] == kDispenseMinPositionWasSetCommand){
            UInt8 position = data[i+1];
            VWW_LOG_INFO(@"Dispense min position was set: 0x%02X", position);
            if(self.setDispenseMinPositionCompletionBlock){
                self.setDispenseMinPositionCompletionBlock();
            }
        } else if(data[i] == kDispenseMaxPositionWasSetCommand){
            UInt8 position = data[i+1];
            VWW_LOG_INFO(@"Dispense max position was set: 0x%02X", position);
            if(self.setDispenseMaxPositionCompletionBlock){
                self.setDispenseMaxPositionCompletionBlock();
            }
        } else if(data[i] == kDispenseNumChoicesWasSetCommand){
            UInt8 numChoices = data[i+1];
            VWW_LOG_INFO(@"Dispense num choices was set: 0x%02X", numChoices);
            if(self.setDispenseNumChoicesCompletionBlock){
                self.setDispenseNumChoicesCompletionBlock();
            }
        } else {
            VWW_LOG_INFO(@"Received unknown command: 0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);
        }
    }
}




@end
