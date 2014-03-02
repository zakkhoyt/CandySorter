//
//  VWWCrosshairView.m
//  ColorBlind2
//
//  Created by Zakk Hoyt on 12/1/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWCrosshairView.h"

@implementation VWWCrosshairView{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Don't draw a crosshair if the user hasn't touched yet.
    if(_selectedPixel.x == 0 && _selectedPixel.y == 0){
        return;
    }
    
    const int kCrosshairLength = 50;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGFloat color[4] = {1, 1, 1, 1};        // r,g,b,a
    CGContextSetStrokeColor(c, color);
    CGContextBeginPath(c);
    
    CGFloat startX = _selectedPixel.x - (kCrosshairLength/2);
    if(startX < 0) startX = 0;
    
    CGFloat finishX = _selectedPixel.x + (kCrosshairLength/2);
    if(finishX > self.bounds.size.width) finishX = self.bounds.size.width;
    
    CGFloat startY = _selectedPixel.y - (kCrosshairLength/2);
    if(startY < 0) startY = 0;
    
    CGFloat finishY = _selectedPixel.y + (kCrosshairLength/2);
    if(finishY > self.bounds.size.height) finishY = self.bounds.size.height;
    
    //    NSLog(@"startX=%f x=%f finishX=%f startY=%f y=%f finishY=%f",
    //          startX,
    //          _selectedPixel.x,
    //          finishX,
    //          startY,
    //          _selectedPixel.y,
    //          finishY);
    
    // draw horiontal hair
    CGContextMoveToPoint(c,
                         startX,
                         _selectedPixel.y);
    
    CGContextAddLineToPoint(c,
                            finishX,
                            _selectedPixel.y);
    
    // draw vertical hair
    CGContextMoveToPoint(c,
                         _selectedPixel.x,
                         startY);
    CGContextAddLineToPoint(c,
                            _selectedPixel.x,
                            finishY);
    
    CGContextStrokePath(c);
}





#pragma mark UIView touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    if(touch.tapCount == 2){
////        [self.delegate vww_ColorPickerImageViewUserDoubleTapped:self];
//    }
//    else if(touch.tapCount == 1){
////        [self touchEvent:touches withEvent:event];
//    }
    [self touchEvent:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchEvent:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchEvent:touches withEvent:event];
}

#pragma mark Custom methods

- (void)touchEvent:(NSSet *)touches withEvent:(UIEvent *)event{
    [self setNeedsDisplay];
    UITouch *touch = [[event allTouches] anyObject];
    _selectedPixel = [touch locationInView:self];
    CGPoint point = [touch locationInView:self];
    [self.delegate crosshairViewTouchOccurredAtPoint:point];
}




@end
