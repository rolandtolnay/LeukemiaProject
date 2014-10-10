//
//  RTSmileyTableViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 10/10/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTSmileyTableViewController.h"

@interface RTSmileyTableViewController ()

@end

@implementation RTSmileyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//In order to change which pain level each smiley corresponds to, all you have to do is change the tag number
//of its imageview in the storyboard
-(void)didTapSmiley:(id)sender
{
    UITapGestureRecognizer *recognizer = (UITapGestureRecognizer*) sender;
    UIImageView *smiley = (UIImageView*) recognizer.view;
    [self.delegate didSelectSmiley:smiley.tag];
}

@end
