//
//  VWWBinTableViewCell.m
//  CandySorter
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWBinTableViewCell.h"


@interface VWWBinTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation VWWBinTableViewCell

-(void)setLabelText:(NSString *)labelText{
    _labelText = labelText;
    self.titleLabel.text = _labelText;
}


@end
