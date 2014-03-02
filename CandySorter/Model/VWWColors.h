//
//  VWWColors.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/23/12.
//
//

#import <Foundation/Foundation.h>

@class VWWColor;

@interface VWWColors : NSObject

@property (nonatomic, strong, readonly) NSMutableDictionary *colorsDictionary;
@property (nonatomic, strong, readonly) NSMutableOrderedSet *colorsKeys;

// Represents the current color used by GUI. NSNotifications are broadcast when this changes
@property (nonatomic, readonly) NSString *currentColorKey;

+(VWWColors*)sharedInstance;

-(BOOL)openColorsFileWithPath:(NSString*)path;
    
// Logs all colors to the console
-(void)printColors;
-(void)printKeys;

// Returns color from index
-(VWWColor*)colorAtIndex:(NSUInteger)index;

// Returns a VWWColor in self.colors that most closely matches red green blue
// Runtime O(x). 
-(VWWColor*)closestColorFromRed:(float)red green:(float)green blue:(float)blue;
-(VWWColor*)closestColorFromUIColor:(UIColor*)uiColor;
// Returns the closest opposite of currentColor. Math is done on r, g, b
-(VWWColor*)complimentColor;

// Returns a random VWWColor from our NSMutableArray colors
-(VWWColor*)randomColor;

// Sets the currentColor by color.name. Returns NO if no match is found.
-(BOOL)setCurrentColor:(VWWColor*)color;

// Sets the currentColor by finding the closest match from RGBA
-(BOOL)setCurrentColorFromUIColor:(UIColor*)color;



@end
