//
//  RTDiaryViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 15/08/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"
#import "NSDate+convenience.h"
#import "RTDataManagement.h"

@interface RTDiaryViewController : UIViewController <VRGCalendarViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (strong, nonatomic) RTDataManagement *dataMangement;
@property (strong, nonatomic) NSMutableArray *data;

@end
