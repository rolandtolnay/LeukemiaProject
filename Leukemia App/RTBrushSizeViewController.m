//
//  RTSettingsViewController.m
//  Leukemia App
//
//  Created by DMU-24 on 19/08/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import "RTBrushSizeViewController.h"

@interface RTBrushSizeViewController ()

@end

@implementation RTBrushSizeViewController

- (void)viewDidLoad
{
    
    
    self.brushSlider.value = [self.brush floatValue];
    self.brushLabel.text = [NSString stringWithFormat:@"%0.1f",[self.brush floatValue]];
    
    UIGraphicsBeginImageContext(self.brushView.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), [self.brush floatValue]);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [super viewDidLoad];
}

- (IBAction)sliderChanged:(id)sender {
            self.brush = [[NSNumber alloc ]initWithFloat:self.brushSlider.value];
        self.brushLabel.text = [NSString stringWithFormat:@"%0.1f",[self.brush floatValue]];
        
        UIGraphicsBeginImageContext(self.brushView.frame.size);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), [self.brush floatValue]);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.brushView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
}
@end
