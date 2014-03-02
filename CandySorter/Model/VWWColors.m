//
//  VWWColors.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/23/12.
//
//

#import "VWWColors.h"
#import "VWWColor.h"

@interface VWWColors ()
@property (nonatomic, strong, readwrite) NSMutableDictionary *colorsDictionary;
@property (nonatomic, strong, readwrite) NSMutableOrderedSet *colorsKeys;
@property (nonatomic, readwrite) NSString *currentColorKey;
@end

@implementation VWWColors

#pragma mark - Public methods

+(VWWColors*)sharedInstance{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = self.new;
    });
    return instance;
}


-(BOOL)openColorsFileWithPath:(NSString*)path{
//    [self.colorsDictionary removeAllObjects];
//    [self.colorsKeys removeAllObjects];
//    
//    _colorsDictionary = [[VWWFileReader colorsFromFile:path]mutableCopy];
//    if(self.colorsDictionary == nil || self.colorsDictionary.count == 0){
//        VWW_LOG_WARNING(@"Failed to load any colors from %@", path);
//        return NO;
//    }
//    
//    // We have a dictionary, now let's generate and sort the keys
//    NSMutableArray *unsortedColorsKeys = [[NSMutableArray alloc]initWithCapacity:self.colorsDictionary.allValues.count];
//    for(VWWColor *color in self.colorsDictionary.allValues){
//        [unsortedColorsKeys addObject:color.name];
//    }
//    self.colorsKeys = [NSMutableOrderedSet orderedSetWithArray:[self sortColors:unsortedColorsKeys]];
//    
//    // Set current key
//    if(self.colorsKeys.count){
//        self.currentColorKey = self.colorsKeys[0];
//    }
    return YES;
}


// Logs all colors to the console
-(void)printColors{
    
    NSLog(@"********************** Begin printing all colors *************************");
    for(NSInteger index = 0; index < self.colorsKeys.count; index++){
        NSString *key = self.colorsKeys[index];
        VWWColor *color = self.colorsDictionary[key];
        NSLog(@"Color: %@", color.description);
    }
    NSLog(@"********************** End printing all colors *************************");
}
-(void)printKeys{
    
    NSLog(@"********************** Begin printing all keys *************************");
    for(NSString *key in self.colorsKeys){
        NSLog(@"Key: %@", key);
    }
    NSLog(@"********************** End printing all keys *************************");
}


-(VWWColor*)colorAtIndex:(NSUInteger)index{
    if(index < self.colorsKeys.count){
        NSString *key = self.colorsKeys[index];
        VWWColor *color = self.colorsDictionary[key];
        return color;
    } else {
        VWW_LOG_WARNING(@"Requesting index that is greater than bounds: %lu/%lu", (unsigned long)index, (unsigned long)self.colorsDictionary.count);
        return nil;
    }
}

-(VWWColor*)closestColorFromRed:(float)red green:(float)green blue:(float)blue{
    if(!self.colorsDictionary){
        VWW_LOG_WARNING(@"No colors are loaded")
        return nil;
    }
    
    
    NSUInteger closestIndex = 0;
    float smallestDifference = 4.0; // 1.0 + 1.0 + 1.0 + 1.0 is the largest possible difference (RGBA)
    
    
    for(NSUInteger index = 0; index < self.colorsKeys.count; index++){
        NSString *key = self.colorsKeys[index];
        VWWColor* color = self.colorsDictionary[key];
        float diffRed = fabs(color.red - red);
        float diffGreen = fabs(color.green - green);
        float diffBlue = fabs(color.blue - blue);
        if(diffRed + diffGreen + diffBlue < smallestDifference){
            smallestDifference = diffRed + diffGreen + diffBlue;
            closestIndex = index;
        } else {
//            int i = 0;
        }
    }
    
    NSString *key = self.colorsKeys[closestIndex];
    return self.colorsDictionary[key];
}
-(VWWColor*)closestColorFromUIColor:(UIColor*)uiColor{
    double r = 0, g = 0, b = 0, a = 0;
    [uiColor getRed:&r green:&g blue:&b alpha:&a];
    return [self closestColorFromRed:r green:g blue:b];
}

-(VWWColor*)complimentColor{
//    // TODO: implement
//    return self.currentColor;
    VWW_LOG_TODO_TASK(@"Implement");
    return nil;
}



-(VWWColor*)randomColor{
    if(!self.colorsDictionary){
        VWW_LOG_WARNING(@"No colors are loaded")
        return nil;
    }

    const NSUInteger kMax = 100000;
    float r = (arc4random() % kMax) / (float)kMax;
    float g = (arc4random() % kMax) / (float)kMax;
    float b = (arc4random() % kMax) / (float)kMax;
//    float a = (arc4random() % kMax) / (float)kMax;
    return [self closestColorFromRed:r green:g blue:b];
}



// Loop through our array of VWWColor objects and do a case insensitive compare on the name property
// Also dispatch a Notification Center event
-(BOOL)setCurrentColor:(VWWColor*)color{
    if(!self.colorsDictionary){
        VWW_LOG_WARNING(@"No colors are loaded")
        return NO;
    }

    if([self.colorsKeys containsObject:color.name] == NO){
        VWW_LOG_WARNING(@"Could not find color %@ in set of keys", color.name);
        return NO;
    }
    
    self.currentColorKey = color.name;
    return YES;

}

// Loop through our array of VWWColor objects and compare normalized RGB properties
// Also dispatch a Notification Center event
-(BOOL)setCurrentColorFromUIColor:(UIColor*)color{
    if(!self.colorsDictionary){
        VWW_LOG_WARNING(@"No colors are loaded")
        return NO;
    }

    CGFloat r = 0, g = 0, b = 0, a = 0;
    [color getRed:&r green:&g blue:&b alpha:&a];
    VWWColor *currentColor = [self closestColorFromRed:r green:g blue:b];
    if(currentColor == nil){
        VWW_LOG_WARNING(@"Could not find a match for color");
        return NO;
    }
    
    self.currentColorKey = currentColor.name;
    return YES;
}

#pragma mark - Private methods



-(NSArray*)sortColors:(NSArray*)buddies{
    // Lex sort
    NSArray *sortedColors = [buddies sortedArrayUsingComparator:^NSComparisonResult(NSString *name1, NSString* name2) {
        return [name1 compare:name2 options:NSCaseInsensitiveSearch];
    }];
    return sortedColors;
}


@end
