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
@property UIPopoverController *detailPopoverController;
@property NSMutableDictionary *selectedRegistration;

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
    
    self.textFieldWeight.delegate = self;
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *selectedDate = self.calendar.selectedDate;
    NSMutableDictionary *dataToBeSaved = [self weightAtDate:selectedDate];
    
    if (dataToBeSaved !=nil)
    {
        [dataToBeSaved setObject:textField.text forKey:@"weight"];
        [self.dataManagement writeToPList];
    }
    else
    {
        dataToBeSaved = [[NSMutableDictionary alloc]init];
        [dataToBeSaved setObject:[dateFormat stringFromDate:selectedDate] forKey:@"time"];
        [dataToBeSaved setObject:textField.text forKey:@"weight"];
        [self.dataManagement.diaryData addObject:dataToBeSaved];
        [self.dataManagement writeToPList];
    }
    
    [textField resignFirstResponder];
    return NO;
}

-(NSMutableDictionary*) weightAtDate:(NSDate*) date
{
    for (NSMutableDictionary *weightRegistration in self.dataManagement.diaryData)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *weightRegDate = [weightRegistration objectForKey:@"time"];
        if ([weightRegDate isEqualToString:[dateFormat stringFromDate:date]])
        {
            return weightRegistration;
        }
    }
    return nil;
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
    
    NSMutableDictionary *weightReg = [self weightAtDate:date];
    [self.textFieldWeight setText:[weightReg objectForKey:@"weight"]];
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

#pragma mark - TableView Delegate

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

#pragma mark - Show details popover

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedRegistration = [self.data objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect displayFrom = CGRectMake(cell.frame.origin.x + cell.frame.size.width / 2, cell.center.y + self.dataTableView.frame.origin.y - self.dataTableView.contentOffset.y, 1, 1);
    self.popoverAnchorButton.frame = displayFrom;
    [self performSegueWithIdentifier:@"detailPopoverSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailPopoverSegue"])
    {
        RTDiaryDetailViewController *detailPopover = [segue destinationViewController];
        detailPopover.selectedData = self.selectedRegistration;
    }
}

@end
