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
    self.calendar = [[VRGCalendarView alloc] initWithDate:self.pickedDate];
    self.calendar.delegate=self;
    [self.calendarView addSubview:self.calendar];
    
    if (self.markedDates !=nil)
        [self.calendar markDates:self.markedDates];
    
    [super viewDidLoad];
}


#pragma mark - VRGCalendar Delegate
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(NSInteger)month year:(NSInteger)year numOfDays:(NSInteger)days targetHeight:(CGFloat)targetHeight animated:(BOOL)animated{
    
    if(self.pickedDate.month == month && self.pickedDate.year == year){
        self.calendar.selectedDate = self.pickedDate;
    }
    if (self.markedDates !=nil)
    {
        self.markedDates = [self.delegate monthChanged:month];
        NSLog(@"marked dates: %@",self.markedDates);
        [self.calendar markDates:self.markedDates];
    }
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date{
    [self.delegate dateSelected:date];
}

@end
