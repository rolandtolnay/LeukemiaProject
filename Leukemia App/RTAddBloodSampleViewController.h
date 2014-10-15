//
//  RTAddBloodSampleViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 14/10/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTDataManagement.h"
#import "NSDate+convenience.h"

@interface RTAddBloodSampleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *hemoText;
@property (weak, nonatomic) IBOutlet UITextField *thromboText;
@property (weak, nonatomic) IBOutlet UITextField *neutroText;
@property (weak, nonatomic) IBOutlet UITextField *crpText;
@property (weak, nonatomic) IBOutlet UITextField *leukocytterText;
@property (weak, nonatomic) IBOutlet UITextField *alatText;
@property (weak, nonatomic) IBOutlet UITextField *otherText;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *bloodSampleTextFields;

-(void)saveSampleWithDate:(NSDate*) selectedDate;
-(void)clearTextfields;

@end
