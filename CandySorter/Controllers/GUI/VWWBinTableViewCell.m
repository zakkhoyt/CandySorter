//
//  VWWBinTableViewCell.m
//  CandySorter
//
//  Created by Zakk Hoyt on 3/1/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWBinTableViewCell.h"


@interface VWWBinTableViewCell ()

@end

@implementation VWWBinTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)assignButtonTouchUpInside:(id)sender {
}
- (IBAction)editButtonTouchUpInside:(id)sender {
}


@end
