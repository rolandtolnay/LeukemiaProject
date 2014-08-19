//
//  RTPainScaleViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 18/08/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTPainScaleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *smileySlider;
@property (weak, nonatomic) IBOutlet UIImageView *smileyImage;
@property (weak, nonatomic) IBOutlet UILabel *lblSmileyLetter;

@property (strong,nonatomic) NSArray* smileys;
@end
