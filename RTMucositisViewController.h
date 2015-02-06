//
//  RTMucositisViewController.h
//  Leukemia App
//
//  Created by DMU-24 on 29/01/15.
//  Copyright (c) 2015 DMU-24. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTDataManagement.h"

@interface RTMucositisViewController : UIViewController

//Mucositis table
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *painButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *rednessButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *foodButtons;
@property (strong, nonatomic) UIColor *btnPressedColor;

//Textfields
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *allTxtFields;

//General properties
@property (strong, nonatomic) RTDataManagement *dataManagement;

- (IBAction)saveAndSubmit:(id)sender;
- (IBAction)mucositisTableButtonSelected:(id)sender;
@end
