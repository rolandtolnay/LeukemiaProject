//
//  RTSecondViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 15/08/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSWeekView.h"

@interface RTMedicineViewController : UIViewController

@property (strong,nonatomic) LSWeekView *weekSelector;
@property (weak,nonatomic) IBOutlet UIView *weekSelectorView;

@end
