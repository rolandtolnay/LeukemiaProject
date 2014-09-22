//
//  RTDiaryDetailViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 15/09/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTDiaryDetailViewController : UIViewController

@property NSMutableDictionary *selectedData;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelPainLevel;
@property (weak, nonatomic) IBOutlet UILabel *labelPainType;
@property (weak, nonatomic) IBOutlet UILabel *labelMorphine;
@property (weak, nonatomic) IBOutlet UIImageView *imageDrawing;
@property (weak, nonatomic) IBOutlet UIImageView *imagePhoto;

@property (weak, nonatomic) IBOutlet UILabel *labelNoDrawing;
@property (weak, nonatomic) IBOutlet UILabel *labelNoPhoto;

@end
