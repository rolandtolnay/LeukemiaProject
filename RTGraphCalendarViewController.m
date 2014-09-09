//
//  RTGraphCalendarViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 09/09/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTGraphCalendarViewController.h"

@interface RTGraphCalendarViewController ()

@end

@implementation RTGraphCalendarViewController

- (void)viewDidLoad
{
    VRGCalendarView *calendar = [[VRGCalendarView alloc] init];
    calendar.delegate=self;
    [self.calendarView addSubview:calendar];
    [super viewDidLoad];

}

#pragma mark - VRGCalendar Delegate

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(NSInteger)month year:(NSInteger)year numOfDays:(NSInteger)days targetHeight:(CGFloat)targetHeight animated:(BOOL)animated{
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date{
    [self.delegate dateSelected:date];
}

@end
