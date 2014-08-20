//
//  RTSettingsViewController.m
//  Leukemia App
//
//  Created by DMU-24 on 19/08/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import "RTSettingsViewController.h"

@interface RTSettingsViewController ()

@end

@implementation RTSettingsViewController

-(NSNumber *)brush{
    if(!_brush){
        _brush = [[NSNumber alloc]init];
    }
    return _brush;
}

-(NSNumber *)opacity{
    if(!_opacity){
        _opacity = [[NSNumber alloc]init];
    }
    return _opacity;
}

- (void)viewDidLoad
{
    self.brushSlider.value = [self.brush floatValue];
    self.brushLabel.text = [NSString stringWithFormat:@"%0.1f",[self.brush floatValue]];
    
    self.opacitySlider.value = [self.opacity floatValue];
    self.opacityLabel.text = [NSString stringWithFormat:@"%0.1f", [self.opacity floatValue]];
    
    UIGraphicsBeginImageContext(self.brushView.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), [self.brush floatValue]);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(self.opacityView.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 20);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, [self.opacity floatValue]);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.opacityView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sliderChanged:(id)sender {
    UISlider *changedSlider = (UISlider*)sender;
    if(changedSlider == self.brushSlider) {
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
    else if (changedSlider == self.opacitySlider){
        self.opacity = [[NSNumber alloc ]initWithFloat:self.opacitySlider.value];
        self.opacityLabel.text = [NSString stringWithFormat:@"%0.1f",[self.opacity floatValue]];
        
        UIGraphicsBeginImageContext(self.opacityView.frame.size);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 20);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, [self.opacity floatValue]);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.opacityView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}
@end
