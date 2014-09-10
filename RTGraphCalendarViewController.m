//
//  RTGraphCalendarViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 09/09/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTGraphCalendarViewController.h"

@interface RTGraphCalendarViewController ()

@property VRGCalendarView *calendar;
@property RTDataManagement* data;

@end

@implementation RTGraphCalendarViewController

- (void)viewDidLoad
{
    self.data = [RTDataManagement singleton];
    
    self.calendar = [[VRGCalendarView alloc] init];
    self.calendar.delegate=self;
    [self.calendarView addSubview:self.calendar];
    [super viewDidLoad];
    
    self.calendar.selectedDate = self.currentDate;
//    [self.calendar markDates:[self.data datesWithGraphFromDate:self.currentDate]];
}



#pragma mark - VRGCalendar Delegate

//FIX CALENDAR DELEGATE METHOD - ONLY CALLED WHEN GOING BACKWARDS IN MONTHS (NICOLAI PLS)
//ALSO DATE IS COLORED RED AFTER THE MARK IS ADDED, SO MARKS FOR CURRENT DAY ARE NOT DISPLAYED WHEN MOVING BETWEEN MONTHS, BECAUSE COLOR OVERRIDES IT
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(NSInteger)month year:(NSInteger)year numOfDays:(NSInteger)days targetHeight:(CGFloat)targetHeight animated:(BOOL)animated{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    
    NSString *monthString = [NSString stringWithFormat: @"%d", (int)month];
    NSDate *newDate = [dateFormatter dateFromString:monthString];
    [self.calendar markDates:[self.data datesWithGraphFromDate:newDate]];
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date{
    [self.delegate dateSelected:date];
}

@end
