//
//  RTBloodSampleTableViewCell.m
//  Leukemia App
//
//  Created by dmu-23 on 14/10/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTBloodSampleTableViewCell.h"

@implementation RTBloodSampleTableViewCell

- (void)awakeFromNib {
    self.txfBloodSample.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.txfBloodSample isFirstResponder] && [touch view] != self.txfBloodSample) {
        [self.txfBloodSample resignFirstResponder];
    }
}


@end
