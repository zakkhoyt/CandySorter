//
//  VWWBlocks.h
//  CandySorter
//
//  Created by Zakk Hoyt on 3/2/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#ifndef CandySorter_VWWBlocks_h
#define CandySorter_VWWBlocks_h

typedef void (^VWWBOOLBlock)(BOOL success);
typedef void (^VWWEmptyBlock)(void);
typedef void (^VWWIntegerBlock)(NSInteger value);
typedef void (^VWWNumberBlock)(NSNumber* number);
#endif
