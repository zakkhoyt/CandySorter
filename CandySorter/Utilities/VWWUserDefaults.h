//
//  VWWUserDefaults.h
//  CandySorter
//
//  Created by Zakk Hoyt on 3/3/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VWWUserDefaults : NSObject

+(void)setLoadPosition:(NSUInteger)position;
+(NSUInteger)loadPosition;

+(void)setInspectPosition:(NSUInteger)position;
+(NSUInteger)inspectPosition;

+(void)setDropPosition:(NSUInteger)position;
+(NSUInteger)dropPosition;

+(void)setDispenseMinPosition:(NSUInteger)position;
+(NSUInteger)dispenseMinPosition;

+(void)setDispenseMaxPosition:(NSUInteger)position;
+(NSUInteger)dispenseMaxPosition;

+(void)setDispenseNumChoices:(NSUInteger)numChoices;
+(NSUInteger)dispenseNumChoices;

@end
