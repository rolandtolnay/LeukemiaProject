//
//  RTMucositisViewController.h
//  Leukemia App
//
//  Created by DMU-24 on 29/01/15.
//  Copyright (c) 2015 DMU-24. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTDataManagement.h"
#import "RTMouthDrawViewController.h"

@interface RTMucositisViewController : UIViewController <UIPopoverControllerDelegate>

//Mucositis table
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *painButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *rednessButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *foodButtons;
@property (strong, nonatomic) UIColor *btnPressedColor;

//Textfields
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *allTxtFields;
@property (weak, nonatomic) IBOutlet UITextField *vomittingTxt;
@property (weak, nonatomic) IBOutlet UITextField *stoolsTxt;
@property (weak, nonatomic) IBOutlet UITextField *fluidsDrunkTxt;
@property (weak, nonatomic) IBOutlet UITextField *fluidsInDropTxt;
@property (weak, nonatomic) IBOutlet UITextField *urinTxt;
@property (weak, nonatomic) IBOutlet UITextField *weightTxt;

//General properties
@property (strong, nonatomic) RTDataManagement *dataManagement;
@property (strong, nonatomic) NSNumber *painScore;
@property (strong, nonatomic) NSNumber *rednessScore;
@property (strong, nonatomic) NSNumber *foodConsumptionScore;
@property (strong,nonatomic) NSString *drawingPath;
@property (strong,nonatomic) UIImage *drawingToBeSaved;


- (IBAction)saveAndSubmit:(id)sender;
- (IBAction)mucositisTableButtonSelected:(id)sender;

//Ny kode
@end
