//
//  RTFirstViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 15/08/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "RTPainDrawViewController.h"

@interface RTPainDrawViewController ()

@end

@implementation RTPainDrawViewController

- (void)viewDidLoad
{
    self.red = 255.0/255.0;
    self.green = 0.0/255.0;
    self.blue = 0.0/255.0;
    self.brush = 15.0;
    self.opacity = 0.6;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//Controls drawing part

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.mouseWiped = NO;
    UITouch *touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self.drawingView];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    self.mouseWiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.drawingView];
    
    UIGraphicsBeginImageContext(self.drawingView.frame.size);
    [self.drawImage.image drawInRect:CGRectMake(0, 0, self.drawingView.frame.size.width, self.drawingView.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.drawImage setAlpha:self.opacity];
    UIGraphicsEndImageContext();
    self.lastPoint = currentPoint;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.mouseWiped){
        UIGraphicsBeginImageContext(self.drawingView.frame.size);
        [self.drawImage.image drawInRect:CGRectMake(0, 0, self.drawingView.frame.size.width, self.drawingView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, self.opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.drawingView.frame.size.width, self.drawingView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    [self.drawImage.image drawInRect:CGRectMake(0, 0, self.drawingView.frame.size.width, self.drawingView.frame.size.height) blendMode:kCGBlendModeNormal alpha:self.opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.drawImage.image = nil;
    UIGraphicsEndImageContext();
}

- (IBAction)colorPressed:(id)sender {
    UIButton *pressedButton = (UIButton*)sender;
    switch (pressedButton.tag) {
        case 0:
            self.red = 255.0/255.0;
            self.green = 0.0/255.0;
            self.blue = 0.0/255.0;
            break;
        case 1:
            self.red = 255.0/255.0;
            self.green = 255.0/255.0;
            self.blue = 0.0/255.0;
            break;
        case 2:
            self.red = 102.0/255.0;
            self.green = 255.0/255.0;
            self.blue = 0.0/255.0;
            break;
    }
}

- (IBAction)resetDrawing:(id)sender {
    UIImage *painBodyImage = [UIImage imageNamed:@"painBody.png"];
    self.red = 255.0/255.0;
    self.green = 0.0/255.0;
    self.blue = 0.0/255.0;
    self.mainImage.image = painBodyImage;
    self.drawImage.image = painBodyImage;
    self.brush = 15.0;
    self.opacity = 0.6;
}
@end
