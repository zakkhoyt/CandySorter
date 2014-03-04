//
//  VWWUserDefaults.m
//  CandySorter
//
//  Created by Zakk Hoyt on 3/3/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWUserDefaults.h"
static NSString *VWWUserDefaultsLoadPositionKey = @"loadPosition";
static NSString *VWWUserDefaultsInspectPositionKey = @"inspectPosition";
static NSString *VWWUserDefaultsDropPositionKey = @"dropPosition";
static NSString *VWWUserDefaultsDispenseMinPositionKey = @"dispenseMinPosition";
static NSString *VWWUserDefaultsDispenseMaxPositionKey = @"dispenseMaxPosition";
static NSString *VWWUserDefaultsDispenseNumChoicesKey = @"dispenseNumChoices";

@implementation VWWUserDefaults

+(void)setLoadPosition:(NSNumber*)position{
    [[NSUserDefaults standardUserDefaults] setObject:position forKey:VWWUserDefaultsLoadPositionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSNumber*)loadPosition{
    NSNumber *position = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsLoadPositionKey];
    return position == nil ? @(160) : position;
}


+(void)setInspectPosition:(NSNumber*)position{
    [[NSUserDefaults standardUserDefaults] setObject:position forKey:VWWUserDefaultsInspectPositionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSNumber*)inspectPosition{
    NSNumber *position = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsInspectPositionKey];
    return position == nil ? @(90) : position;
}

+(void)setDropPosition:(NSNumber*)position{
    [[NSUserDefaults standardUserDefaults] setObject:position forKey:VWWUserDefaultsDropPositionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSNumber*)dropPosition{
    NSNumber *position = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsDropPositionKey];
    return position == nil ? @(20) : position;
}

+(void)setDispenseMinPosition:(NSNumber*)position{
    [[NSUserDefaults standardUserDefaults] setObject:position forKey:VWWUserDefaultsDispenseMinPositionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSNumber*)dispenseMinPosition{
    NSNumber *position = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsDispenseMinPositionKey];
    return position == nil ? @(20) : position;
}

+(void)setDispenseMaxPosition:(NSNumber*)position{
    [[NSUserDefaults standardUserDefaults] setObject:position forKey:VWWUserDefaultsDispenseMaxPositionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSNumber*)dispenseMaxPosition{
    NSNumber *position = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsDispenseMaxPositionKey];
    return position == nil ? @(160) : position;
}

+(void)setDispenseNumChoices:(NSNumber*)numChoices{
    [[NSUserDefaults standardUserDefaults] setObject:numChoices forKey:VWWUserDefaultsDispenseNumChoicesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSNumber*)dispenseNumChoices{
    NSNumber *position = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsDispenseNumChoicesKey];
    return position == nil ? @(12) : position;
}

@end
