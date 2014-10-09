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
#import "RTDataManagement.h"
#import "RTSelectKemoTableViewController.h"
#import "RTSwipeViewController.h"

@interface RTMedicineViewController : RTSwipeViewController <UIPopoverControllerDelegate, RTPopoverContentDelegate>

@property (weak,nonatomic) IBOutlet UIView *weekSelectorView;
@property (weak, nonatomic) IBOutlet UIView *bloodSampleView;
@property (weak, nonatomic) IBOutlet UIView *medicineView;
@property (weak, nonatomic) IBOutlet UILabel *noSampleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addSampleButton;
@property (weak, nonatomic) IBOutlet UIButton *saveSampleButton;
@property (weak, nonatomic) IBOutlet UIButton *editSampleButton;
@property (weak, nonatomic) IBOutlet UILabel *highDoseKemoLabel;
@property (weak, nonatomic) IBOutlet UIButton *highDoseKemoButton;

@property (weak, nonatomic) IBOutlet UITextField *hemoText;
@property (weak, nonatomic) IBOutlet UITextField *thromboText;
@property (weak, nonatomic) IBOutlet UITextField *neutroText;
@property (weak, nonatomic) IBOutlet UITextField *crpText;
@property (weak, nonatomic) IBOutlet UITextField *leukocytterText;
@property (weak, nonatomic) IBOutlet UITextField *mtxText;
@property (weak, nonatomic) IBOutlet UITextField *m6Text;
@property (weak, nonatomic) IBOutlet UITextField *alatText;
@property (weak, nonatomic) IBOutlet UITextField *otherText;
@property (weak, nonatomic) IBOutlet UIButton *saveDose;
@property (weak, nonatomic) IBOutlet UIButton *editDose;

@property (strong,nonatomic) LSWeekView *weekSelector;
@property (strong,nonatomic) RTDataManagement *dataManagement;
@property (strong,nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSString *kemoTypePicked;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *bloodSampleLabels;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *bloodSampleTextFields;

- (IBAction)addSample:(id)sender;
- (IBAction)saveSample:(id)sender;
- (IBAction)editSample:(id)sender;
- (IBAction)saveDose:(id)sender;
- (IBAction)editDose:(id)sender;


@end
