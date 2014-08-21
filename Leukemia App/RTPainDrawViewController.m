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
    
    [self.greenBtn setImage:[UIImage imageNamed:@"btngreen.png"] forState:UIControlStateNormal];
    [self.greenBtn setImage:[UIImage imageNamed:@"greenBtnHighligted.png"] forState:UIControlStateSelected];
    [self.greenBtn setImage:[UIImage imageNamed:@"greenBtnHighligted.png"] forState:UIControlStateHighlighted];
    
    [self.yelBtn setImage:[UIImage imageNamed:@"btnyellow.png"] forState:UIControlStateNormal];
    [self.yelBtn setImage:[UIImage imageNamed:@"yellowBtnHighligted.png"] forState:UIControlStateSelected];
    [self.yelBtn setImage:[UIImage imageNamed:@"yellowBtnHighligted.png"] forState:UIControlStateHighlighted];
    
    [self.redBtn setImage:[UIImage imageNamed:@"redbtn.png"] forState:UIControlStateNormal];
    [self.redBtn setImage:[UIImage imageNamed:@"redBtnHighLighted.png"] forState:UIControlStateSelected];
    [self.redBtn setImage:[UIImage imageNamed:@"redBtnHighLighted.png"] forState:UIControlStateHighlighted];
    [self.redBtn setSelected:YES];
    
    self.redDescription = @"Rød - Det gør så ondt at det er uudholdeligt";
    self.yellowDescription = @"Gul - Det gør ondt, men det er til at holde ud";
    self.greenDescription = @"Grøn - Det gør lidt ondt, men jeg lægger næsten ikke mærke til det";
    [self.painDescriptionTxtField setText:self.redDescription];
    [self.painDescriptionTxtField setTextColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
    
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
    if([[touch view]isEqual:self.drawingView]){
        self.lastPoint = [touch locationInView:self.drawingView];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    self.mouseWiped = YES;
    UITouch *touch = [touches anyObject];
    if([[touch view]isEqual:self.drawingView]){
    CGPoint currentPoint = [touch locationInView:self.drawingView];
    UIGraphicsBeginImageContext(self.drawingView.bounds.size);
    [self.drawImage.image drawInRect:CGRectMake(0, 0, self.drawingView.bounds.size.width, self.drawingView.bounds.size.height)];
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
        UIGraphicsBeginImageContext(self.drawingView.frame.size);
        [self.drawImage.image drawInRect:CGRectMake(0, 0, self.drawingView.bounds.size.width, self.drawingView.bounds.size.height)];
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
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.drawingView.bounds.size.width, self.drawingView.bounds.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    [self.drawImage.image drawInRect:CGRectMake(0, 0, self.drawingView.bounds.size.width, self.drawingView.bounds.size.height) blendMode:kCGBlendModeNormal alpha:self.opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.drawImage.image = nil;
    UIGraphicsEndImageContext();
}

- (IBAction)colorPressed:(id)sender {
    UIButton *pressedButton = (UIButton*)sender;
    [pressedButton setSelected:YES];
    [pressedButton setHighlighted:YES];
    switch (pressedButton.tag) {
        case 0:
            self.red = 255.0/255.0;
            self.green = 0.0/255.0;
            self.blue = 0.0/255.0;
            [self.yelBtn setSelected:NO];
            [self.greenBtn setSelected:NO];
            [self.painDescriptionTxtField setText:self.redDescription];
            break;
        case 1:
            self.red = 255.0/255.0;
            self.green = 255.0/255.0;
            self.blue = 0.0/255.0;
            [self.redBtn setSelected:NO];
            [self.greenBtn setSelected:NO];
            [self.painDescriptionTxtField setText:self.yellowDescription];
            break;
        case 2:
            self.red = 102.0/255.0;
            self.green = 255.0/255.0;
            self.blue = 0.0/255.0;
            [self.redBtn setSelected:NO];
            [self.yelBtn setSelected:NO];
            [self.painDescriptionTxtField setText:self.greenDescription];
            break;
    }
    [self setTextColor];
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

- (IBAction)savingImage:(id)sender {
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"settingsPopover"]){
        RTSettingsViewController *controller = [segue destinationViewController];
        controller.brushSlider.value = self.brush;
        controller.brush = [[NSNumber alloc]initWithFloat:self.brush];
        
        controller.opacitySlider.value = self.opacity;
        controller.opacity = [[NSNumber alloc]initWithFloat:self.opacity];
        
        UIPopoverController* popover = [(UIStoryboardPopoverSegue*)segue popoverController];
        popover.delegate = self;
    }
}

-(IBAction)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    UIViewController *sourceViewController = popoverController.contentViewController;
    if([sourceViewController isKindOfClass:[RTSettingsViewController class]]){
        RTSettingsViewController *controller = (RTSettingsViewController*)sourceViewController;
        self.brush = controller.brushSlider.value;
        self.opacity = controller.opacitySlider.value;
    }

}

-(IBAction)unwindFromSettings:(UIStoryboardSegue*)unwindSegue{
    UIViewController *sourceViewController = unwindSegue.sourceViewController;
    if([sourceViewController isKindOfClass:[RTSettingsViewController class]]){
        RTSettingsViewController *controller = unwindSegue.sourceViewController;
        self.brush = controller.brushSlider.value;
        self.opacity = controller.opacitySlider.value;
    }
}

-(void)setTextColor{
    [self.painDescriptionTxtField setTextColor:[UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1.0]];
}

@end
