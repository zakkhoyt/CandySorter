//
//  VWWTrimsTableViewController.h
//  CandySorter
//
//  Created by Zakk Hoyt on 3/3/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VWWTrimsTableViewController;

@protocol VWWTrimsTableViewControllerDelegate <NSObject>
-(void)trimsTableViewControllerLoadPositionChanged:(VWWTrimsTableViewController*)sender;
-(void)trimsTableViewControllerInspectPositionChanged:(VWWTrimsTableViewController*)sender;
-(void)trimsTableViewControllerDropPositionChanged:(VWWTrimsTableViewController*)sender;
-(void)trimsTableViewControllerDispenseMinPositionChanged:(VWWTrimsTableViewController*)sender;
-(void)trimsTableViewControllerDispenseMaxPositionChanged:(VWWTrimsTableViewController*)sender;
-(void)trimsTableViewControllerNumBinsChanged:(VWWTrimsTableViewController*)sender;
@end

@interface VWWTrimsTableViewController : UITableViewController
@property (nonatomic, strong) id <VWWTrimsTableViewControllerDelegate> delegate;
@end
