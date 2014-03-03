//
//  VWWDetailsTableViewController.h
//  CandySorter
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VWWDetailsTableViewController;

@protocol VWWDetailsTableViewControllerDelegate <NSObject>
@optional
-(void)detailsTableViewController:(VWWDetailsTableViewController*)sender;
@end

@interface VWWDetailsTableViewController : UITableViewController
@property (nonatomic, weak) id <VWWDetailsTableViewControllerDelegate> delegate;
@end
