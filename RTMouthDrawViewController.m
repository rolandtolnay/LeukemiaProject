//
//  RTMouthDrawViewController.m
//  Leukemia App
//
//  Created by DMU-24 on 09/02/15.
//  Copyright (c) 2015 DMU-24. All rights reserved.
//

#import "RTMouthDrawViewController.h"

@interface RTMouthDrawViewController ()

@property UIPopoverController *popover;

@end

@implementation RTMouthDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.red = 255.0/255.0;
    self.green = 0.0/255.0;
    self.blue = 0.0/255.0;
    self.brush = 15.0;
    self.opacity = 0.0;
    
    [self.greenBtn setImage:[UIImage imageNamed:@"btngreen.png"] forState:UIControlStateNormal];
    [self.greenBtn setImage:[UIImage imageNamed:@"btnGreenHighligted.png"] forState:UIControlStateSelected];
    [self.greenBtn setImage:[UIImage imageNamed:@"btnGreenHighligted.png"] forState:UIControlStateHighlighted];
    
    [self.yelBtn setImage:[UIImage imageNamed:@"btnyellow.png"] forState:UIControlStateNormal];
    [self.yelBtn setImage:[UIImage imageNamed:@"btnYellowHighlighted.png"] forState:UIControlStateSelected];
    [self.yelBtn setImage:[UIImage imageNamed:@"btnYellowHighlighted.png"] forState:UIControlStateHighlighted];
    
    [self.redBtn setImage:[UIImage imageNamed:@"redbtn.png"] forState:UIControlStateNormal];
    [self.redBtn setImage:[UIImage imageNamed:@"btnRedHighlighted.png"] forState:UIControlStateSelected];
    [self.redBtn setImage:[UIImage imageNamed:@"btnRedHighlighted.png"] forState:UIControlStateHighlighted];
}


#pragma mark - Drawing controls

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.mouseWiped = NO;
    UITouch *touch = [touches anyObject];
    if([[touch view]isEqual:self.mouthDrawView]){
        self.lastPoint = [touch locationInView:self.mouthDrawView];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    self.mouseWiped = YES;
    UITouch *touch = [touches anyObject];
    if([[touch view]isEqual:self.mouthDrawView]){
        CGPoint currentPoint = [touch locationInView:self.mouthDrawView];
        UIGraphicsBeginImageContext(self.mouthDrawView.bounds.size);
        [self.drawImage.image drawInRect:CGRectMake(0, 0, self.mouthDrawView.bounds.size.width, self.mouthDrawView.bounds.size.height)];
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
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.mouseWiped){
        UIGraphicsBeginImageContext(self.mouthDrawView.frame.size);
        [self.drawImage.image drawInRect:CGRectMake(0, 0, self.mouthDrawView.bounds.size.width, self.mouthDrawView.bounds.size.height)];
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
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mouthDrawView.bounds.size.width, self.mouthDrawView.bounds.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.drawImage.image drawInRect:CGRectMake(0, 0, self.mouthDrawView.bounds.size.width, self.mouthDrawView.bounds.size.height) blendMode:kCGBlendModeNormal alpha:self.opacity];
    self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.drawImage.image = nil;
    UIGraphicsEndImageContext();
}

- (IBAction)resetDrawing:(id)sender {
    UIImage *mouthImage = [UIImage imageNamed:@"mundUdenTekst.png"];
    self.red = 255.0/255.0;
    self.green = 0.0/255.0;
    self.blue = 0.0/255.0;
    self.mainImage.image = mouthImage;
    self.drawImage.image = mouthImage;
    self.brush = 15.0;
    self.opacity = 0.0;
    [self.redBtn setSelected:NO];
    [self.yelBtn setSelected:NO];
    [self.greenBtn setSelected:NO];
}

#pragma mark - Color selection method

- (IBAction)colorPressed:(id)sender {
    UIButton *pressedButton = (UIButton*)sender;
    [pressedButton setSelected:YES];
    [pressedButton setHighlighted:YES];
    if (self.opacity == 0.0)
        self.opacity = 0.7;
    switch (pressedButton.tag) {
        case 0:
            self.red = 255.0/255.0;
            self.green = 0.0/255.0;
            self.blue = 0.0/255.0;
            [self.yelBtn setSelected:NO];
            [self.greenBtn setSelected:NO];
            break;
        case 1:
            self.red = 255.0/255.0;
            self.green = 255.0/255.0;
            self.blue = 0.0/255.0;
            [self.redBtn setSelected:NO];
            [self.greenBtn setSelected:NO];
            break;
        case 2:
            self.red = 102.0/255.0;
            self.green = 255.0/255.0;
            self.blue = 0.0/255.0;
            [self.redBtn setSelected:NO];
            [self.yelBtn setSelected:NO];
            break;
    }
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"mucositisDrawSettingsPopover"]){
        RTBrushSizeViewController *controller = [segue destinationViewController];
        controller.brushSlider.value = self.brush;
        controller.brush = [[NSNumber alloc]initWithFloat:self.brush];
        
        self.popover = [(UIStoryboardPopoverSegue*)segue popoverController];
        self.popover.delegate = self;
        return;
    }    
    if (sender!=self.btnSaveImage)
        self.mainImage.image = nil;
}

-(IBAction)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    UIViewController *sourceViewController = popoverController.contentViewController;
    if([sourceViewController isKindOfClass:[RTBrushSizeViewController class]]){
        RTBrushSizeViewController *controller = (RTBrushSizeViewController*)sourceViewController;
        self.brush = controller.brushSlider.value;
    }
}


@end
