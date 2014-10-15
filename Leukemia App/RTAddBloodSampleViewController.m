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
}

-(void)viewWillAppear:(BOOL)animated
{
    [self datesWithBloodSamples];

}

-(void)saveSampleWithDate:(NSDate*) selectedDate
{
    //sets placeholder for empty blood sample values
    for (UITextField *txtField in self.bloodSampleTextFields)
    {
        if ([txtField.text isEqualToString:@""])
            txtField.text = @"-";
    }
    
    NSMutableDictionary *dataToBeSaved = [[NSMutableDictionary alloc]init];
    [dataToBeSaved setObject:self.hemoText.text forKey:@"hemo"];
    [dataToBeSaved setObject:self.thromboText.text forKey:@"thrombo"];
    [dataToBeSaved setObject:self.neutroText.text forKey:@"neutro"];
    [dataToBeSaved setObject:self.crpText.text forKey:@"crp"];
    [dataToBeSaved setObject:self.leukocytterText.text forKey:@"leukocytter"];
    [dataToBeSaved setObject:self.alatText.text forKey:@"alat"];
    [dataToBeSaved setObject:self.otherText.text forKey:@"other"];
    [self.dataManagement.bloodSampleData setObject:dataToBeSaved forKey:[self.dateFormatter stringFromDate:selectedDate]];
    [self.dataManagement writeToPList];
    [self resetView];
}

-(void)resetView {
    for (UITextField *txtField in self.bloodSampleTextFields) {
        [txtField setText:@""];
    }
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
    NSLog(@"Entries to look for: %lu",(unsigned long)entries);
    NSLog(@"Dictionary with blood samples: %@",self.dataManagement.bloodSampleData);
    
    //the while loop starts by decrementing the current date by 1 day each iteration and checks for a key value in the
    //blood sample dictionary for that date. If it finds one, increases the number of found items, and adds the date to the array.
    //the loop runs until it finds the number of entries it that match the previous requirement (default 6).
    NSUInteger found = 0;
    NSDate *dateToSearch = [NSDate date];
    
    while (found<entries) {
        
        dateToSearch = [dateToSearch offsetDay:-1];
        NSString *keyToSearch = [self.dateFormatter stringFromDate:dateToSearch];
        NSLog(@"keyToSearch: %@",keyToSearch);
        if ([self.dataManagement.bloodSampleData objectForKey:keyToSearch]!=nil)
        {
            found++;
            [dates addObject:[self.dateFormatter dateFromString:keyToSearch]];
        }
        
    };
    NSLog(@"Dates with bloodsamples: %@",dates);
    
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Pain Registrations";
}

@end
