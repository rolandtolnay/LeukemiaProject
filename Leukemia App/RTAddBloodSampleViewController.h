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

@interface RTAddBloodSampleViewController : UIViewController <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableViewPreviousBloodSamples;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *dateLabels;

-(void)saveSampleWithDate:(NSDate*) selectedDate;
-(void)resetView;

@end
