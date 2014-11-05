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
#import "RTAddBloodSampleViewController.h"

@interface RTMedicineViewController : UIViewController <UIPopoverControllerDelegate, RTSelectKemoDelegate, UITextFieldDelegate>

//Views

//@property (weak,nonatomic) IBOutlet UIView *weekSelectorView;
@property (weak, nonatomic) IBOutlet UIView *medicineView;
@property (weak, nonatomic) IBOutlet UIView *addBloodSampleView;

@property (weak, nonatomic) IBOutlet UILabel *highDoseKemoLabel;
@property (weak, nonatomic) IBOutlet UIButton *highDoseKemoButton;
@property (weak, nonatomic) IBOutlet UIButton *editHighDoseKemo;

@property (weak, nonatomic) IBOutlet UITextField *mtxText;
@property (weak, nonatomic) IBOutlet UITextField *m6Text;
@property (weak, nonatomic) IBOutlet UIButton *saveDose;
@property (weak, nonatomic) IBOutlet UIButton *editDose;

//@property (strong,nonatomic) LSWeekView *weekSelector;

@property (strong,nonatomic) RTDataManagement *dataManagement;
@property (strong,nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSString *kemoTypePicked;
@property (strong,nonatomic) NSMutableDictionary *dataAtselectedDate;

- (IBAction)saveDose:(id)sender;
- (IBAction)editDose:(id)sender;


@end
