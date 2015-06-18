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
//@property UIPopoverController *mucositisDetailController;
@property (nonatomic, strong) RLMResults *painRegistrations;
@property (nonatomic, strong) RLMResults *mucositisRegistrations;
@property (nonatomic, strong) RTDiaryData *diaryRegistration;
@property (nonatomic, strong) RTPainData *selectedRegistration;
@property (nonatomic, strong) RTMucositisData *selectedMucositisRegistration;

@end

@implementation RTDiaryViewController

- (void)viewDidLoad
{
    self.realmService = [RTRealmService singleton];
    self.calendar  = [[VRGCalendarView alloc]initWithDate:[NSDate date]];
    self.calendar.delegate=self;
    [self.calendarView addSubview:self.calendar];
    
    self.dataTableView.delegate = self;
    self.dataTableView.dataSource = self;
    
    self.mucositisDataTableView.delegate = self;
    self.mucositisDataTableView.dataSource = self;
    
    self.textFieldProtocol.delegate = self;
    self.textViewNotes.delegate = self;
    
    [self.textViewNotes setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.10]];
    self.textViewNotes.layer.cornerRadius = 10;
    [self.textViewNotes setClipsToBounds:YES];
  
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
    [self.calendar markDates:[self.realmService datesToBeMarkedInMonthFromDate:[NSDate date]]];
    [super viewWillAppear:animated];
}

//Finishes editing of textview/textfield when user taps outside of it
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([_textViewNotes isFirstResponder] && [touch view] != _textViewNotes) {
        [_textViewNotes resignFirstResponder];
    }
    if ([_textFieldProtocol isFirstResponder] && [touch view] != _textFieldProtocol) {
        [_textFieldProtocol resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Notes registration

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
        
        if ([self.realmService diaryDataOnDate:selectedDate] !=nil)
        {
            RTDiaryData *dataToBeSaved = [self.realmService diaryDataOnDate:selectedDate];
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            dataToBeSaved.notes = textView.text;
            [realm commitWriteTransaction];
        }
        else
        {
            [self saveDiaryDataOnDate:selectedDate];
        }
    }
}

