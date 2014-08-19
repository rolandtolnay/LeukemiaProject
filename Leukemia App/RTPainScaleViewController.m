//
//  RTPainScaleViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 18/08/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTPainScaleViewController.h"

@interface RTPainScaleViewController ()

@end

@implementation RTPainScaleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)unwindToPainScale:(UIStoryboardSegue *)segue
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self initSliderPainNumber];
    
    self.smileys = @[@("A"),@("B"),@("C"),@("D"),@("E"),@("F")];
    self.painDescription = @[
                             @("No hurt"),
                             @("Hurts little bit"),
                             @("Hurts little more"),
                             @("Hurts even more"),
                             @("Hurts whole lot"),
                             @("Hurts worst")
                             ];
}

-(void)initSliderPainNumber
{
    self.numberScale = @[@(0),@(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8),@(9),@(10)];
    NSInteger numberOfSteps = ((float)[self.numberScale count]-1);
    self.sliderPainNumber.maximumValue =numberOfSteps;
    self.sliderPainNumber.minimumValue = 0;
    
    self.sliderPainNumber.continuous = YES;
    [self.sliderPainNumber addTarget:self action:@selector(sliderPainNumberChanged:) forControlEvents:UIControlEventValueChanged];
    self.sliderPainNumber.value=0;
}

-(void)sliderPainNumberChanged:(UISlider *)sender {
    NSUInteger index = (NSUInteger)(self.sliderPainNumber.value+0.5);
    [self.sliderPainNumber setValue:index animated:NO];
    NSNumber *painNumber = self.numberScale[index];
    self.lblPainNumber.text = [painNumber stringValue];
    
    if ([painNumber intValue] == 0)
    {
        self.lblPainDescription.text = self.painDescription[0];
        self.imageSmiley.image = [UIImage imageNamed:@"smileyA"];
    } else if ([painNumber intValue] % 2 == 0) painNumber = @([painNumber intValue]-1);
        
    if ([painNumber intValue] % 2 == 1)
    {
        int smileyIndex = ([painNumber intValue]+1)/2;
        
        self.lblPainDescription.text = self.painDescription[smileyIndex];
        NSString *imageName = [@"smiley" stringByAppendingString:self.smileys[smileyIndex]];
        self.imageSmiley.image = [UIImage imageNamed:imageName];
    }
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

@end
