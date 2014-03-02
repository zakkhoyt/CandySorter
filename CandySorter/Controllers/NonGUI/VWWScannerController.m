//
//  VWWScannerController.m
//  CandySorter
//
//  Created by Zakk Hoyt on 3/2/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWScannerController.h"

@implementation VWWScannerController

+(VWWScannerController*)sharedInstance{
    static VWWScannerController *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc]init];
    });
    return instance;
}


-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

//-(void)setCurrentColor:(VWWColor*)color{
//    
//}




@end
