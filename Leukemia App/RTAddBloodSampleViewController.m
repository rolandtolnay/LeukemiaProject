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
    NSMutableDictionary *dataToBeSaved = [[NSMutableDictionary alloc]init];
    
    for (NSIndexPath *path in [self.tableViewPreviousBloodSamples indexPathsForVisibleRows]) {
        
        RTBloodSampleTableViewCell *cell = (RTBloodSampleTableViewCell*)[self.tableViewPreviousBloodSamples cellForRowAtIndexPath:path];
        NSString *bloodSampleValue = cell.txfBloodSample.text;
        
        switch (path.row) {
            case 0:
                [dataToBeSaved setObject:bloodSampleValue forKey:@"hemo"];
                break;
            case 1:
                [dataToBeSaved setObject:bloodSampleValue forKey:@"thrombo"];
                break;
            case 2:
                [dataToBeSaved setObject:bloodSampleValue forKey:@"neutro"];
                break;
            case 3:
                [dataToBeSaved setObject:bloodSampleValue forKey:@"crp"];
                break;
            case 4:
                [dataToBeSaved setObject:bloodSampleValue forKey:@"leukocytter"];
                break;
            case 5:
                [dataToBeSaved setObject:bloodSampleValue forKey:@"alat"];
                break;
            case 6:
                [dataToBeSaved setObject:bloodSampleValue forKey:@"other"];
                break;
            default:
                break;
        }
    }
    
    [self.dataManagement.bloodSampleData setObject:dataToBeSaved forKey:[self.dateFormatter stringFromDate:selectedDate]];
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
    NSMutableDictionary *bloodSampleRegistration = [self.dataManagement.bloodSampleData objectForKey:[self.dateFormatter stringFromDate:date]];
    [bloodSample addObject:[bloodSampleRegistration objectForKey:@"hemo"]];
    [bloodSample addObject:[bloodSampleRegistration objectForKey:@"thrombo"]];
    [bloodSample addObject:[bloodSampleRegistration objectForKey:@"neutro"]];
    [bloodSample addObject:[bloodSampleRegistration objectForKey:@"crp"]];
    [bloodSample addObject:[bloodSampleRegistration objectForKey:@"leukocytter"]];
    [bloodSample addObject:[bloodSampleRegistration objectForKey:@"alat"]];
    [bloodSample addObject:[bloodSampleRegistration objectForKey:@"other"]];
    
    return [bloodSample copy];
}

-(NSArray*)datesWithBloodSamples
{
    NSMutableArray *dates = [[NSMutableArray alloc]init];
    
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

@end
