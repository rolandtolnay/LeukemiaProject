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

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.smileys = @[@("A"),@("B"),@("C"),@("D"),@("E"),@("F")];
    NSInteger numberOfSteps = ((float)[self.smileys count]-1);
    self.smileySlider.maximumValue = numberOfSteps;
    self.smileySlider.minimumValue = 0;
    
    self.smileySlider.continuous = YES;
    [self.smileySlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    self.smileySlider.value = 0;
    
    self.painDescription = @[
                             @("No hurt"),
                             @("Hurts little bit"),
                             @("Hurts little more"),
                             @("Hurts even more"),
                             @("Hurts whole lot"),
                             @("Hurts worst")
                             ];
}

-(void)valueChanged:(UISlider *)sender {
    NSUInteger index = (NSUInteger)(self.smileySlider.value+0.5);
    [self.smileySlider setValue:index animated:NO];
    NSString *smiley = self.smileys[index];
    self.lblSmileyLetter.text = smiley;
    self.lblPainDescription.text = self.painDescription[index];
    switch(index)
    {
        case 0: self.smileyImage.image = [UIImage imageNamed:@"smileyA"]; break;
        case 1: self.smileyImage.image = [UIImage imageNamed:@"smileyB"]; break;
        case 2: self.smileyImage.image =[UIImage imageNamed:@"smileyC"]; break;
        case 3: self.smileyImage.image =[UIImage imageNamed:@"smileyD"]; break;
        case 4: self.smileyImage.image =[UIImage imageNamed:@"smileyE"]; break;
        case 5: self.smileyImage.image =[UIImage imageNamed:@"smileyF"]; break;
        default: NSLog(@"Image index not recognized"); break;
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
