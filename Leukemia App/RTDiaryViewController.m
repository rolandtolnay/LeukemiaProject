//
//  RTDiaryViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 15/08/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTDiaryViewController.h"

@interface RTDiaryViewController ()

@end

@implementation RTDiaryViewController

- (void)viewDidLoad
{
    VRGCalendarView *calendar = [[VRGCalendarView alloc] init];
    calendar.delegate=self;
    [self.calendarView addSubview:calendar];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(NSInteger)month year:(NSInteger)year numOfDays:(NSInteger)days targetHeight:(CGFloat)targetHeight animated:(BOOL)animated{
    
}
-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date{
    
}

@end
