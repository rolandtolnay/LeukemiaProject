//
//  RTSecondViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 15/08/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSWeekView.h"
#import "NSDate+convenience.h"

@interface RTMedicineViewController : UIViewController

@property (weak,nonatomic) IBOutlet UIView *weekSelectorView;
@property (weak, nonatomic) IBOutlet UIView *bloodSampleView;
@property (weak, nonatomic) IBOutlet UIView *medicineView;
@property (weak, nonatomic) IBOutlet UILabel *noSampleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addSampleButton;
@property (weak, nonatomic) IBOutlet UIButton *saveSampleButton;

@property (weak, nonatomic) IBOutlet UITextField *hemoText;
@property (weak, nonatomic) IBOutlet UITextField *thrombotext;
@property (weak, nonatomic) IBOutlet UITextField *neutroText;
@property (weak, nonatomic) IBOutlet UITextField *crptext;
@property (weak, nonatomic) IBOutlet UITextField *natriumtext;

@property (strong,nonatomic) LSWeekView *weekSelector;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *bloodSampleLabels;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *bloodSampleTextFields;

- (IBAction)addSample:(id)sender;
- (IBAction)saveSample:(id)sender;

@end
