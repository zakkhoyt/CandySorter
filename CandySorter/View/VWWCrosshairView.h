//
//  VWWCrosshairView.h
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>



@class VWWCrosshairView;

@protocol VWWCrosshairViewDelegate <NSObject>
-(void)crosshairViewTouchOccurredAtPoint:(CGPoint)point;
@end

@interface VWWCrosshairView : UIView
@property (nonatomic, weak) id <VWWCrosshairViewDelegate> delegate;
@property (nonatomic) CGPoint selectedPixel;
@end
