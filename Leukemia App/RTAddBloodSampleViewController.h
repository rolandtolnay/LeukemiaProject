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

@interface RTAddBloodSampleViewController : UIViewController <UITableViewDataSource,UIPopoverControllerDelegate,RTCalendarPickerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnAddSample;
@property (weak, nonatomic) IBOutlet UIButton *btnDateSelector;
@property (weak, nonatomic) IBOutlet UITableView *tableViewPreviousBloodSamples;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *dateLabels;

@property NSDate *selectedDate;

-(void)resetView;
- (IBAction)addSample:(id)sender;

@end
