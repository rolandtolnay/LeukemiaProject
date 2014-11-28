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

-(NSMutableArray *)diaryData{
    if(!_diaryData){
        _diaryData = [[NSMutableArray alloc]init];
    }
    return _diaryData;
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
    self.textFieldProtocol.delegate = self;
    self.textViewNotes.delegate = self;
    
    [self.textViewNotes setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.10]];
    self.textViewNotes.layer.cornerRadius = 10;
    [self.textViewNotes setClipsToBounds:YES];
    
    [self.calendar markDates:[self.dataManagement datesWithDiaryDataFromDate:[NSDate date]]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    self.dateFormat = [[NSDateFormatter alloc]init];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.dateFormat setDateFormat:@"dd"];
    NSDate *dateToShow = [NSDate date];
    if(self.currentSelectedDate != nil){
        dateToShow = self.currentSelectedDate;
    }
    self.calendar.currentMonth = dateToShow;
    [self.calendar selectDate:[[self.dateFormat stringFromDate:dateToShow] integerValue]];
    [super viewWillAppear:animated];
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
    if ([_textFieldProtocol isFirstResponder] && [touch view] != _textFieldProtocol) {
        [_textFieldProtocol resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Notes

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView isEqual:self.textViewNotes])
    {
        if ([textView.text length] > 0) {
            [self.labelNotesPlaceholder setHidden:YES];
        } else {
            [self.labelNotesPlaceholder setHidden:NO];
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView isEqual:self.textViewNotes])
    {
        NSDate *selectedDate = self.calendar.selectedDate;
        NSMutableDictionary *dataToBeSaved = [self.dataManagement diaryDataAtDate:selectedDate];
        
        if (dataToBeSaved !=nil)
        {
            [dataToBeSaved setObject:textView.text forKey:@"notes"];
            [self.dataManagement writeToPList];
        }
        else
        {
            dataToBeSaved = [[NSMutableDictionary alloc]init];
            [self.dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
            [dataToBeSaved setObject:[[RTService singleton] dataID] forKey:@"id"];
            [dataToBeSaved setObject:[self.dateFormat stringFromDate:selectedDate] forKey:@"date"];
            [dataToBeSaved setObject:textView.text forKey:@"notes"];
            [self.dataManagement.diaryData addObject:dataToBeSaved];
            [self.dataManagement writeToPList];
        }
        [self.calendar markDates:[self.dataManagement datesWithDiaryDataFromDate:selectedDate]];
    }
}

