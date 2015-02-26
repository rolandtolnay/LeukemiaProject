//
//  RTBloodSampleCollectionViewCell.m
//  Leukemia App
//
//  Created by dmu-23 on 06/02/15.
//  Copyright (c) 2015 dmu-23. All rights reserved.
//

#import "RTBloodSampleCollectionViewCell.h"

@implementation RTBloodSampleCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.restorationIdentifier = @"Cell";
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingNone;
        const CGFloat borderWidth = 2.0f;
        UIView *bgView = [[UIView alloc] initWithFrame:frame];
        bgView.layer.borderColor = [UIColor blackColor].CGColor;
        bgView.layer.borderWidth = borderWidth;
        bgView.layer.cornerRadius = 6.0f;
        self.selectedBackgroundView = bgView;
    }
    return self;
}

@end
