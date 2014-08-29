//
//  RTGraphCalendarViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 28/08/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTGraphCalendarViewController.h"


@interface RTGraphCalendarViewController ()
@end

@implementation RTGraphCalendarViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.calendarView.backgroundColor = [UIColor whiteColor];
    
    self.calendarView.lineSpacing = 0.f;
    self.calendarView.itemSpacing = 0.0f;
    self.calendarView.borderColor = [UIColor mightySlate];
    self.calendarView.borderHeight = 1.f;
    self.calendarView.showsBottomSectionBorder = YES;
    
    self.calendarView.textColor = [UIColor mightySlate];
    self.calendarView.headerTextColor = [UIColor mightySlate];
    self.calendarView.weekdayTextColor = [UIColor grandmasPillow];
    self.calendarView.cellBackgroundColor = [UIColor whiteColor];
    
    self.calendarView.highlightColor = [UIColor pacifica];
    self.calendarView.indicatorColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    
    NSDate *endDate = [NSDate date];
    NSDate *startDate = [endDate dateByAddingMonths:-5];
   
    
    self.calendarView.startDate = startDate;
    self.calendarView.endDate = endDate;
    self.calendarView.selectedDate = startDate;
    self.calendarView.delegate = self;

}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.calendarView.frame = self.view.bounds;
    self.calendarView.contentInset = UIEdgeInsetsMake([self.topLayoutGuide length], 0, [self.bottomLayoutGuide length], 0);
}

#pragma mark - MDCalendarViewDelegate

- (void)calendarView:(MDCalendar *)calendarView didSelectDate:(NSDate *)date {
    NSLog(@"Date picked: %@",date);
    [self.delegate dateSelected:date];
}

@end
