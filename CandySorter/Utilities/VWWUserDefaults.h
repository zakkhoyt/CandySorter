//
//  VWWUserDefaults.h
//  CandySorter
//
//  Created by Zakk Hoyt on 3/3/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VWWUserDefaults : NSObject

+(void)setLoadPosition:(NSNumber*)position;
+(NSNumber*)loadPosition;

+(void)setInspectPosition:(NSNumber*)position;
+(NSNumber*)inspectPosition;

+(void)setDropPosition:(NSNumber*)position;
+(NSNumber*)dropPosition;

+(void)setDispenseMinPosition:(NSNumber*)position;
+(NSNumber*)dispenseMinPosition;

+(void)setDispenseMaxPosition:(NSNumber*)position;
+(NSNumber*)dispenseMaxPosition;

+(void)setDispenseNumChoices:(NSNumber*)numChoices;
+(NSNumber*)dispenseNumChoices;

@end
