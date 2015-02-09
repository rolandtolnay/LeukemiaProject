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
#import "RTBloodSampleTableViewCell.h"
#import "RTGraphCalendarViewController.h"
#import "RTService.h"

@interface RTAddBloodSampleViewController : UIViewController <UIPopoverControllerDelegate,RTCalendarPickerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnAddSample;
@property (weak, nonatomic) IBOutlet UIButton *btnDateSelector;

@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *bloodSamples;

@property NSDate *selectedDate;

-(void)resetView;
- (IBAction)addSample:(id)sender;

@end
