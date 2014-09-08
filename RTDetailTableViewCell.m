//
//  RTDetailTableViewCell.m
//  Leukemia App
//
//  Created by DMU-24 on 28/08/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import "RTDetailTableViewCell.h"

@implementation RTDetailTableViewCell

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

@end
