//
//  RTPainScaleViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 18/08/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTPainScaleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageSmiley;
@property (weak, nonatomic) IBOutlet UILabel *lblPainDescription;
@property (weak, nonatomic) IBOutlet UISlider *sliderPainNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblPainNumber;

@property (strong,nonatomic) NSArray* smileys;
@property (strong,nonatomic) NSArray* numberScale;
@property (strong,nonatomic) NSArray* painDescription;

@end