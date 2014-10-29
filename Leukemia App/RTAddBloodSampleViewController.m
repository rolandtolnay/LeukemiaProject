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
@property NSInteger counter;


@end

@implementation RTAddBloodSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManagement = [RTDataManagement singleton];
    
    self.dateFormatter = [[NSDateFormatter alloc]init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.tableViewPreviousBloodSamples.dataSource = self;
    
    [self resetView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self datesWithBloodSamples];
    
}

-(void)saveSampleWithDate:(NSDate*) selectedDate
{
    NSMutableDictionary *sampleData = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *dataTobeSaved = [self.dataManagement medicineDataAtDate:selectedDate];
    
    if(dataTobeSaved == nil){
        dataTobeSaved = [self.dataManagement newData:selectedDate];
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

-(NSArray *)bloodSampleForDay:(NSDate*) date
{
    NSMutableArray *bloodSample = [[NSMutableArray alloc] init];
//    NSMutableDictionary *bloodSampleRegistration = [self.dataManagement.bloodSampleData objectForKey:[self.dateFormatter stringFromDate:date]];
    NSMutableDictionary *bloodSampleregistration = [[self.dataManagement medicineDataAtDate:date]objectForKey:@"bloodSample"];
    [bloodSample addObject:[bloodSampleregistration objectForKey:@"hemoglobin"]];
    [bloodSample addObject:[bloodSampleregistration objectForKey:@"thrombocytes"]];
    [bloodSample addObject:[bloodSampleregistration objectForKey:@"neutrofile"]];
    [bloodSample addObject:[bloodSampleregistration objectForKey:@"crp"]];
    [bloodSample addObject:[bloodSampleregistration objectForKey:@"leukocytes"]];
    [bloodSample addObject:[bloodSampleregistration objectForKey:@"alat"]];
    [bloodSample addObject:[bloodSampleregistration objectForKey:@"other"]];
    
    return [bloodSample copy];
}

//-(NSArray*)datesWithBloodSamples
//{
//    NSMutableArray *dates = [[NSMutableArray alloc]init];
//    
//    //Number of past entries to look for in dictionary
//    NSUInteger entries = 6;
//    if ([self.dataManagement.bloodSampleData count]<6){
//        entries = [self.dataManagement.bloodSampleData count];
//    }
//        NSLog(@"Entries to look for: %lu",(unsigned long)entries);
//    NSLog(@"Dictionary with blood samples: %@",self.dataManagement.bloodSampleData);
//    
//    //the while loop starts by decrementing the current date by 1 day each iteration and checks for a key value in the
//    //blood sample dictionary for that date. If it finds one, increases the number of found items, and adds the date to the array.
//    //the loop runs until it finds the number of entries it that match the previous requirement (default 6).
//    NSUInteger found = 0;
//    NSDate *dateToSearch = [[NSDate date] offsetDay:1];
//    
//    
//    while (found<entries) {
//        
//        dateToSearch = [dateToSearch offsetDay:-1];
//        NSString *keyToSearch = [self.dateFormatter stringFromDate:dateToSearch];
//        NSLog(@"keyToSearch: %@",keyToSearch);
//        if ([self.dataManagement.bloodSampleData objectForKey:keyToSearch]!=nil)
//        {
//            found++;
//            [dates addObject:[self.dateFormatter dateFromString:keyToSearch]];
//        }
//        
//    };
//    NSLog(@"Dates with bloodsamples: %@",dates);
//    
//    return [dates copy];
//}

-(NSArray*)datesWithBloodSamples
{
    NSMutableArray *dates = [[NSMutableArray alloc]init];
    NSMutableDictionary *tempDict = [self daysWithBloodSamples];
    //Number of past entries to look for in dictionary
    NSUInteger entries = 6;
    if ([self.dataManagement.bloodSampleData count]<6) entries = [self.dataManagement.bloodSampleData count];
    
    //the while loop starts by decrementing the current date by 1 day each iteration and checks for a key value in the
    //blood sample dictionary for that date. If it finds one, increases the number of found items, and adds the date to the array.
    //the loop runs until it finds the number of entries it that match the previous requirement (default 6).
    NSUInteger found = 0;
    NSDate *dateToSearch = [[NSDate date] offsetDay:1];
    while (found<entries) {
        dateToSearch = [dateToSearch offsetDay:-1];
        NSString *keyToSearch = [self.dateFormatter stringFromDate:dateToSearch];
        if ([self.dataManagement.bloodSampleData objectForKey:keyToSearch]!=nil)
        {
            found++;
            [dates addObject:[self.dateFormatter dateFromString:keyToSearch]];
        }
        
    };
    
    return [dates copy];
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

-(NSMutableDictionary*)daysWithBloodSamples{
   //self.counter = 0;
    NSMutableDictionary *daysWithBloodsamples = [[NSMutableDictionary alloc]init];
    for(NSMutableDictionary *tempDict in self.dataManagement.medicineData){
        if([tempDict objectForKey:@"bloodSample"] != nil){
            //self.counter++;
            [daysWithBloodsamples setObject:tempDict forKey:[tempDict objectForKey:@"date"]];
        }
    }
    return daysWithBloodsamples;
}

@end