#pragma mark - Protocoltreatmentday Registration

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.textFieldProtocol])
    {
        NSDate *selectedDate = self.calendar.selectedDate;
        
        if ([self.realmService diaryDataOnDate:selectedDate] !=nil)
        {
            if ([textField.text intValue]>0 || [textField.text isEqualToString:@""])
            {
                if ([textField isEqual:self.textFieldProtocol]){
                    RTDiaryData *dataToBeSaved = [self.realmService diaryDataOnDate:selectedDate];
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm beginWriteTransaction];
                    dataToBeSaved.protocolTreatmentDay = [textField.text integerValue];
                    [realm commitWriteTransaction];
                }
            }
        }
        else
        {
            if ([textField.text intValue]>0 && ![textField.text isEqualToString:@""])
            {
                [self saveDiaryDataOnDate:selectedDate];
            }
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Saving diary data helper method
-(void)saveDiaryDataOnDate:(NSDate *) selectedDate{
    RLMRealm *realm = [RLMRealm defaultRealm];
    RTDiaryData *dataToBeSaved = [[RTDiaryData alloc]init];
    dataToBeSaved.dataId = [[RTService singleton] dataID];
    dataToBeSaved.date = selectedDate;
    dataToBeSaved.notes = self.textViewNotes.text;
    dataToBeSaved.protocolTreatmentDay = [self.textFieldProtocol.text integerValue];
    
    [realm beginWriteTransaction];
    [realm addObject:dataToBeSaved];
    [realm commitWriteTransaction];
}

#pragma mark - CalendarView Delegate
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(NSInteger)month year:(NSInteger)year numOfDays:(NSInteger)days targetHeight:(CGFloat)targetHeight animated:(BOOL)animated{
    //Marks the day today in the calendar
    if(self.currentSelectedDate.month == month && self.currentSelectedDate.year == year){
        [self.dateFormat setDateFormat:@"dd"];
        NSDate *dateToShow = [NSDate date];
        if(self.currentSelectedDate != nil){
            dateToShow = self.currentSelectedDate;
        }
        self.calendar.currentMonth = dateToShow;
        [self.calendar selectDate:[[self.dateFormat stringFromDate:dateToShow] integerValue]];
    }
    
    [self.calendar markDates:[self.realmService datesToBeMarkedInMonthFromDate:self.calendar.currentMonth]];
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date{
    [self setDateLabels: date];
    
    //PainData
    self.painRegistrations = [self.realmService painDataOnDate:date];
    self.currentSelectedDate = date;
    [self.dataTableView reloadData];
    
    //MucositisData
    //self.mucositisRegistrations = [self.realmService mucositisDataOnDate:date]; To-Do!!!
    [self.mucositisDataTableView reloadData];
    
    //DiaryData
    self.diaryRegistration = [self.realmService diaryDataOnDate:date];
    [self.textFieldProtocol setText:[@(self.diaryRegistration.protocolTreatmentDay) stringValue]];
    [self.textViewNotes setText:self.diaryRegistration.notes];
    
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
    NSInteger nrOfRows=0;
    if(tableView.tag==0){
        nrOfRows = self.painRegistrations.count;
    }
    //if(tableView.tag==1){
      //  nrOfRows = self.mucositisRegistrations.count;
    //}
    return nrOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(tableView.tag == 0){
        static NSString *CellIdentifier = @"dataCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        RTPainData *painRegistration = [self.painRegistrations objectAtIndex:indexPath.row];
        NSDate *date = painRegistration.date;
        [self.dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *hour = [[self.dateFormat stringFromDate:date] componentsSeparatedByString:@" "][1];
        NSString *painLevel = [@(painRegistration.painLevel) stringValue];
        NSString *painType = painRegistration.painType;
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
    }
//    if(tableView.tag == 1){
//        static NSString *CellIdentifier = @"mucositisDataCell";
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//        RTMucositisData *mucositisRegistration = [self.mucositisRegistrations objectAtIndex:indexPath.row];
//        NSDate *date = mucositisRegistration.date;
//        [self.dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *hour = [[self.dateFormat stringFromDate:date] componentsSeparatedByString:@" "][1];
//        NSInteger totalMucositisScore = mucositisRegistration.painScore+mucositisRegistration.redNessScore+mucositisRegistration.foodScore;
//        
//        NSString *cellText = [NSString stringWithFormat:NSLocalizedString(@"%@ - Total mucositis score: %d", nil),hour,totalMucositisScore];
//        
//        cell.textLabel.text = cellText;
//    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionTitle;
    if(tableView.tag==0){
        sectionTitle = NSLocalizedString(@"Pain Registrations", nil);
    }
//    else if(tableView.tag==1){
//        sectionTitle = NSLocalizedString(@"Mucositis Registrations", nil);
//    }
    return sectionTitle;
}

//Delete a registration
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        if(tableView.tag==0){
        RTPainData *selectedReg = [self.painRegistrations objectAtIndex:indexPath.row];
        [realm beginWriteTransaction];
        [realm deleteObject:selectedReg];
        [realm commitWriteTransaction];
        //[self.painRegistrations removeObjectAtIndex:indexPath.row];
        }
//        if(tableView.tag==1){
//            RTMucositisData *selectedRegMuc = [self.mucositisRegistrations objectAtIndex:indexPath.row];
//            [realm beginWriteTransaction];
//            [realm deleteObject:selectedRegMuc];
//            [realm commitWriteTransaction];
//        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Show details popover
//Select row in TableView
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect displayFrom = CGRectMake(cell.frame.origin.x + cell.frame.size.width / 2, cell.center.y + tableView.frame.origin.y - tableView.contentOffset.y, 1, 1);
    self.popoverAnchorButton.frame = displayFrom;
    
    if(tableView.tag==0){
    self.selectedRegistration = [self.painRegistrations objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"detailPopoverSegue" sender:self];
    }
    
//    if(tableView.tag==1){
//        self.selectedMucositisRegistration = [self.mucositisRegistrations objectAtIndex:indexPath.row];
//        [self performSegueWithIdentifier:@"mucositisPopoverSegue" sender:self];
//    }
    [tableView deselectRowAtIndexPath:indexPath animated: YES];
}
//Segue from TableView
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
