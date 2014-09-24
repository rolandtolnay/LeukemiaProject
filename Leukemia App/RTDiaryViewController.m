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
    self.calendar  = [[VRGCalendarView alloc]initWithDate:[NSDate date]];
    self.calendar.delegate=self;
    [self.calendarView addSubview:self.calendar];
    
    self.dataTableView.delegate = self;
    self.dataTableView.dataSource = self;
    
    self.textFieldWeight.delegate = self;
    self.textViewNotes.delegate = self;
    
    [self.textViewNotes setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.10]];
    self.textViewNotes.layer.cornerRadius = 10;
    [self.textViewNotes setClipsToBounds:YES];
    
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd"];
    NSDate *dateToShow = [NSDate date];
    if(self.currentSelectedDate != nil){
        dateToShow = self.currentSelectedDate;
    }
    self.calendar.currentMonth = dateToShow;
    [self.calendar selectDate:[[dateFormat stringFromDate:dateToShow] integerValue]];
}

//Finishes editing of textview/textfield when user taps outside of it
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([_textViewNotes isFirstResponder] && [touch view] != _textViewNotes) {
        [_textViewNotes resignFirstResponder];
    }
    if ([_textFieldWeight isFirstResponder] && [touch view] != _textFieldWeight) {
        [_textFieldWeight resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Notes

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] > 0) {
//        [textView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.10]];
        
        [self.labelNotesPlaceholder setHidden:YES];
    } else {
//        [textView setBackgroundColor:[UIColor clearColor]];
        [self.labelNotesPlaceholder setHidden:NO];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSDate *selectedDate = self.calendar.selectedDate;
    NSMutableDictionary *dataToBeSaved = [self dataAtDate:selectedDate];
    
    if (dataToBeSaved !=nil)
    {
        [dataToBeSaved setObject:textView.text forKey:@"notes"];
        [self.dataManagement writeToPList];
    }
    else
    {
        dataToBeSaved = [[NSMutableDictionary alloc]init];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        [dataToBeSaved setObject:[dateFormat stringFromDate:selectedDate] forKey:@"time"];
        [dataToBeSaved setObject:textView.text forKey:@"notes"];
        [self.dataManagement.diaryData addObject:dataToBeSaved];
        [self.dataManagement writeToPList];
    }
}

#pragma mark - Weight Registration

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSDate *selectedDate = self.calendar.selectedDate;
    NSMutableDictionary *dataToBeSaved = [self dataAtDate:selectedDate];
    
    if (dataToBeSaved !=nil)
    {
        [dataToBeSaved setObject:textField.text forKey:@"weight"];
        [self.dataManagement writeToPList];
    }
    else
    {
        dataToBeSaved = [[NSMutableDictionary alloc]init];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        [dataToBeSaved setObject:[dateFormat stringFromDate:selectedDate] forKey:@"time"];
        [dataToBeSaved setObject:textField.text forKey:@"weight"];
        [self.dataManagement.diaryData addObject:dataToBeSaved];
        [self.dataManagement writeToPList];
    }
}

-(NSMutableDictionary*) dataAtDate:(NSDate*) date
{
    for (NSMutableDictionary *diaryRegistration in self.dataManagement.diaryData)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *diaryRegDate = [diaryRegistration objectForKey:@"time"];
        if ([diaryRegDate isEqualToString:[dateFormat stringFromDate:date]])
        {
            return diaryRegistration;
        }
    }
    return nil;
}

#pragma mark - CalendarView Delegate

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(NSInteger)month year:(NSInteger)year numOfDays:(NSInteger)days targetHeight:(CGFloat)targetHeight animated:(BOOL)animated{
    if(self.currentSelectedDate.month == month && self.currentSelectedDate.year == year){
        self.calendar.selectedDate = self.currentSelectedDate;
    }
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
    self.currentSelectedDate = date;
    [self.dataTableView reloadData];
    
    NSMutableDictionary *diaryReg = [self dataAtDate:date];
    [self.textFieldWeight setText:[diaryReg objectForKey:@"weight"]];
    [self.textViewNotes setText:[diaryReg objectForKey:@"notes"]];
    [self textViewDidChange:self.textViewNotes];
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