#pragma mark - Weight and Protocol Registration

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.textFieldWeight] || [textField isEqual:self.textFieldProtocol])
    {
        if ([textField.text isEqualToString:@"test"])
        {
            [[RTDataManagement singleton] initTestData];
            return;
        }
        
        NSDate *selectedDate = self.calendar.selectedDate;
        NSMutableDictionary *dataToBeSaved = [self.dataManagement diaryDataAtDate:selectedDate];
        
        if (dataToBeSaved !=nil)
        {
            if ([textField.text intValue]>0 || [textField.text isEqualToString:@""])
            {
                if([textField isEqual:self.textFieldWeight]){
                    [dataToBeSaved setObject:[NSNumber numberWithFloat:[textField.text floatValue]]forKey:@"weight"];
                    
                    //make it possible to delete entries
                    if ([textField.text isEqualToString:@""]) [dataToBeSaved removeObjectForKey:@"weight"];
                }
                else if ([textField isEqual:self.textFieldProtocol]){
                    [dataToBeSaved setObject:[NSNumber numberWithInteger:[textField.text integerValue]] forKey:@"protocolTreatmentDay"];
                }
                [self.dataManagement writeToPList];
            }
        }
        else
        {
            if ([textField.text intValue]>0 && ![textField.text isEqualToString:@""])
            {
                dataToBeSaved = [[NSMutableDictionary alloc]init];
                [self.dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                [dataToBeSaved setObject:[[RTService singleton] dataID] forKey:@"id"];
                [dataToBeSaved setObject:[self.dateFormat stringFromDate:selectedDate] forKey:@"date"];
                [dataToBeSaved setObject:self.textViewNotes.text forKey:@"notes"];
                if([textField isEqual:self.textFieldWeight]){
                    [dataToBeSaved setObject:[NSNumber numberWithFloat:[textField.text floatValue]]  forKey:@"weight"];
                }
                else if ([textField isEqual:self.textFieldProtocol]){
                    [dataToBeSaved setObject:[NSNumber numberWithInteger:[textField.text integerValue]]  forKey:@"protocolTreatmentDay"];
                }
                [self.dataManagement.diaryData addObject:dataToBeSaved];
                [self.dataManagement writeToPList];
            }
        }
        [self.calendar markDates:[self.dataManagement datesWithDiaryDataFromDate:selectedDate]];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - CalendarView Delegate

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(NSInteger)month year:(NSInteger)year numOfDays:(NSInteger)days targetHeight:(CGFloat)targetHeight animated:(BOOL)animated{
    
    if(self.currentSelectedDate.month == month && self.currentSelectedDate.year == year){
        [self.dateFormat setDateFormat:@"dd"];
        NSDate *dateToShow = [NSDate date];
        if(self.currentSelectedDate != nil){
            dateToShow = self.currentSelectedDate;
        }
        self.calendar.currentMonth = dateToShow;
        [self.calendar selectDate:[[self.dateFormat stringFromDate:dateToShow] integerValue]];
    }
    
    [self.dateFormat setDateFormat:@"MM"];
    
    NSString *monthString = [@(month) stringValue];
    
    NSDate *newDate = [self.dateFormat dateFromString:monthString];
    [self.calendar markDates:[self.dataManagement datesWithDiaryDataFromDate:newDate]];
    
}
-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date{
    [self setDateLabels: date];
    [self.diaryData removeAllObjects];
    [self.dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *painRegDate;
    NSString *tempDate;
    for (NSMutableDictionary *dict in self.dataManagement.painData){
        tempDate = [dict objectForKey:@"date"];
        painRegDate = [self.dateFormat dateFromString:tempDate];
        if([painRegDate day] == [date day] && [painRegDate month] == [date month]){
            [self.diaryData addObject:dict];
        }
    }
    self.currentSelectedDate = date;
    [self.dataTableView reloadData];
    
    NSMutableDictionary *diaryReg = [self.dataManagement diaryDataAtDate:date];
//    [self.textFieldWeight setText:[[diaryReg objectForKey:@"weight"]stringValue]];
    if([[[diaryReg objectForKey:@"weight"]stringValue]length]>0){
        [self.textFieldWeight setText:[NSString stringWithFormat:@"%.1f",[[diaryReg objectForKey:@"weight"]floatValue]]];
    }else{
        [self.textFieldWeight setText:@""];
    }
    [self.textFieldProtocol setText:[[diaryReg objectForKey:@"protocolTreatmentDay"]stringValue]];
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
    return self.diaryData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSMutableDictionary *painRegistration = [self.diaryData objectAtIndex:indexPath.row];
    [self.dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *date = [self.dateFormat dateFromString:[painRegistration objectForKey:@"date"]];
    [self.dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *hour = [[self.dateFormat stringFromDate:date] componentsSeparatedByString:@" "][1];
    //hour = [NSString stringWithFormat:@"%@:%@",[hour componentsSeparatedByString:@":"][0],[hour componentsSeparatedByString:@":"][1]];
    NSString *painLevel = [[painRegistration objectForKey:@"painlevel"]stringValue];
    NSString *painType = [painRegistration objectForKey:@"paintype"];
    if ([painType isEqualToString:@"Mouth"]){
        painType = NSLocalizedString(@"Mouth", nil);
    }
    else if([painType isEqualToString:@"Stomach"]){
        painType = NSLocalizedString(@"Stomach", nil);
    }
    else if([painType isEqualToString:@"Other"]){
        painType = NSLocalizedString(@"Other", nil);
    }
    NSString *cellText = [NSString stringWithFormat:NSLocalizedString(@"%@ - Pain Level: %@, Type: %@", nil),hour,painLevel,painType];
    
    cell.textLabel.text = cellText;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return NSLocalizedString(@"Pain Registrations", nil);
}

//Delete a registration
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableDictionary *selectedReg = [self.diaryData objectAtIndex:indexPath.row];
        [self.dataManagement.painData removeObject:selectedReg];
        [self.diaryData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Show details popover

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedRegistration = [self.diaryData objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect displayFrom = CGRectMake(cell.frame.origin.x + cell.frame.size.width / 2, cell.center.y + self.dataTableView.frame.origin.y - self.dataTableView.contentOffset.y, 1, 1);
    self.popoverAnchorButton.frame = displayFrom;
    [self performSegueWithIdentifier:@"detailPopoverSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated: YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailPopoverSegue"])
    {
        RTDiaryDetailViewController *detailPopover = [segue destinationViewController];
        detailPopover.selectedData = self.selectedRegistration;
    }
}

#pragma mark - Data export

- (IBAction)exportData:(id)sender {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    RTService *service = [RTService singleton];
    [service performSelectorInBackground: @selector(exportData) withObject:nil];
}
@end
