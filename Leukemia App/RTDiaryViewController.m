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

-(NSMutableArray *)data{
    if(!_data){
        _data = [[NSMutableArray alloc]init];
    }
    return _data;
}

- (void)viewDidLoad
{
    self.dataMangement = [RTDataManagement singleton];
    VRGCalendarView *calendar = [[VRGCalendarView alloc] init];
    calendar.delegate=self;
    [self.calendarView addSubview:calendar];
    
    [self setDateLabels:[NSDate date]];
    
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
    [self setDateLabels: date];
    [self.data removeAllObjects];
    NSString *temp;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *tempDate;
    for (NSMutableDictionary *dict in self.dataMangement.painData){
        temp = [dict objectForKey:@"time"];
        [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm"];
        tempDate = [dateFormat dateFromString:temp];
        if([tempDate day] == [date day] && [tempDate month] == [date month]){
            [self.data addObject:dict];
        }
    }
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
    return cell;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    
//}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}


@end
