//
//  VWWColor.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//

#import "VWWColor.h"


@interface VWWColor ()
@end

@implementation VWWColor


#pragma mark - Public methods

-(id)initWithName:(NSString*)name
              hex:(NSString*)hex
              red:(NSUInteger)red
            green:(NSUInteger)green
             blue:(NSUInteger)blue
              hue:(NSNumber*)hue{
    
    self = [super init];
    if(self){
        // Colors in source file are listed with values from 0 - 100. We want to use 0.0-1.0
        _name = name;
        _hex = hex;
        _red = red / (float)100;
        _green = green / (float)100;
        _blue = blue / (float)100;
        _hue = hue;
        _uiColor = [UIColor colorWithRed:_red green:_green blue:_blue alpha:1.0];
    }
    return self;
}


-(NSString*)description{
    NSString* colorDescription = [NSString stringWithFormat:@"name:%@\t"
                                  "hex:#%@\t"
                                  "red:%.4f\t"
                                  "green:%.4f\t"
                                  "blue:%.4f",
                                  self.name,
                                  self.hex,
                                  self.red,
                                  self.green,
                                  self.blue];
    return  colorDescription;
    
}

-(NSString*)prettyDescription{
    NSString* colorDescription = [NSString stringWithFormat:@"Name:%@\n"
                                  "Hex:#%@\n"
                                  "Red:%.4f\n"
                                  "Green:%.4f\n"
                                  "Blue:%.4f",
                                  self.name,
                                  self.hex,
                                  self.red,
                                  self.green,
                                  self.blue];
    return  colorDescription;
    
}

-(NSString*)hexValue{
    NSString *redString = [NSString stringWithFormat:@"%02lx", (unsigned long)[self hexFromFloat:self.red]];
    NSString *greenString = [NSString stringWithFormat:@"%02lx", (unsigned long)[self hexFromFloat:self.green]];
    NSString *blueString = [NSString stringWithFormat:@"%02lx", (unsigned long)[self hexFromFloat:self.blue]];
    NSString *hexString = [NSString stringWithFormat:@"0x%@%@%@", redString, greenString, blueString];
    return [hexString uppercaseString];
}

-(NSUInteger)hexFromFloat:(float)f{
    return f / 1.0 * 255;
}

@end
