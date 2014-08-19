//
//  RTSettingsViewController.h
//  Leukemia App
//
//  Created by DMU-24 on 19/08/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISlider *brushSlider;
@property (weak, nonatomic) IBOutlet UILabel *brushLabel;
@property (weak, nonatomic) IBOutlet UIImageView *brushView;

@property (weak, nonatomic) IBOutlet UISlider *opacitySlider;
@property (weak, nonatomic) IBOutlet UILabel *opacityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *opacityView;

@property (strong,nonatomic) NSNumber* brush;
@property (strong,nonatomic) NSNumber* opacity;

- (IBAction)sliderChanged:(id)sender;

@end
