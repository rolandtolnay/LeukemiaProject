//
//  RTGraphWeekPickerViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 23/09/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTGraphWeekPickerViewController.h"

@interface RTGraphWeekPickerViewController ()
 
@end

@implementation RTGraphWeekPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.weeks = [[NSMutableArray alloc] init];
    for (int i=1; i < 54; i++) {
        NSString *week = [NSString stringWithFormat:@"Week %d",i];
        [self.weeks addObject:week];
    }
    
    self.years = @[@"2014",@"2015",@"2016",@"2017",@"2018"];
}

#pragma mark - Picker View Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 5;
    };
    return 53;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0)
        return self.years[row];
    return self.weeks[row];
}

-(NSArray*)allDatesInWeek:(int)weekNumber {
    // determine weekday of first day of year:
    NSCalendar *greg = [[NSCalendar alloc]
                        initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.day = 1;
    NSDate *today = [NSDate date];
    NSDate *tomorrow = [greg dateByAddingComponents:comps toDate:today options:0];
    const NSTimeInterval kDay = [tomorrow timeIntervalSinceDate:today];
    comps = [greg components:NSYearCalendarUnit fromDate:[NSDate date]];
    comps.day = 1;
    comps.month = 1;
    comps.hour = 12;
    NSDate *start = [greg dateFromComponents:comps];
    comps = [greg components:NSWeekdayCalendarUnit fromDate:start];
    if (weekNumber==1) {
        start = [start dateByAddingTimeInterval:-kDay*(comps.weekday-1)];
    } else {
        start = [start dateByAddingTimeInterval:
                 kDay*(8-comps.weekday+7*(weekNumber-2))];
    }
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i<7; i++) {
        [result addObject:[start dateByAddingTimeInterval:kDay*i]];
    }
    return [NSArray arrayWithArray:result];
}


@end
