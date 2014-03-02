//
//  VWWColor.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//

#import <Foundation/Foundation.h>



typedef enum {
    VWWColorCandyTypeUnknown = 0,
    VWWColorCandyTypeSkittles = 1,
    VWWColorCandyTypeSkittlesDark = 2,
    VWWColorCandyTypeMMs = 3,
} VWWColorCandyType;

@interface VWWColor : NSObject

@property (nonatomic, retain) NSString* name; 
@property (nonatomic, retain) NSString* hex; 
@property (nonatomic) float red;
@property (nonatomic) float green;
@property (nonatomic) float blue;
@property (nonatomic, retain) NSNumber* hue;
@property (nonatomic, retain) UIColor*  uiColor;
@property (nonatomic) VWWColorCandyType candyType;


-(id)initWithName:(NSString*)name 
              hex:(NSString*)hex
              red:(NSUInteger)red
            green:(NSUInteger)green
             blue:(NSUInteger)blue
              hue:(NSNumber*)hue
        candyType:(VWWColorCandyType)candyType;

-(NSString*)description;
-(NSString*)prettyDescription;
-(NSString*)hexValue;
-(NSUInteger)hexFromFloat:(float)f;

@end
