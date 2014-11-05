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
@property NSDateFormatter *dateFormatter;

@property UIPopoverController* popover;

@end

@implementation RTAddBloodSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManagement = [RTDataManagement singleton];
    
    self.dateFormatter = [[NSDateFormatter alloc]init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.tableViewPreviousBloodSamples.dataSource = self;
    
    self.selectedDate = [NSDate date];
    NSDateFormatter *dayShortFormatter = [[NSDateFormatter alloc] init];
    [dayShortFormatter setDateFormat:@"dd/MM"];
    [self.btnDateSelector setTitle:[dayShortFormatter stringFromDate:self.selectedDate] forState:UIControlStateNormal];
    
    NSLog(@"is date: %@ earlier than: %@, RESULT = %hhd",self.selectedDate,[self.selectedDate offsetDay:4],[self isDate:self.selectedDate earlierThanDate:[self.selectedDate offsetDay:4]]);
    
    [self resetView];
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [self datesWithBloodSamples];
//
//}

#pragma mark - Convenience methods

-(BOOL)isDate:(NSDate*) start earlierThanDate:(NSDate*) toCompare
{
    NSComparisonResult result = [start compare:toCompare];
    return (result == NSOrderedAscending || result == NSOrderedSame);
}

-(NSInteger)bloodSampleCountBeforeDate: (NSDate*) date{
    NSInteger count = 0;

    for(NSMutableDictionary *tempDict in self.dataManagement.medicineData){
        
        NSDate *regDate = [self.dateFormatter dateFromString:[tempDict objectForKey:@"date"]];
        
        NSLog(@"Comparing if date: %@ is before %@",regDate,date);
        
        if ([self isDate:regDate earlierThanDate:date])
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
    for(NSMutableDictionary *tempDict in self.dataManagement.medicineData){
        NSMutableDictionary *bloodSampleDic = [tempDict objectForKey:@"bloodSample"];
        if(bloodSampleDic != nil){
            [daysWithBloodsamples setObject:bloodSampleDic forKey:[tempDict objectForKey:@"date"]];
        }
    }
    return daysWithBloodsamples;
}


-(void)resetView {
    //resets tableview cells
    for (NSIndexPath *path in [self.tableViewPreviousBloodSamples indexPathsForVisibleRows]) {
        RTBloodSampleTableViewCell *cell = (RTBloodSampleTableViewCell*)[self.tableViewPreviousBloodSamples cellForRowAtIndexPath:path];
        for (UILabel *dayLabel in cell.dayLabels)
        {
            dayLabel.hidden = NO;
        }
        for (UIView *separator in cell.daySeparators)
        {
            separator.hidden = NO;
        }
        cell.txfBloodSample.text = @"";
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
        
        RTBloodSampleTableViewCell *cell = (RTBloodSampleTableViewCell*)[self.tableViewPreviousBloodSamples cellForRowAtIndexPath:path];
        NSString *bloodSampleValue = cell.txfBloodSample.text;
        
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
    
    [dataTobeSaved setObject:sampleData forKey:@"bloodSample"];
    [self.dataManagement writeToPList];
    [self resetView];
}

-(NSArray *)bloodSampleForDay:(NSDate*) date
{
    NSMutableArray *bloodSample = [[NSMutableArray alloc] init];
    NSMutableDictionary *bloodSampleregistration = [[self.dataManagement medicineDataAtDate:date] objectForKey:@"bloodSample"];
    
    //    NSLog(@"bloodSampleReg: %@",bloodSampleregistration);
    [bloodSample addObject:[bloodSampleregistration objectForKey:@"hemoglobin"]];
    [bloodSample addObject:[bloodSampleregistration objectForKey:@"thrombocytes"]];
    [bloodSample addObject:[bloodSampleregistration objectForKey:@"neutrofile"]];
    [bloodSample addObject:[bloodSampleregistration objectForKey:@"crp"]];
    [bloodSample addObject:[bloodSampleregistration objectForKey:@"leukocytes"]];
    [bloodSample addObject:[bloodSampleregistration objectForKey:@"alat"]];
    [bloodSample addObject:[bloodSampleregistration objectForKey:@"other"]];
    
    return [bloodSample copy];
}

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
    NSMutableDictionary *bloodSampleDictionary = [self bloodSampleDictionary];
    
    while (found < entries) {
        dateToSearch = [dateToSearch offsetDay:-1];
        NSString *keyToSearch = [self.dateFormatter stringFromDate:dateToSearch];
        
        NSLog(@"keyToSearch: %@",keyToSearch);
        
        if ([bloodSampleDictionary objectForKey:keyToSearch]!=nil)
        {
            found++;
            [dates addObject:[self.dateFormatter dateFromString:keyToSearch]];
        }
        
    };
    
    return [dates copy];
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"datePicker"]){
        RTGraphCalendarViewController *controller = [segue destinationViewController];
        controller.delegate = self;
        controller.pickedDate = self.selectedDate;
        
        self.popover = [(UIStoryboardPopoverSegue*)segue popoverController];
        self.popover.delegate = self;
    }
}

#pragma mark - Table View DataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
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
        for (int i = bsCount; i < 6; i++)
        {
            UILabel *dayLabel = cell.dayLabels[i];
            dayLabel.hidden = YES;
        }
        //hide separators
        for (int i = bsCount; i < 5; i++)
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
        UILabel *dayLabel = cell.dayLabels[i];
        dayLabel.text = bloodSample[indexPath.row];
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
    
    [self.popover dismissPopoverAnimated:YES];
    [self resetView];
}

@end
