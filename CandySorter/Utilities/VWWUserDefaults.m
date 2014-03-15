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

+(void)setLoadPosition:(NSUInteger)position{
    [[NSUserDefaults standardUserDefaults] setObject:@(position) forKey:VWWUserDefaultsLoadPositionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSUInteger)loadPosition{
    NSNumber *position = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsLoadPositionKey];
    return position == nil ? 160 : position.unsignedIntegerValue;
}


+(void)setInspectPosition:(NSUInteger)position{
    [[NSUserDefaults standardUserDefaults] setObject:@(position) forKey:VWWUserDefaultsInspectPositionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSUInteger)inspectPosition{
    NSNumber *position = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsInspectPositionKey];
    return position == nil ? 90 : position.unsignedIntegerValue;
}

+(void)setDropPosition:(NSUInteger)position{
    [[NSUserDefaults standardUserDefaults] setObject:@(position) forKey:VWWUserDefaultsDropPositionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSUInteger)dropPosition{
    NSNumber *position = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsDropPositionKey];
    return position == nil ? 20 : position.unsignedIntegerValue;
}

+(void)setDispenseMinPosition:(NSUInteger)position{
    [[NSUserDefaults standardUserDefaults] setObject:@(position) forKey:VWWUserDefaultsDispenseMinPositionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSUInteger)dispenseMinPosition{
    NSNumber *position = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsDispenseMinPositionKey];
    return position == nil ? 20 : position.unsignedIntegerValue;
}

+(void)setDispenseMaxPosition:(NSUInteger)position{
    [[NSUserDefaults standardUserDefaults] setObject:@(position) forKey:VWWUserDefaultsDispenseMaxPositionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSUInteger)dispenseMaxPosition{
    NSNumber *position = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsDispenseMaxPositionKey];
    return position == nil ? 160 : position.unsignedIntegerValue;
}

+(void)setDispenseNumChoices:(NSUInteger)numChoices{
    [[NSUserDefaults standardUserDefaults] setObject:@(numChoices) forKey:VWWUserDefaultsDispenseNumChoicesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSUInteger)dispenseNumChoices{
    NSNumber *position = [[NSUserDefaults standardUserDefaults] objectForKey:VWWUserDefaultsDispenseNumChoicesKey];
    return position == nil ? 12 : position.unsignedIntegerValue;
}

@end
