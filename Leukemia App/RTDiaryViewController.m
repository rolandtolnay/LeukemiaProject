//
//  RTDiaryViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 15/08/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTDiaryViewController.h"

@interface RTDiaryViewController ()

@property VRGCalendarView *calendar;

@end

@implementation RTDiaryViewController

-(NSMutableArray *)data{
    if(!_data){
        _data = [[NSMutableArray alloc]init];
    }
    return _data;
}

- (void)viewDidLoad
{
    self.dataManagement = [RTDataManagement singleton];
    self.calendar = [[VRGCalendarView alloc] init];
    self.calendar.delegate=self;
    [self.calendarView addSubview:self.calendar];
    
    
    self.dataTableView.delegate = self;
    self.dataTableView.dataSource = self;
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd"];
    NSDate *today = [NSDate date];
    NSLog(@"String for day: %@",today);
    self.calendar.currentMonth = today;
    [self.calendar selectDate:[[dateFormat stringFromDate:today] integerValue]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(NSInteger)month year:(NSInteger)year numOfDays:(NSInteger)days targetHeight:(CGFloat)targetHeight animated:(BOOL)animated{
    
}
-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date{
    [self setDateLabels: date];
    [self.data removeAllObjects];
    NSString *temp;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSDate *painRegDate;
    for (NSMutableDictionary *dict in self.dataManagement.painData){
        temp = [dict objectForKey:@"time"];
        painRegDate = [dateFormat dateFromString:temp];
        if([painRegDate day] == [date day] && [painRegDate month] == [date month]){
            [self.data addObject:dict];
        }
    }
    [self.dataTableView reloadData];
}

-(void)setDateLabels: (NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    self.monthLabel.text = [formatter stringFromDate:date];
    if([date day]<10){
        [formatter setDateFormat:@"d"];
    }
    else{
        [formatter setDateFormat:@"dd"];
    }
    self.dayLabel.text = [formatter stringFromDate:date];
    [formatter setDateFormat:@"EEEE"];
    self.weekDayLabel.text = [formatter stringFromDate:date];
}

//TableView delegates methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSMutableDictionary *painRegistration = [self.data objectAtIndex:indexPath.row];
    NSLog(@"Supposed to show row: %@",painRegistration);
    NSString *hour = [[painRegistration objectForKey:@"time"] componentsSeparatedByString:@" "][1];
    NSString *painLevel = [painRegistration objectForKey:@"painlevel"];
    NSString *painType = [painRegistration objectForKey:@"paintype"];
    NSString *cellText = [NSString stringWithFormat:@"%@ - Pain Level: %@, Type: %@",hour,painLevel,painType];
    
    cell.textLabel.text = cellText;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Pain Registrations";
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}


@end
