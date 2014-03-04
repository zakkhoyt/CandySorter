//
//  VWWCommandsTableViewController.h
//  CandySorter
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VWWCommandsTableViewController;

@protocol VWWCommandsTableViewControllerDelegate <NSObject>

-(void)commandsTableViewControllerStartButtonTouchUpInside:(VWWCommandsTableViewController*)sender;
-(void)commandsTableViewControllerStopButtonTouchUpInside:(VWWCommandsTableViewController*)sender;
-(void)commandsTableViewControllerLoadButtonTouchUpInside:(VWWCommandsTableViewController*)sender;
-(void)commandsTableViewControllerDropButtonTouchUpInside:(VWWCommandsTableViewController*)sender;
-(void)commandsTableViewControllerInitButtonTouchUpInside:(VWWCommandsTableViewController*)sender;
-(void)commandsTableViewControllerTrimsButtonTouchUpInside:(VWWCommandsTableViewController*)sender;
-(void)commandsTableViewController:(VWWCommandsTableViewController*)sender autoPickSwitchValueChanged:(BOOL)on;
@end

@interface VWWCommandsTableViewController : UITableViewController
@property (nonatomic, weak) id <VWWCommandsTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *rssi;
@end
