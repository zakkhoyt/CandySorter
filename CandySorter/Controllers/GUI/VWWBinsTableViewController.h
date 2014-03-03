//
//  VWWBinsTableViewController.h
//  CandySorter
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VWWBinsTableViewController;

@protocol VWWBinsTableViewControllerDelegate <NSObject>
-(void)binsTableViewController:(VWWBinsTableViewController*)sender didSelectRowAtIndex:(NSInteger)index;
@end

@interface VWWBinsTableViewController : UITableViewController
@property (nonatomic, weak) id <VWWBinsTableViewControllerDelegate> delegate;
@end
