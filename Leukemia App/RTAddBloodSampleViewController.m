//
//  RTAddBloodSampleViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 14/10/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTAddBloodSampleViewController.h"

@interface RTAddBloodSampleViewController ()

@property RTDataManagement *dataManagement;
@property RTService *service;
@property NSDateFormatter *dateFormatter;

@property UIPopoverController* popover;

@end

@implementation RTAddBloodSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManagement = [RTDataManagement singleton];
    self.service = [RTService singleton];
    
    self.dateFormatter = [[NSDateFormatter alloc]init];
    //[self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.tableViewPreviousBloodSamples.dataSource = self;
    
    self.selectedDate = [NSDate date];
    NSDateFormatter *dayShortFormatter = [[NSDateFormatter alloc] init];
    [dayShortFormatter setDateFormat:@"dd/MM"];
    [self.btnDateSelector setTitle:[dayShortFormatter stringFromDate:self.selectedDate] forState:UIControlStateNormal];
    
    [self resetView];
}

#pragma mark - Convenience methods

-(NSInteger)bloodSampleCountBeforeDate: (NSDate*) date{
    NSInteger count = 0;
    
    for(NSMutableDictionary *tempDict in self.dataManagement.medicineData){
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        NSDate *regDate = [self.dateFormatter dateFromString:[tempDict objectForKey:@"date"]];
        if ([self.service isDate:regDate earlierThanDate:date])
        {
            if([tempDict objectForKey:@"bloodSample"] != nil){
                count++;
            }
        }
    }
    return count;
}

-(NSMutableDictionary*)bloodSampleDictionary{
    NSMutableDictionary *daysWithBloodsamples = [[NSMutableDictionary alloc]init];
    NSDate *tempDate;
    NSString *dateString;
    
    for(NSMutableDictionary *tempDict in self.dataManagement.medicineData){
        NSMutableDictionary *bloodSampleDic = [tempDict objectForKey:@"bloodSample"];
        if( bloodSampleDic != nil){
            [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
            tempDate = [self.dateFormatter dateFromString:[tempDict objectForKey:@"date"]];
            [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
            dateString = [self.dateFormatter stringFromDate:tempDate];
            
            [daysWithBloodsamples setObject:bloodSampleDic forKey:dateString];
        }
    }
    return daysWithBloodsamples;
}

//RTAddBloodSampleViewController.m
//Returns an array of dates that have blood samples
-(NSArray*)datesWithBloodSamples
{
    //Number of past entries to look for in dictionary
    NSUInteger entries = 6;
    
    NSMutableArray *dates = [[NSMutableArray alloc]init];
    
    NSInteger bloodSampleCount = [self bloodSampleCountBeforeDate:self.selectedDate];
    if (bloodSampleCount < 6){
        entries = bloodSampleCount;
    }
    
    //the while loop starts by decrementing the current date by 1 day each iteration and checks for a key value in the
    //blood sample dictionary for that date. If it finds one, increases the number of found items, and adds the date to the array.
    //the loop runs until it finds the number of entries it that match the previous requirement (default 6).
    NSUInteger found = 0;
    NSDate *dateToSearch = [self.selectedDate offsetDay:1];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableDictionary *bloodSampleDictionary = [self bloodSampleDictionary];
    while (found < entries) {
        dateToSearch = [dateToSearch offsetDay:-1];
        NSString *keyToSearch = [self.dateFormatter stringFromDate:dateToSearch];
        
        if ([bloodSampleDictionary objectForKey:keyToSearch]!=nil)
        {
            found++;
            [dates addObject:[self.dateFormatter dateFromString:keyToSearch]];
        }
        
    };
    
    return [dates copy];
}

//Returns an array with blood sample values for a given date
-(NSArray *)bloodSampleForDay:(NSDate*) date
{
    NSMutableArray *bloodSample = [[NSMutableArray alloc] init];
    NSMutableDictionary *medicineRegistration = [[self.dataManagement medicineDataAtDate:date] objectForKey:@"bloodSample"];
    [bloodSample addObject:[medicineRegistration objectForKey:@"hemoglobin"]];
    [bloodSample addObject:[medicineRegistration objectForKey:@"thrombocytes"]];
    [bloodSample addObject:[medicineRegistration objectForKey:@"neutrofile"]];
    [bloodSample addObject:[medicineRegistration objectForKey:@"crp"]];
    [bloodSample addObject:[medicineRegistration objectForKey:@"leukocytes"]];
    [bloodSample addObject:[medicineRegistration objectForKey:@"alat"]];
    [bloodSample addObject:[medicineRegistration objectForKey:@"other"]];
    
    return [bloodSample copy];
}

-(NSArray *)kemoForDay:(NSDate*) date
{
    NSMutableArray *kemo = [[NSMutableArray alloc]init];
    NSMutableDictionary *medicineRegistration = [self.dataManagement medicineDataAtDate:date];
    
    [kemo addObject:[medicineRegistration objectForKey:@"mtx"]];
    [kemo addObject:[medicineRegistration objectForKey:@"mercaptopurin"]];
    
    return [kemo copy];
}

-(void)resetView {
    //resets tableview cells
    for (NSIndexPath *indexPath in [self.tableViewPreviousBloodSamples indexPathsForVisibleRows]) {
        RTBloodSampleTableViewCell *cell = (RTBloodSampleTableViewCell*)[self.tableViewPreviousBloodSamples cellForRowAtIndexPath:indexPath];
        for (UILabel *dayLabel in cell.dayLabels)
        {
            dayLabel.hidden = NO;
        }
        for (UIView *separator in cell.daySeparators)
        {
            separator.hidden = NO;
        }
        cell.txfBloodSample.text = @"";
        if (indexPath.section == 1)
            cell.txfBloodSample.hidden = YES;
    }
    //resets dateLabels
    for (UILabel *dateLabel in self.dateLabels)
    {
        dateLabel.hidden = NO;
    }
    
    [self.tableViewPreviousBloodSamples reloadData];
    
    //initializes dateLabels
    //TODO: move this method to main one being called when view is displayed
    NSArray *datesWithBS = [self datesWithBloodSamples];
    NSUInteger entries = [datesWithBS count];
    for (int i = 0; i < 6;i++)
    {
        UILabel *dateLabel = self.dateLabels[i];
        if (i > entries-1 || entries==0)
            dateLabel.hidden = YES;
        else
        {
            NSDateFormatter *shortFormatter = [[NSDateFormatter alloc] init];
            [shortFormatter setDateFormat:@"dd/MM"];
            dateLabel.text = [shortFormatter stringFromDate:datesWithBS[i]];
        }
    }
}

#pragma mark - Sample CRUD

- (IBAction)addSample:(id)sender {
    NSMutableDictionary *sampleData = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *dataTobeSaved = [self.dataManagement medicineDataAtDate:self.selectedDate];
    
    if(dataTobeSaved == nil){
        dataTobeSaved = [self.dataManagement newMedicineData:self.selectedDate];
    }
    
    for (NSIndexPath *path in [self.tableViewPreviousBloodSamples indexPathsForVisibleRows]) {
        if (path.section == 0)
        {
            RTBloodSampleTableViewCell *cell = (RTBloodSampleTableViewCell*)[self.tableViewPreviousBloodSamples cellForRowAtIndexPath:path];
            NSNumber *bloodSampleValue = [NSNumber numberWithInteger:[cell.txfBloodSample.text integerValue]];
            switch (path.row) {
                case 0:
                    [sampleData setObject:bloodSampleValue forKey:@"hemoglobin"];
                    break;
                case 1:
                    [sampleData setObject:bloodSampleValue forKey:@"thrombocytes"];
                    break;
                case 2:
                    [sampleData setObject:bloodSampleValue forKey:@"neutrofile"];
                    break;
                case 3:
                    [sampleData setObject:bloodSampleValue forKey:@"crp"];
                    break;
                case 4:
                    [sampleData setObject:bloodSampleValue forKey:@"leukocytes"];
                    break;
                case 5:
                    [sampleData setObject:bloodSampleValue forKey:@"alat"];
                    break;
                case 6:
                    [sampleData setObject:bloodSampleValue forKey:@"other"];
                    break;
                default:
                    break;
                    
            }
        }
    }
    
    [dataTobeSaved setObject:sampleData forKey:@"bloodSample"];
    [self.dataManagement writeToPList];
    [self resetView];
}



-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"datePicker"]){
        RTGraphCalendarViewController *controller = [segue destinationViewController];
        controller.delegate = self;
        controller.pickedDate = self.selectedDate;
        controller.markedDates = [self.dataManagement datesWithBloodSamplesFromDate:self.selectedDate];
        
        self.popover = [(UIStoryboardPopoverSegue*)segue popoverController];
        self.popover.delegate = self;
    }
}

