//
//  VWWBLEController.h
//  CandySorter
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//
// BLE libraries available here: http://redbearlab.com/rbl_library


// The interface between iOS and arduino will use this class which uses BLE.

// App Start and init
//    * App Starts
//    * User taps connect button on default screen
//    * Connection succeeds and tells default screen
//    * Default screen navigates to scanner screen, where the live camera feed starts

// Now we are connected to the hardware and ready to start (Debug mode)
//    * Tap load candy button. Command is sent to Arudino.
//    * Arduio moves servo to load candy position, then inspect candy position then sends reply
//    * Pixels are read and analyzed. A suggestion is highlighted in the tableview
//    * Tap index in table if autoselect is not enabled
//    * Arudino drops candy in the corresponding bin and sends reply
//    * Loop

// Now we are connected to the hardware and ready to start (Prod mode)
//    * Tap start button.
//    * The load candy command is sent to the Arudino.
//    * Arudino loads candy and sends reply
//    * Pixels are read and analyzed. A bin is selected by the scanner by the candy's color.
//    * The drop candy command is sent to the Arudino.
//    * Arudino drops candy in the corresponding bin and sends reply
//    * Loop
//    * Press the stop button




#import <Foundation/Foundation.h>


@class VWWBLEController;

@interface VWWBLEController : NSObject
+(VWWBLEController*)sharedInstance;

// These blocks are used to setup callbacks that are fired "now".
-(void)scanForPeripheralsWithCompletionBlock:(VWWEmptyBlock)completionBlock errorBlock:(VWWEmptyBlock)errorBlock;
-(void)initializeServosWithCompletionBlock:(VWWEmptyBlock)completionBlock;
-(void)loadCandyWithCompletionBlock:(VWWEmptyBlock)completionBlock;
-(void)dropCandyInBin:(UInt8)bin completionBlock:(VWWEmptyBlock)completionBlock;
-(void)setLoadPosition:(UInt8)position completionBlock:(VWWEmptyBlock)completionBlock;
-(void)setInspectPosition:(UInt8)position completionBlock:(VWWEmptyBlock)completionBlock;
-(void)setDropPosition:(UInt8)position completionBlock:(VWWEmptyBlock)completionBlock;
-(void)setDispenseMinPosition:(UInt8)position completionBlock:(VWWEmptyBlock)completionBlock;
-(void)setDispenseMaxPosition:(UInt8)position completionBlock:(VWWEmptyBlock)completionBlock;
-(void)setDispenseNumChoices:(UInt8)numChoices completionBlock:(VWWEmptyBlock)completionBlock;


// These blocks are used to setup callbacks that are fired "later on". Things like RSSI updates or a disconnect
-(void)setBLEDidDisconnectBlock:(VWWEmptyBlock)disconnectBlock;
-(void)setRSSIDidUpdateBlock:(VWWNumberBlock)rssiBlock;

@end


































