//
//  VWWBLEController.h
//  CandySorter
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>


@class VWWBLEController;

@protocol VWWBLEControllerDelegate <NSObject>

-(void)bleControllerDidConnect:(VWWBLEController*)sender;
-(void)bleControllerDidDisconnect:(VWWBLEController*)sender;
@end


@interface VWWBLEController : NSObject
+(VWWBLEController*)sharedInstance;

-(void)scanForPeripherals;
@property (nonatomic, weak) id <VWWBLEControllerDelegate> delegate;
@end
