//
//  RTSmileyTableViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 10/10/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTSmileyTableViewController.h"

@interface RTSmileyTableViewController ()

@property RTDataManagement *datamanagement;

@end

@implementation RTSmileyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datamanagement = [RTDataManagement singleton];
    
    if (self.datamanagement.painScaleBieri)
    {
        self.smileyA.image = [UIImage imageNamed:@"bieriSmileyA"];
        self.smileyB.image = [UIImage imageNamed:@"bieriSmileyB"];
        self.smileyC.image = [UIImage imageNamed:@"bieriSmileyC"];
        self.smileyD.image = [UIImage imageNamed:@"bieriSmileyD"];
        self.smileyE.image = [UIImage imageNamed:@"bieriSmileyE"];
        self.smileyF.image = [UIImage imageNamed:@"bieriSmileyF"];
    } else {
        self.smileyA.image = [UIImage imageNamed:@"smileyA"];
        self.smileyB.image = [UIImage imageNamed:@"smileyB"];
        self.smileyC.image = [UIImage imageNamed:@"smileyC"];
        self.smileyD.image = [UIImage imageNamed:@"smileyD"];
        self.smileyE.image = [UIImage imageNamed:@"smileyE"];
        self.smileyF.image = [UIImage imageNamed:@"smileyF"];
    }
}

//In order to change which pain level each smiley corresponds to, all you have to do is change the tag number
//of its imageview in the storyboard
-(void)didTapSmiley:(id)sender
{
    UITapGestureRecognizer *recognizer = (UITapGestureRecognizer*) sender;
    UIImageView *smiley = (UIImageView*) recognizer.view;
    [self.delegate didSelectSmiley:smiley.tag];
    NSLog(@"pain number: %ld",(long)smiley.tag);
}

@end