#pragma mark - Table View DataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"Blood samples";
        case 1: return @"Medicine";
        default: return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return 7;
        case 1: return 2;
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"bloodSampleCell";
    RTBloodSampleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSArray *datesWithBS = [self datesWithBloodSamples];
    
    //hide unnecessary elements from tableview
    NSUInteger bsCount = [datesWithBS count];
    if (bsCount < 6)
    {
        //hide labels
        for (int i = (int)bsCount; i < 6; i++)
        {
            UILabel *dayLabel = cell.dayLabels[i];
            dayLabel.hidden = YES;
        }
        //hide separators
        for (int i = (int)bsCount; i < 5; i++)
        {
            UIView *separator = cell.daySeparators[i];
            separator.hidden = YES;
        }
    } else bsCount = 6; //sets bloodsample count to default number supported
    
    
    //fill elements in tableview
    for (int i=0; i < bsCount; i++)
    {
        NSDate *atDate = datesWithBS[i];
        NSArray *bloodSample = [self bloodSampleForDay:atDate];
        NSArray *kemo = [self kemoForDay:atDate];
        UILabel *dayLabel = cell.dayLabels[i];
        if (indexPath.section == 0)
            [dayLabel setText:[bloodSample[indexPath.row]stringValue]];
        if (indexPath.section == 1)
        {
            [dayLabel setText:[NSString stringWithFormat:@"%@",kemo[indexPath.row]]];
            cell.txfBloodSample.hidden = YES;
        }
    }
    
    return cell;
}

#pragma mark - Calendar Picker Delegate

-(void)dateSelected:(NSDate *)date
{
    self.selectedDate = date;
    NSDateFormatter *dayShortFormatter = [[NSDateFormatter alloc] init];
    [dayShortFormatter setDateFormat:@"dd/MM"];
    [self.btnDateSelector setTitle:[dayShortFormatter stringFromDate:self.selectedDate] forState:UIControlStateNormal];
    
    if ([self.service isDate:date earlierThanDate:[NSDate date]])
        self.btnAddSample.hidden = NO;
    else self.btnAddSample.hidden = YES;
    
    [self.popover dismissPopoverAnimated:YES];
    [self resetView];
}

-(NSArray *)monthChanged:(NSInteger)month
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSString *monthString = [@(month) stringValue];
    NSDate *newDate = [dateFormatter dateFromString:monthString];
    NSLog(@"Month: %@",monthString);
    
    return [self.dataManagement datesWithBloodSamplesFromDate:newDate];
}

@end
